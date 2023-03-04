class GameRound {
  String? pickedCardId;
  String? votedCardId;
  bool isReadyForNextRound;

  GameRound({
    this.pickedCardId,
    this.votedCardId,
    this.isReadyForNextRound = false,
  });
}
