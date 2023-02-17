import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:meme_card_game/src/features/game/application/game_api_service.dart';
import 'package:meme_card_game/src/features/game/domain/room.dart';
import 'package:meme_card_game/src/features/game/utils/generate_random_situation.dart';
import 'package:meme_card_game/src/models/realtime_exception.dart';
import 'package:meta/meta.dart';
import 'package:nanoid/nanoid.dart' as nanoid;
import 'package:supabase_flutter/supabase_flutter.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final AuthenticationCubit authenticationCubit;

  GameCubit({required this.authenticationCubit}) : super(GameInitialState());

  Room? _room;

  RealtimeChannel? presenceChannel;

  Room? get room => _room;

  Future<void> createGame(String roomName) async {
    try {
      final roomId = nanoid.nanoid();
      print('roomId : $roomId');

      final channel = await GameApiService.createRoom(roomName, roomId);

      _room = Room(
        id: roomId,
        title: roomName,
        createdBy: authenticationCubit.currentUser!.id,
      );

      _setRoomChannel(channel!);

      print(channel.presence.state.toString());
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - createGame - e: $e");
      }
      rethrow;
    }
  }

  RealtimeChannel? throwCardEvent;
  RealtimeChannel? syncEvent;
  void _setRoomChannel(RealtimeChannel channel) async {
    presenceChannel = channel;

    throwCardEvent = presenceChannel!.on(
      // RealtimeListenTypes.presence,
      RealtimeListenTypes.broadcast,
      ChannelFilter(event: 'throwCard'),
      (payload, [ref]) {
        log("payload: $payload");
        log("ref: $ref");
        log("presenceChannel!.joinRef: ${presenceChannel!.joinRef}");

        log("presenceChannel!.presenceState().toString(): ${presenceChannel!.presenceState()}");
      },
    );

    // presenceChannel!.on(
    //   // RealtimeListenTypes.presence,
    //   RealtimeListenTypes.broadcast,
    //   ChannelFilter(event: 'throwCard'),
    //   (payload, [ref]) {
    //     log("payload: $payload");
    //     log("ref: $ref");
    //     log("presenceChannel!.joinRef: ${presenceChannel!.joinRef}");

    //     log("presenceChannel!.presenceState().toString(): ${presenceChannel!.presenceState()}");
    //   },
    // );

    // presenceChannel!.presence.onJoin((key, currentPresences, newPresences) {
    //   log("presenceChannel!.presence.key: " + key.toString());
    //   log("presenceChannel!.presence.currentPresences: " +
    //       currentPresences.toString());
    //   log("presenceChannel!.presence.newPresences: " + newPresences.toString());
    // });

    // dont work
    presenceChannel!.presence.onSync(() {
      final state = presenceChannel!.presenceState();
      print("presenceChannel!.presence.onSync: $state");
    });

    presenceChannel!.presence.channel
        .subscribe((String value, [Object? object]) {
      print('value: $value');
      print('object: $object');
    });
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
      // print('currentRandomSituation: $currentRandomSituation');
      // print('testSendData 1');

      await presenceChannel!.presence.channel.send(
        type: RealtimeListenTypes.broadcast,
        // event: 'sync',
        event: 'throwCard',
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
      // todo: implements
      final channel = await GameApiService.joinRoom(roomId);
      _setRoomChannel(channel!);
    } catch (e) {
      if (kDebugMode) {
        print("GameCubit - joinRoom - e: $e");
      }
      rethrow;
    }
  }

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
