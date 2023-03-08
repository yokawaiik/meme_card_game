import 'package:meme_card_game/src/features/game/domain/enums/broadcast_object_type.dart';

class VoteForNextRound {
  late final String playerId;

  VoteForNextRound({
    required this.playerId,
  });

  VoteForNextRound.fromMap(Map<String, dynamic> data) {
    playerId = data["player_id"];
  }

  Map<String, dynamic> toMap() {
    return {
      "player_id": playerId,
      "object_type": BroadcastObjectType.voteForNextRound.index,
    };
  }
}
