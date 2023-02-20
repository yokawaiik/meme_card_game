import 'package:meme_card_game/src/features/game/domain/models/player.dart';

import '../enums/presence_object_type.dart';

class Room {
  late final String id;
  late String title;
  late String createdBy;
  late bool isClosed;
  late final bool isCreatedByCurrentUser;
  late List<Player>? players;

  Room({
    required this.id,
    required this.title,
    required this.createdBy,
    List<Player>? players,
    this.isClosed = false,
    this.isCreatedByCurrentUser = false,
  }) {
    this.players = players ?? [];
  }

  Room.fromMap(
    Map<String, dynamic> data,
    String currentUserId,
    List<Player>? players,
  ) {
    id = data['id'];
    title = data['title'];
    createdBy = data['created_by'];
    isClosed = data['is_closed'] ?? false;
    isCreatedByCurrentUser = createdBy == currentUserId;
    this.players = players ?? [];
  }

  /// only for game
  Map<String, dynamic> toMap() {
    return {
      'object_type': PresenceObjectType.room.index,
      "id": id,
      "title": title,
      "created_by": createdBy,
      "is_closed": isClosed,
    };
  }

  @override
  String toString() {
    // final playersMapList = players?.map((player) => player.toMap()).toList();

    final room = toMap()
        // ..addAll(
        //   {"players": playersMapList},
        // )
        ;

    return room.toString();
  }

  void addPlayer(Player player) {
    players!.add(player);
  }

  void removePlayer(String id) {
    players!.removeWhere((player) => player.id == id);
  }
}
