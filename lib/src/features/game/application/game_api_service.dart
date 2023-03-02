import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meme_card_game/src/features/game/domain/models/game_card.dart';
import 'package:meme_card_game/src/features/game/domain/models/situation.dart';
import 'package:meme_card_game/src/models/realtime_exception.dart';
import 'package:meme_card_game/src/models/supabase_exception.dart';
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
      }
      rethrow;
    }
  }

  static Future<void> removeRoom(String id) async {
    try {
      await _client.removeChannel(_client.channel(id));
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - createRoom - e: $e");
      }
      rethrow;
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
      }
      rethrow;
    }
  }

  // todo: getSituations
  Future<List<Situation>?> getSituations({String? createdBy}) async {
    try {
      late final PostgrestListResponse rawSituations;

      if (createdBy != null) {
        rawSituations = await _client
            .from("situations")
            .select<PostgrestListResponse>()
            .eq('createdBy', createdBy);
      } else {
        rawSituations =
            await _client.from("situations").select<PostgrestListResponse>();
      }

      if (rawSituations.data == null) {
        throw SupabaseException(null, "Situations wasn't found.");
      }

      final situations = rawSituations.data!
          .map((rawSituation) => Situation.fromMap(rawSituation))
          .toList();

      return situations;
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - getSituations - e: $e");
      }
      rethrow;
    }
  }

  //todo: check getSituation
  Future<Situation?> getSituation(String situationId) async {
    try {
      final rawSituation = await _client
          .from("situations")
          .select<PostgrestResponse>()
          .eq("id", situationId)
          .limit(1)
          .single();

      if (rawSituation.data == null) {
        throw SupabaseException(null, "Situation wasn't found.");
      }

      final situation = Situation.fromMap(rawSituation.data);

      return situation;
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - getSituations - e: $e");
      }
      rethrow;
    }
  }

  //todo: check getCard
  Future<GameCard?> getCard(String cardId) async {
    try {
      final PostgrestResponse rawCard = await _client
          .from("cards")
          .select<PostgrestResponse>()
          .eq("id", cardId)
          .limit(1)
          .single();

      if (rawCard.data == null) {
        throw SupabaseException(null, "Card wasn't found.");
      }

      final card = GameCard.fromMap(rawCard.data, _client.auth.currentUser!.id);

      return card;
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - getCard - e: $e");
      }
      rethrow;
    }
  }

  // todo: check getCards
  Future<List<GameCard>?> getCards(List<String> cardsIdList) async {
    try {
      final PostgrestListResponse rawCards = await _client
          .from("cards")
          .select<PostgrestListResponse>()
          .in_('id', cardsIdList);

      if (rawCards.data == null) {
        throw SupabaseException(null, "Cards wasn't found.");
      }

      final card = rawCards.data!
          .map((rawCard) =>
              GameCard.fromMap(rawCard, _client.auth.currentUser!.id))
          .toList();

      return card;
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - getCards - e: $e");
      }
      rethrow;
    }
  }
}
