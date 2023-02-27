import 'package:meme_card_game/src/features/game/domain/enums/broadcast_object_type.dart';

class VoteForCard {
  late final String playerId;
  late final String cardId;

  VoteForCard({
    required this.playerId,
    required this.cardId,
  });

  VoteForCard.fromMap(Map<String, dynamic> data) {
    playerId = data["player_id"];
    cardId = data["card_id"];
  }

  Map<String, dynamic> toMap() {
    return {
      "player_id": playerId,
      "object_type": BroadcastObjectType.voteForCard.index,
      "card_id": cardId,
    };
  }
}
