import '../enums/broadcast_object_type.dart';

class PlayerConfirmation {
  // late final int objectType;
  late final String playerId;
  late final bool isConfirm;

  PlayerConfirmation(
    this.playerId,
    this.isConfirm,
  );

  PlayerConfirmation.fromMap(Map<String, dynamic> data) {
    playerId = data["player_id"];
    isConfirm = data["is_confirm"];
  }

  Map<String, dynamic> toMap() {
    return {
      "object_type": BroadcastObjectType.confirmation.index,
      "player_id": playerId,
      "is_confirm": isConfirm,
    };
  }
}
