const _defaultAutomaticSituationSelection = true;
const _defaultTimeforConfirmation = 20;
const _defaultTimeforVoteForCard = 60;
const _defaultTimeForChooseSituation = 20;
const _defaultRoundsCount = 7;
const _defaultPlayerStartCardsCount = 7;
const _defaultPlayersCount = 7;

class RoomConfiguration {
  late final bool automaticSituationSelection;
  late final int timeForConfirmation;
  late final int timeForVoteForCard;
  late final int timeForChooseSituation;
  late final int roundsCount;
  late final int playerStartCardsCount;
  late final bool useCreatorCards;
  late final int playersCount;

  /// [timeForConfirmation] when player have to confirm his participation
  /// [timeForVoteForCard] when player have to vote for the better card
  /// [timeForChooseSituation] when player have to choose the situation
  RoomConfiguration({
    this.automaticSituationSelection = true,
    this.timeForConfirmation = 20,
    this.timeForVoteForCard = 60,
    this.timeForChooseSituation = 20,
    this.roundsCount = 7,
    this.playerStartCardsCount = 7,
    this.useCreatorCards = false,
    this.playersCount = 7,
  });

  RoomConfiguration.fromMap(Map<String, dynamic> data) {
    automaticSituationSelection = data["automatic_situation_selection"] ??
        _defaultAutomaticSituationSelection;

    timeForConfirmation = int.tryParse(data["time_for_confirmation"]) ??
        _defaultTimeforConfirmation;
    timeForChooseSituation = int.tryParse(data["time_for_choose_situation"]) ??
        _defaultTimeForChooseSituation;
    roundsCount = int.tryParse(data["rounds_count"]) ?? _defaultRoundsCount;
    timeForVoteForCard = int.tryParse(data["time_for_vote_for_card"]) ??
        _defaultTimeforVoteForCard;
    playerStartCardsCount = int.tryParse(data["player_start_cards_count"]) ??
        _defaultPlayerStartCardsCount;
    useCreatorCards = data["use_creator_cards"] ?? false;
    playersCount = data["players_count"] ?? _defaultPlayersCount;
  }

  Map<String, dynamic> toMap() {
    return {
      "automatic_situation_selection": automaticSituationSelection,
      "time_for_confirmation": timeForConfirmation,
      "time_for_vote_for_card": timeForVoteForCard,
      "time_for_choose_situation": timeForChooseSituation,
      "rounds_count": roundsCount,
      "player_start_cards_count": playerStartCardsCount,
      "use_creator_cards": useCreatorCards,
      "players_count": _defaultPlayersCount,
    };
  }

  @override
  String toString() {
    return 'RoomConfiguration.instance: ${toMap().toString()}';
  }
}
