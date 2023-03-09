import 'package:meme_card_game/src/features/game/domain/enums/broadcast_object_type.dart';

import 'game_card.dart';

class Situation {
  late final String id;
  late final String description;

  /// [cards] only in memory
  late List<GameCard> cards;

  Situation({
    required this.id,
    required this.description,
    List<GameCard>? cards,
  }) {
    this.cards = cards ?? [];
  }

  Situation.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    description = data["description"];
    cards = [];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "object_type": BroadcastObjectType.situation.index,
    };
  }

  @override
  String toString() {
    return "Situation: ${toMap()}.";
  }
}
