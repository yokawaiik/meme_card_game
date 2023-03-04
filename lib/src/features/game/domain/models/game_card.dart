import 'package:meme_card_game/src/features/game/domain/enums/broadcast_object_type.dart';
import 'package:meme_card_game/src/features/game/domain/models/vote_for_card.dart';

/// Card - every user has it in his Room instance
class GameCard {
  late final String userId;
  late final int round;
  late final String situationId;
  late final String cardId;
  late final String imageUrl;

  /// [votesList] only for player memory
  late final List<VoteForCard> votesList;

  /// [isCurrentUser] only for player memory
  late final bool isCurrentUser;
  late bool isImagePicked;

  GameCard({
    required this.userId,
    required this.round,
    required this.situationId,
    required this.cardId,
    required this.imageUrl,
    this.isCurrentUser = false,
    this.isImagePicked = false,
    List<VoteForCard>? votesList,
  }) {
    this.votesList = votesList ?? [];
  }

  GameCard.fromMap(
    Map<String, dynamic> data,
    String? currentUserId,
  ) {
    userId = data["user_id"];
    round = data["round"];
    situationId = data["situation_id"];
    cardId = data["card_id"];
    votesList = [];
    isCurrentUser = userId == currentUserId ? true : false;
    isImagePicked = false;
    imageUrl = data["image_url"];
  }

  Map<String, dynamic> toMap() {
    return {
      "object_type": BroadcastObjectType.card.index,
      "user_id": userId,
      "round": round,
      "situation_id": situationId,
      "card_id": cardId,
      "image_url": imageUrl,
    };
  }
}
