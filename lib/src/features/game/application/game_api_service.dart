import 'package:flutter/foundation.dart';
import 'package:meme_card_game/src/models/realtime_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:collection/collection.dart';

class GameApiService {
  static final _client = Supabase.instance.client;

  static Future<RealtimeChannel?> createRoom(
      String roomTitle, String roomId) async {
    try {
      if (kDebugMode) {
        print(
            'GameApiService - createRoom - _client.realtime.getChannels() : ${_client.realtime.getChannels()}');
      }

      final channel = _client.channel(
        roomId,
        opts: RealtimeChannelConfig(
          key: _client.auth.currentUser!.id,
          self: true,
        ),
      );

      if (channel.isErrored) {
        throw RealtimeException(
          "Room creation error",
          "Channel hasn't been created.",
        );
      }

      return channel;
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - createRoom - e: $e");
        rethrow;
      }
    }
    return null;
  }

// todo throwCard
  static Future<void> throwCard(String roomId, String cardId) async {
    try {
      final channel = _client.channel(
        roomId,
        opts: RealtimeChannelConfig(key: roomId),
      );

      await channel.send(
        type: RealtimeListenTypes.presence,
        event: 'throwCard',
        payload: {
          "user_id": _client.auth.currentUser,
          "throwCard": cardId,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - createRoom - e: $e");
        rethrow;
      }
    }
  }

  static Future<void> removeRoom(String id) async {
    try {
      await _client.removeChannel(_client.channel(id));
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - createRoom - e: $e");
        rethrow;
      }
    }
  }

  static Future<RealtimeChannel?> joinRoom(String roomId) async {
    try {
      final channel = _client.realtime.channel(
        roomId,
        RealtimeChannelConfig(
          key: _client.auth.currentUser!.id,
          ack: false,
          self: true,
        ),
      );

      return channel;
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - joinRoom - e: $e");
        rethrow;
      }
    }
    return null;
  }
}
