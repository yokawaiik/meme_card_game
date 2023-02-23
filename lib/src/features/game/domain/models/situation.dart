import 'package:meme_card_game/src/features/game/domain/models/chosen_card.dart';

class Situation {
  late final String id;
  late final String description;

  /// [chosenCards] only in memory
  late List<ChosenCard> chosenCards;

  Situation({
    required this.id,
    required this.description,
    List<ChosenCard>? chosenCards,
  }) {
    this.chosenCards = chosenCards ?? [];
  }

  Situation.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    description = data["description"];
    chosenCards = [];
  }
}
