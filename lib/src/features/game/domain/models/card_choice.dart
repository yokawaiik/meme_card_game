import 'package:meme_card_game/src/features/game/domain/models/vote_for_card.dart';

/// CardChoice - every user has it in his Room instance
class CardChoice {
  late final String userId;
  late final int round;
  late final int situationId;
  late final String chosenCardId;

  /// [votesList] only for player memory
  late final List<VoteForCard> votesList;

  /// [isCurrentUser] only for player memory
  late final bool isCurrentUser;

  CardChoice({
    required this.userId,
    required this.round,
    required this.situationId,
    required this.chosenCardId,
    this.isCurrentUser = false,
    List<VoteForCard>? votesList,
  }) {
    this.votesList = votesList ?? [];
  }

  CardChoice.fromMap(
    Map<String, dynamic> data,
    String? currentUserId,
  ) {
    userId = data["user_id"];
    round = data["round"];
    situationId = data["situation_id"];
    chosenCardId = data["chosen_card_id"];
    votesList = [];
    isCurrentUser = userId == currentUserId ? true : false;
  }

  Map<String, dynamic> toMap() {
    return {
      "user_id": userId,
      "round": round,
      "situation_id": situationId,
      "chosen_card_id": chosenCardId
    };
  }
}
