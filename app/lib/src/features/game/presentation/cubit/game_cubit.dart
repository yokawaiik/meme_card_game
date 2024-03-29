import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:meme_card_game/src/features/game/application/game_api_service.dart';
import 'package:meme_card_game/src/features/game/domain/models/player.dart';
import 'package:meme_card_game/src/features/game/domain/models/room.dart';
import 'package:meme_card_game/src/features/game/domain/models/room_configuration.dart';
import 'package:meme_card_game/src/features/game/domain/models/taken_cards.dart';
import 'package:meme_card_game/src/features/game/domain/models/vote_for_card.dart';
import 'package:meme_card_game/src/models/realtime_exception.dart';
import 'package:nanoid/nanoid.dart' as nanoid;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/domain/current_user.dart';
import '../../domain/enums/presence_object_type.dart';

import 'package:collection/collection.dart';

import '../../domain/models/game_card.dart';
import '../../domain/models/player_confirmation.dart';
import '../../domain/models/situation.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final AuthenticationCubit authenticationCubit;

  GameCubit({required this.authenticationCubit}) : super(GameInitialState());

  RealtimeChannel? gameChannel;

  Room? room;

  CurrentUser? get currentUser => authenticationCubit.currentUser;

  Future<void> createGame(
    String roomName,
    RoomConfiguration roomConfiguration,
  ) async {
    try {
      emit(LoadingGameState());

      late final List<Situation>? situations;
      late final List<String>? cardsIdList;
      if (roomConfiguration.useCreatorCards) {
        situations = await GameApiService.getSituations(currentUser!.id);

        cardsIdList = await GameApiService.getCardsIdList(currentUser!.id);
      } else {
        situations = await GameApiService.getSituations();
        cardsIdList = await GameApiService.getCardsIdList();
      }

      // ? info : check if cards and situations enough
      if (situations == null) {
        emit(GameFailureState("Situations weren't found."));
      } else if (situations.length >= roomConfiguration.roundsCount) {
        emit(GameFailureState(
            "Situations aren't enough for set up game rounds."));
      }

      if (cardsIdList == null) {
        emit(GameFailureState("Cards weren't found."));
      } else if (cardsIdList.length >=
          (roomConfiguration.playerStartCardsCount *
                  roomConfiguration.playersCount) +
              (roomConfiguration.roundsCount *
                  roomConfiguration.playersCount)) {
        emit(GameFailureState(
            "Cards aren't enough for set up game rounds and users count."));
      }

      situations!.shuffle();
      cardsIdList!.shuffle();

      final roomId = nanoid.nanoid();

      final channel = await GameApiService.createRoom(roomName, roomId);
      gameChannel = channel;

      room = Room(
        id: roomId,
        title: roomName,
        createdBy: authenticationCubit.currentUser!.id,
        isCreatedByCurrentUser: true,
        roomConfiguration: roomConfiguration,
        availableCardIdList: cardsIdList,
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
    // realtimeChannel.on(
    //   RealtimeListenTypes.presence,
    //   ChannelFilter(event: 'sync'),
    //   (payload, [ref]) {
    //     if (realtimeChannel.presence.state.isEmpty) return;
    //   },
    // );

    realtimeChannel.on(
      RealtimeListenTypes.presence,
      ChannelFilter(event: 'join'),
      (payload, [ref]) {
        print("JOIN - payload : $payload");

        if (realtimeChannel.presence.state.isEmpty) return;

        // ? info : load all data in channel state for the first time
        if (room == null) {
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

          room = Room.fromMap(
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
            room!.addPlayer(player);
          }

          // ? info: this room has already been overflown
          if (room!.players!.length >= room!.roomConfiguration.playersCount) {
            if (kDebugMode) {
              print('this room has already been overflown');
            }
            emit(
              GameFailureState(
                RealtimeException(
                    null, 'This room has already been overflown.'),
              ),
            );
            emit(DeletedGameState());
            _deleteRoom();
            _leaveRoom();
          }

          emit(JoinedRoomState());
        }

        if (room != null) {
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

          room!.addPlayer(joinedPlayer);
          if (currentUser!.id == joinedPlayer.id) {
            emit(JoinedRoomState());
          } else {
            emit(NewPlayerJoinedRoomState());
          }
        }

        print('EVENT JOIN - room : ${room}');
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
            // do not to delete players from memory
            if (room!.isGameFinished == false) {
              room!.removePlayer(leftPlayer.id);
            }

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
        try {
          if (room!.isCreatedByCurrentUser) {
            // ? set cards first by creator
            final distributedCards = room!.distributeCards();

            await realtimeChannel.send(
              type: RealtimeListenTypes.broadcast,
              event: "distribute_cards",
              payload: {"distributed_cards": distributedCards},
            );

            // ? add situations
            final situations = await GameApiService.getSituations();

            for (var situation in situations!) {
              room!.addSituation(situation);
            }
          }

          emit(StartedGameState());
        } catch (e) {
          if (kDebugMode) {
            print("EVENT BROADCAST - e: $e.");
          }
          emit(GameFailureState(
              "Something went wrong while game was starting."));
        }
      },
    );

    // ? info: we need to start game with inital cards
    realtimeChannel.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'distribute_cards'),
      (payload, [ref]) async {
        log("EVENT BROADCAST - distribute_cards");

        final distributedCardsRaw =
            payload["distributed_cards"] as List<dynamic>;

        if (kDebugMode) {
          print("distributedCardsRaw: ${distributedCardsRaw}");
        }

        final distributedCards = distributedCardsRaw
            .map((card) => TakenCards.fromMap(card))
            .toList();

        for (var distributedCard in distributedCards) {
          if (kDebugMode) {
            print(
                "distributedCard - takenCardIdList: ${distributedCard.takenCardIdList}");
          }

          // ? info: add cards to user
          if (distributedCard.playerId == currentUser!.id) {
            final gameCards = await GameApiService.getCards(
              distributedCard.takenCardIdList,
              // room!.currentRoundNumber,
            );

            for (var gameCard in gameCards!) {
              room!.addCardToCurrentPlayer(gameCard);
              // print("gameCard was distributed: $gameCard");
            }

            emit(CardsTakenState(currentUser: true));
          }

          for (var cardId in distributedCard.takenCardIdList) {
            room!.removeCardFromAvailableCardIdList(cardId);
          }
        }
        // }
      },
    );

    realtimeChannel.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'pick_situation'),
      (payload, [ref]) async {
        try {
          if (kDebugMode) {
            print('EVENT - pick_situation');
          }

          final situation = await GameApiService.getSituation(
              payload['picked_situation_id'] as String);

          // print("Situation was picked: $situation.");

          room!.pickSituation(situation!);

          if (room!.isCreatedByCurrentUser) {
            room!.currentGameRoundPickSituationId(situation.id);
          }

          emit(GameSitautionPickedState(situation));
        } catch (e) {
          if (kDebugMode) {
            print("EVENT - pick_situation - e: $e.");
          }
          emit(GameFailureState("Something went wrong."));
        }
      },
    );

    realtimeChannel.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'pick_card'),
      (payload, [ref]) async {
        try {
          if (kDebugMode) {
            print('EVENT - pick_card');
          }
          final payloadData = payload['data_object'];

          final gameCard = GameCard.fromMap(payloadData, currentUser!.id);

          room!.addPickedCard(gameCard);

          if (gameCard.isCurrentUser) {
            room!.currentGameRoundPickCardId(gameCard.cardId);
          }
          emit(GamePlayerPickedCardState(gameCard.isCurrentUser));
        } catch (e) {
          if (kDebugMode) {
            print("EVENT - pick_card - e: $e.");
          }
          emit(GameFailureState("Something went wrong."));
        }
      },
    );

    realtimeChannel.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'vote_for_card'),
      (payload, [ref]) {
        try {
          if (kDebugMode) {
            print('EVENT - vote_for_card');
          }

          final payloadData = payload['data_object'];

          final voteForCard = VoteForCard.fromMap(payloadData);

          room!.addVotingResult(voteForCard);

          if (voteForCard.playerId == currentUser!.id) {
            room!.currentGameRoundVoteForCard(voteForCard.cardId);
          }

          emit(GameVotedForCardState());
        } catch (e) {
          if (kDebugMode) {
            print("EVENT - vote_for_card - e: $e.");
          }
          emit(GameFailureState("Something went wrong."));
        }
      },
    );

    realtimeChannel.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'ready_for_next_round'),
      (payload, [ref]) {
        try {
          if (kDebugMode) {
            print('EVENT - ready_for_next_round');
          }

          final userId = payload['data_object']['user_id'];

          if (userId == authenticationCubit.currentUser!.id) {
            room!.currentGameRoundReadyForNextRound();
          }
          room!.someUserReadyForNextRound();

          emit(GameSomePlayerReadyForNextRound());
        } catch (e) {
          if (kDebugMode) {
            print("EVENT - ready_for_next_round - e: $e.");
          }
          emit(GameFailureState(
              "Something went wrong when player sent a readiness."));
        }
      },
    );

    realtimeChannel.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'next_round'),
      (payload, [ref]) async {
        try {
          if (kDebugMode) {
            print('EVENT - next_round');
          }

          //? remove card if user put it
          if (room!.currentGameRound.pickedCardId != null) {
            room!.removeCardFromCurrentPlayer(
                room!.currentGameRound.pickedCardId!);
          }

          // ? info: give out cards
          if (room!.isCreatedByCurrentUser) {
            final distributedCards = room!.distributeCards(count: 1);

            await realtimeChannel.send(
              type: RealtimeListenTypes.broadcast,
              event: "distribute_cards",
              payload: {"distributed_cards": distributedCards},
            );
          }

          room!.nextRound();

          emit(GameNextRoundState());
        } catch (e) {
          if (kDebugMode) {
            print("EVENT - next_round - e: $e.");
          }
          emit(GameFailureState("Something went wrong when next round."));
        }
      },
    );

    realtimeChannel.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'finish_game'),
      (payload, [ref]) {
        try {
          final userId = payload["data_object"]["user_id"] as String;

          if (userId == currentUser!.id) {
            gameChannel!.unsubscribe();
            emit(GameFinishedState());
          }
        } catch (e) {
          if (kDebugMode) {
            print("EVENT - finish_game - e: $e.");
          }
          emit(GameFailureState(
              "Something went wrong when player had been finished the game."));
        }
      },
    );
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
            additionalInfo: isCreator ? room!.toMap() : null,
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
      if (kDebugMode) {
        print("GameCubit - closeRoom");
      }
      emit(LoadingGameState());

      if (room != null && room!.isCreatedByCurrentUser) {
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
      // room - is non-existent
      late final String roomId;
      if (room == null) {
        // ? info : it need, because of room doesn't exist, memory does not contain it
        // ? info : parse name room by created chanel topic
        roomId = gameChannel!.topic.replaceFirst("realtime:", "");
      } else {
        roomId = room!.id;
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
    room = null;
  }

  void addCardToCurrentPlayer(GameCard card) {
    room!.addCardToCurrentPlayer(card);
  }

  void removeCardFromCurrentPlayer(String cardId) {
    room!.removeCardFromCurrentPlayer(cardId);
  }
}
