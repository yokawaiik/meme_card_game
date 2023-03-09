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
  static Future<List<Situation>?> getSituations([String? createdBy]) async {
    try {
      late final List<Map<String, dynamic>> rawSituations;

      if (createdBy != null) {
        rawSituations = await _client
            .from("situations")
            .select<List<Map<String, dynamic>>>()
            .eq('createdBy', createdBy);
      } else {
        rawSituations = await _client
            .from("situations")
            .select<List<Map<String, dynamic>>>();
      }

      if (rawSituations.isEmpty) {
        throw SupabaseException(null, "Situations wasn't found.");
      }

      final situations = rawSituations
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
  static Future<Situation?> getSituation(String situationId) async {
    try {
      final rawSituation = await _client
          .from("situations")
          .select<Map<String, dynamic>?>()
          .eq("id", situationId)
          .limit(1)
          .maybeSingle();

      if (rawSituation == null) {
        throw SupabaseException(null, "Situation wasn't found.");
      }

      final situation = Situation.fromMap(rawSituation);

      return situation;
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - getSituations - e: $e");
      }
      rethrow;
    }
  }

  //todo: check getCard
  static Future<GameCard?> getCard(String cardId) async {
    try {
      final rawCard = await _client
          .from("cards")
          .select<Map<String, dynamic>?>()
          .eq("id", cardId)
          .limit(1)
          .maybeSingle();

      if (rawCard == null) {
        throw SupabaseException(null, "Card wasn't found.");
      }

      final card = GameCard.fromMap(rawCard, _client.auth.currentUser!.id);

      return card;
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - getCard - e: $e");
      }
      rethrow;
    }
  }

  // todo: check getCards
  static Future<List<GameCard>?> getCards(
    List<String> cardsIdList,
    // int roundNumber,
  ) async {
    try {
      final rawCards = await _client
          .from("cards")
          // .select<List<Map<String, dynamic>>>()
          .select<List<Map<String, dynamic>>>()
          .in_('id', cardsIdList);

      if (rawCards.isEmpty) {
        throw SupabaseException(null, "Cards wasn't found.");
      }

      final cards = rawCards
          .map(
            (rawCard) => GameCard.fromDatabaseMap(
              rawCard,
              // roundNumber,
              _client.auth.currentUser!.id,
            ),
          )
          .toList();

      return cards;
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - getCards - e: $e");
      }
      rethrow;
    }
  }

  // todo: check getCardsIdList
  static Future<List<String>?> getCardsIdList([String? createdBy]) async {
    try {
      late final List<Map<String, dynamic>> rawCardsIdList;
      if (createdBy == null) {
        rawCardsIdList =
            await _client.from("cards").select<List<Map<String, dynamic>>>();
      } else {
        rawCardsIdList = await _client
            .from("cards")
            .select<List<Map<String, dynamic>>>()
            .eq("createdBy", createdBy);
      }

      if (rawCardsIdList.isEmpty) {
        throw SupabaseException(null, "Cards wasn't found.");
      }

      final card =
          rawCardsIdList.map((rawCard) => rawCard["id"] as String).toList();

      return card;
    } catch (e) {
      if (kDebugMode) {
        print("GameApiService - getCards - e: $e");
      }
      rethrow;
    }
  }
}
