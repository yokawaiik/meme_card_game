import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:meme_card_game/src/features/game/application/game_api_service.dart';
import 'package:meme_card_game/src/features/game/domain/models/player.dart';
import 'package:meme_card_game/src/features/game/domain/models/room.dart';
import 'package:meme_card_game/src/features/game/domain/models/room_configuration.dart';
import 'package:meme_card_game/src/features/game/domain/models/taken_cards.dart';
import 'package:meme_card_game/src/features/game/utils/generate_random_situation.dart';
import 'package:meme_card_game/src/models/realtime_exception.dart';
import 'package:nanoid/nanoid.dart' as nanoid;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/domain/current_user.dart';
import '../../domain/enums/game_status.dart';
import '../../domain/enums/presence_object_type.dart';

import 'package:collection/collection.dart';

import '../../domain/models/game_card.dart';
import '../../domain/models/player_confirmation.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final AuthenticationCubit authenticationCubit;

  GameCubit({required this.authenticationCubit}) : super(GameInitialState());

  RealtimeChannel? gameChannel;

  Room? _room;
  Room? get room => _room;

  CurrentUser? get currentUser => authenticationCubit.currentUser;

  Future<void> createGame(
    String roomName,
    RoomConfiguration roomConfiguration,
  ) async {
    try {
      emit(LoadingGameState());

      final roomId = nanoid.nanoid();

      final channel = await GameApiService.createRoom(roomName, roomId);
      gameChannel = channel;

      // if (roomConfiguration.useCreatorCards) {
      //    todo: request - get user's cards
      // } else {
      //   todo: request - get public cards
      // }

      final availableCards = List.generate(
        roomConfiguration.playerStartCardsCount *
                roomConfiguration.playersCount +
            roomConfiguration.playersCount * roomConfiguration.roundsCount,
        (index) => "id$index",
      );

      _room = Room(
        id: roomId,
        title: roomName,
        createdBy: authenticationCubit.currentUser!.id,
        isCreatedByCurrentUser: true,
        roomConfiguration: roomConfiguration,
        availableCardIdList: availableCards,
      );

      _setEventHandlers(gameChannel!);
      _joinRoom(gameChannel!, true);
      emit(CreatedGameState());
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - createGame - e: $e");
      }
      rethrow;
    }
  }

  Future<void> joinRoom(String roomId) async {
    try {
      emit(LoadingGameState());
      final channel = await GameApiService.joinRoom(roomId);
      gameChannel = channel;

      _setEventHandlers(gameChannel!);

      _joinRoom(gameChannel!);
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - joinRoom - e: $e");
      }
      rethrow;
    }
  }

  void _setEventHandlers(RealtimeChannel realtimeChannel) {
    realtimeChannel.on(
      RealtimeListenTypes.presence,
      ChannelFilter(event: 'sync'),
      (payload, [ref]) {
        print("------SYNC------");
        if (realtimeChannel.presence.state.isEmpty) return;

        // if (_room != null && _room.isCreatedByCurrentUser) {

        // }
      },
    );

    realtimeChannel.on(
      RealtimeListenTypes.presence,
      ChannelFilter(event: 'join'),
      (payload, [ref]) {
        print("JOIN - payload : $payload");

        if (realtimeChannel.presence.state.isEmpty) return;

        // ? info : load all data in channel state for the first time
        if (_room == null) {
          final presences = realtimeChannel.presence.state.values.first;

          final foundPresenceWithCreator = presences.firstWhereOrNull(
            (presence) =>
                presence.payload['object_type'] ==
                    PresenceObjectType.player.index &&
                presence.payload["is_creator"] == true,
          );

          // ? info : user tried connect to non-existent channel
          if (foundPresenceWithCreator == null) {
            emit(DeletedGameState());
            _deleteRoom();
            _leaveRoom();
          }

          final Map<String, dynamic>? roomMapData =
              foundPresenceWithCreator?.payload["additional_info"];

          if (roomMapData == null) {
            return;
          }

          _room = Room.fromMap(
            roomMapData,
            currentUser!.id,
            [],
          );

          // ? info: add all users to room model

          final foundPresenceWithPlayers = presences
              .where(
                (presence) =>
                    presence.payload['object_type'] ==
                    PresenceObjectType.player.index,
              )
              .toList();

          for (var presence in foundPresenceWithPlayers) {
            final player = Player.fromMap(presence.payload, currentUser!.id);
            _room!.addPlayer(player);
          }

          // ? info: this room has already been overflown
          if (_room!.players!.length >= _room!.roomConfiguration.playersCount) {
            if (kDebugMode) {
              print('this room has already been overflown');
            }
            emit(DeletedGameState());
            _deleteRoom();
            _leaveRoom();
          }

          emit(JoinedRoomState());
        }

        if (_room != null) {
          final foundPresenceWithJoinedPlayer =
              (payload["newPresences"] as List<Presence>).firstWhereOrNull(
            (presence) =>
                presence.payload['object_type'] ==
                PresenceObjectType.player.index,
          );

          if (foundPresenceWithJoinedPlayer == null) return;

          final joinedPlayer = Player.fromMap(
            foundPresenceWithJoinedPlayer.payload,
            currentUser!.id,
          );

          _room!.addPlayer(joinedPlayer);
          if (currentUser!.id == joinedPlayer.id) {
            emit(JoinedRoomState());
          } else {
            emit(NewPlayerJoinedRoomState());
          }
        }

        print('EVENT JOIN - _room : ${_room}');
      },
    );

    realtimeChannel.on(
      RealtimeListenTypes.presence,
      ChannelFilter(event: 'leave'),
      (payload, [ref]) {
        if (realtimeChannel.presence.state.isEmpty) return;

        final foundPresenceWithLeftPlayer =
            (payload["leftPresences"] as List<Presence>).firstWhereOrNull(
          (presence) =>
              presence.payload['object_type'] ==
              PresenceObjectType.player.index,
        );

        if (foundPresenceWithLeftPlayer == null) return;
        final leftPlayer = Player.fromMap(
          foundPresenceWithLeftPlayer.payload,
          currentUser!.id,
        );

        log("LEAVE - player left : $leftPlayer");

        if (leftPlayer.isCreator) {
          emit(DeletedGameState());
          _deleteRoom();
          _leaveRoom();
        } else {
          if (leftPlayer.id == currentUser!.id) {
            emit(LeftRoomState());
            _leaveRoom();
          } else {
            _room!.removePlayer(leftPlayer.id);
            emit(PlayerLeftRoomState());
          }
        }
      },
    );

    realtimeChannel.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'confirm_game_start'),
      (payload, [ref]) async {
        log("EVENT BROADCAST - confirm_game_start");

        final playerConfirmation =
            PlayerConfirmation.fromMap(payload["data_object"]);
        room!.setConfirmation(playerConfirmation);

        // take cards

        // final takenCardsPayload = TakenCards(
        //   playerId: currentUser!.id,
        //   takenCardIdList: ,
        // );
        // await realtimeChannel.send(
        //   type: RealtimeListenTypes.broadcast,
        //   event: 'distribute_cards',
        //   payload: takenCardsPayload,
        // );

        // todo: check who is confirm
        if (playerConfirmation.playerId == currentUser!.id) {
          emit(ConfirmedGameState());
        } else {
          emit(SomePlayerConfirmedGameState());
        }
      },
    );

    realtimeChannel.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'game_start'),
      (payload, [ref]) async {
        log("EVENT BROADCAST - game_start");

        room!.setStatus(GameStatus.started);

        // ? set cards first by creator
        if (room!.isCreatedByCurrentUser) {
          final distributedCards = _room!.initialCardsDistribution();

          await realtimeChannel.send(
            type: RealtimeListenTypes.broadcast,
            event: "distribute_cards",
            payload: distributedCards,
          );
        }

        emit(StartedGameState());
      },
    );

    // ? info: we need to start game with inital cards
    realtimeChannel.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'distribute_cards'),
      (payload, [ref]) {
        log("EVENT BROADCAST - distribute_cards");

        print(payload["distributed_cards"]);
        print(_room!.availableCardIdList);

        if (!_room!.isCreatedByCurrentUser) {
          final distributedCardsRaw =
              payload["distributed_cards"] as List<Map<String, dynamic>>;

          final distributedCards = distributedCardsRaw
              .map((card) => TakenCards.fromMap(card))
              .toList();

          // todo: Add Card to current user
          // todo: load cards

          for (var playerCards in distributedCards) {
            for (var cardId in playerCards.takenCardIdList) {
              _room!.removeCardFromAvailableCardIdList(cardId);
            }
          }

          print(distributedCardsRaw);
          print(_room!.availableCardIdList);

          emit(CardsTakenState());
        }
      },
    );

    // todo: take_card after round's end
    realtimeChannel.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'taken_card'),
      (payload, [ref]) {
        log("EVENT BROADCAST - taken_card");

        final takenCardsRaw = payload["taken_card"] as Map<String, dynamic>;
        final takenCards = TakenCards.fromMap(takenCardsRaw);

        print(takenCards);

        // todo : request card from db

        emit(CardsTakenState());
      },
    );

    // todo: choose_situation
    // realtimeChannel.on(
    //   RealtimeListenTypes.broadcast,
    //   ChannelFilter(event: 'choose_situation'),
    //   (payload, [ref]) {
    //     final payloadData = payload['throw_card'];
    //     print('throw_card - payload: $payloadData');
    //     final throwCard = List<String>.from(payload['throw_card']);
    //     print('throw_card payload[throw_card] : ${throwCard}');
    //   },
    // );

    // todo: choose_card
    // todo: remove card form currentPlayerCard
    // realtimeChannel.on(
    //   RealtimeListenTypes.broadcast,
    //   ChannelFilter(event: 'choose_card'),
    //   (payload, [ref]) {
    //     final payloadData = payload['throw_card'];
    //     print('throw_card - payload: $payloadData');
    //     final throwCard = List<String>.from(payload['throw_card']);
    //     print('throw_card payload[throw_card] : ${throwCard}');
    //   },
    // );

    // todo: vote_for_card
    // realtimeChannel.on(
    //   RealtimeListenTypes.broadcast,
    //   ChannelFilter(event: 'vote_for_card'),
    //   (payload, [ref]) {
    //     final payloadData = payload['throw_card'];
    //     print('throw_card - payload: $payloadData');
    //     final throwCard = List<String>.from(payload['throw_card']);
    //     print('throw_card payload[throw_card] : ${throwCard}');
    //   },
    // );

    // todo: vote_for_next_round
    // realtimeChannel.on(
    //   RealtimeListenTypes.broadcast,
    //   ChannelFilter(event: 'vote_for_next_round'),
    //   (payload, [ref]) {
    //     final payloadData = payload['throw_card'];
    //     print('throw_card - payload: $payloadData');
    //     final throwCard = List<String>.from(payload['throw_card']);
    //     print('throw_card payload[throw_card] : ${throwCard}');
    //   },
    // );

    // todo: finish
    // realtimeChannel.on(
    //   RealtimeListenTypes.broadcast,
    //   ChannelFilter(event: 'throw_card'),
    //   (payload, [ref]) {
    //     final payloadData = payload['throw_card'];
    //     print('throw_card - payload: $payloadData');
    //     final throwCard = List<String>.from(payload['throw_card']);
    //     print('throw_card payload[throw_card] : ${throwCard}');
    //   },
    // );
  }

  void _joinRoom(
    RealtimeChannel realtimeChannel, [
    bool isCreator = false,
  ]) {
    realtimeChannel.subscribe(
      (status, [ref]) async {
        if (status == 'SUBSCRIBED') {
          final newPlayer = Player(
            id: currentUser!.id,
            login: currentUser!.login,
            isCurrentUser: true,
            isCreator: isCreator,
            color: currentUser!.color,
            backgroundColor: currentUser!.backgroundColor,
            additionalInfo: isCreator ? _room!.toMap() : null,
          );

          await realtimeChannel.track(
            newPlayer.toMap(),
          );
        }
      },
    );
  }

  Future<void> confirmParticipation(bool isConfirm) async {
    try {
      emit(ConfirmLoadingGameState());

      // todo: implements
      final payload = PlayerConfirmation(
        currentUser!.id,
        isConfirm,
      ).toMap();

      await gameChannel!.send(
        type: RealtimeListenTypes.broadcast,
        event: "confirm_game_start",
        payload: {
          "data_object": payload,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - confirmParticipation - e: $e");
      }
      rethrow;
    }
  }

  Future<void> startGame() async {
    try {
      emit(LoadingGameState());
      await gameChannel!.send(
        type: RealtimeListenTypes.broadcast,
        event: "game_start",
        payload: {},
      );
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - confirmParticipation - e: $e");
      }
      rethrow;
    }
  }

  Future<void> closeRoom() async {
    try {
      emit(LoadingGameState());

      if (_room != null && _room!.isCreatedByCurrentUser) {
        emit(DeletedGameState());
        await _deleteRoom();
        await _leaveRoom();
      } else {
        emit(LeftRoomState());
        await _leaveRoom();
      }
      emit(GameInitialState());
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - closeRoom - e: $e");
      }
      rethrow;
    }
  }

  Future<void> _deleteRoom() async {
    try {
      // todo: implements

      // room - is non-existent
      late final String roomId;
      if (room == null) {
        // ? info : it need, because of room doesn't exist, memory does not contain it
        // ? info : parse name room by created chanel topic
        roomId = gameChannel!.topic.replaceFirst("realtime:", "");
      } else {
        roomId = _room!.id;
      }
      await GameApiService.removeRoom(roomId);
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - _deleteRoom - e: $e");
      }
      rethrow;
    }
  }

  /// _leaveRoom() - unsubscribe and delete all data
  Future<void> _leaveRoom() async {
    await gameChannel?.unsubscribe();
    gameChannel = null;
    _room = null;
  }

  void addCardToCurrentPlayer(GameCard card) {
    _room!.addCardToCurrentPlayer(card);
  }

  void removeCardFromCurrentPlayer(String cardId) {
    _room!.removeCardFromCurrentPlayer(cardId);
  }
}
