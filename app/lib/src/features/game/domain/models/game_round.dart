class GameRound {
  String? pickedSituationId;
  String? pickedCardId;
  String? votedCardId;
  bool isReadyForNextRound;

  GameRound({
    this.pickedSituationId,
    this.pickedCardId,
    this.votedCardId,
    this.isReadyForNextRound = false,
  });
}
