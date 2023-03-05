/// TakenCards - when user gets new card
class TakenCards {
  late final String playerId;
  late final List<String> takenCardIdList;

  TakenCards({
    required this.playerId,
    required this.takenCardIdList,
  });

  TakenCards.fromMap(Map<String, dynamic> data) {
    playerId = data["player_id"];
    takenCardIdList = (data["taken_card_id_list"] as List<dynamic>)
        .map((item) => item.toString())
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "player_id": playerId,
      "taken_card_id_list": takenCardIdList,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
