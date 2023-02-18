import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:meme_card_game/src/features/game/application/game_api_service.dart';
import 'package:meme_card_game/src/features/game/domain/player.dart';
import 'package:meme_card_game/src/features/game/domain/room.dart';
import 'package:meme_card_game/src/features/game/utils/generate_random_situation.dart';
import 'package:meme_card_game/src/models/realtime_exception.dart';
import 'package:nanoid/nanoid.dart' as nanoid;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/domain/current_user.dart';
import '../../domain/enums/presence_object_type.dart';

import 'package:collection/collection.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final AuthenticationCubit authenticationCubit;

  GameCubit({required this.authenticationCubit}) : super(GameInitialState());

  Room? _room;

  RealtimeChannel? presenceChannel;

  Room? get room => _room;

  CurrentUser? get currentUser => authenticationCubit.currentUser;

  Future<void> createGame(String roomName) async {
    try {
      final roomId = nanoid.nanoid();

      final channel = await GameApiService.createRoom(roomName, roomId);

      _room = Room(
        id: roomId,
        title: roomName,
        createdBy: authenticationCubit.currentUser!.id,
      );

      _setRoomChannel(channel!);

      if (kDebugMode) {
        print("GameCubit - createGame - _room : $_room");
      }
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - createGame - e: $e");
      }
      rethrow;
    }
  }

  void _setRoomChannel(RealtimeChannel channel) async {
    presenceChannel = channel;
    // if (room == null) {
    //   throw RealtimeException("Realtime error", "Room hasn't been crated.");
    // }

    presenceChannel!.on(RealtimeListenTypes.presence,
        ChannelFilter(event: 'sync'), (payload, [ref]) {});

    presenceChannel!.on(
      RealtimeListenTypes.presence,
      ChannelFilter(event: 'join'),
      (payload, [ref]) {
        // ? info : listens join
        // print("JOIN - : ${presenceChannel!..map((presences as Presence) {
        //   presences as Presence;
        //   return presences;
        // })}");
        print('JOIN - payload: ${payload}');
        print(
            'JOIN - presenceChannel!.presence.state.value: ${presenceChannel!.presence.state.values}');
      },
    );
    presenceChannel!.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'game_lobby'),
      (payload, [ref]) {
        print('game_lobby - payload: $payload');

        final participantIds = List<String>.from(payload['participants']);
        print('participantIds: ${participantIds}');
      },
    );
    presenceChannel!.on(
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'throw_card'),
      (payload, [ref]) {
        final payloadData = payload['throw_card'];
        print('throw_card - payload: $payloadData');
        final throwCard = List<String>.from(payload['throw_card']);
        print('throw_card payload[throw_card] : ${throwCard}');
      },
    );
    presenceChannel!.subscribe(
      (status, [ref]) async {
        if (status == 'SUBSCRIBED') {
          await presenceChannel!.track(
            room!.toMap(),
          );

          final newPlayer = Player(
            id: currentUser!.id,
            login: currentUser!.login,
            isCurrentUser: true,
            isCreator: currentUser!.id == room!.createdBy,
            color: currentUser!.color,
            backgroundColor: currentUser!.backgroundColor,
          );

          await presenceChannel!.track(
            newPlayer.toMap(),
          );
        }
      },
    );
  }

  Future<void> throwCard() async {
    try {
      // todo: remove it after debug
      final currentRandomSituation = generateRandomSituation(100).toString();

      // presenceChannel
      //

      await GameApiService.throwCard(_room!.id, currentRandomSituation);
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - createGame - e: $e");
      }
      rethrow;
    }
  }

// todo: delete it later
  Future<void> testSendData() async {
    print('testSendData');
    try {
      final currentRandomSituation = generateRandomSituation(100).toString();

      await presenceChannel!.presence.channel.send(
        type: RealtimeListenTypes.broadcast,
        // event: 'sync',
        event: 'throw_card',
        payload: {
          // "user_id": _client.auth.currentUser,
          // "throwCard": cardId,
          "user_id": "current_user_id",
          "throwCard": currentRandomSituation,
        },
      );

      print('testSendData 2');

      presenceChannel!.send(type: RealtimeListenTypes.presence, payload: {
        "user_id": "current_user_id",
        "throwCard": currentRandomSituation,
      });
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - createGame - e: $e");
      }
      rethrow;
    }
  }

  Future<void> joinRoom(String roomId) async {
    try {
      final channel = await GameApiService.joinRoom(roomId);
      presenceChannel = channel;

      presenceChannel!.on(
        RealtimeListenTypes.presence,
        ChannelFilter(event: 'sync'),
        (payload, [ref]) async {
          final presences = presenceChannel!.presence.state.values.first;

          // search for room
          final foundPresenceWithRoom = presences.firstWhereOrNull((presence) =>
              presence.payload['object_type'] == PresenceObjectType.room);

          if (foundPresenceWithRoom != null) {
            _room = Room.fromMap(foundPresenceWithRoom.payload);
            print(_room);
          } else {
            await presenceChannel!.unsubscribe();
            throw RealtimeException(
              "Join error.",
              "Room hasn't been found.",
              KindOfException.joinError,
            );
          }
        },
      );

      presenceChannel!.subscribe(
        (status, [ref]) async {
          if (status == 'SUBSCRIBED') {
            final newPlayer = Player(
              id: currentUser!.id,
              login: currentUser!.login,
              isCurrentUser: true,
              isCreator: false,
              color: currentUser!.color,
              backgroundColor: currentUser!.backgroundColor,
            );

            await presenceChannel!.track(
              newPlayer.toMap(),
            );
          }
        },
      );

      // _setRoomChannel(channel!);
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - joinRoom - e: $e");
      }
      rethrow;
    }
  }

  void _setEventHandlers(RealtimeChannel realtimeChannel) {}

  void _createRoom() {}

  void _joinRoom() {}

  Future<void> closeRoom() async {
    try {
      if (room == null) {
        throw RealtimeException(
          "Error realtime channel",
          "Channel wasn't created.",
        );
      }
      if (authenticationCubit.currentUser!.id == room!.createdBy) {}

      await presenceChannel?.unsubscribe();
      await GameApiService.removeRoom(_room!.id);
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - joinRoom - e: $e");
      }
      rethrow;
    }
  }
}
