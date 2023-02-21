import 'package:meme_card_game/src/features/game/domain/enums/game_status.dart';
import 'package:meme_card_game/src/features/game/domain/models/player.dart';
import 'package:meme_card_game/src/features/game/domain/models/player_confirmation.dart';
import 'package:meme_card_game/src/features/game/domain/models/room_configuration.dart';

import '../enums/presence_object_type.dart';

class Room {
  late final String id;
  late String title;
  late String createdBy;
  late final bool isCreatedByCurrentUser;
  late List<Player>? players;

  /// [status] game status
  late GameStatus status;

  late RoomConfiguration roomConfiguration;

  /// [isAllPlayersConfirmed] to start game
  bool get isAllPlayersConfirm {
    return players?.every((player) => player.isConfirm) ?? false;
  }

  Room({
    required this.id,
    required this.title,
    required this.createdBy,
    List<Player>? players,
    this.isCreatedByCurrentUser = false,
    this.status = GameStatus.lobby,
    RoomConfiguration? roomConfiguration,
  }) {
    this.players = players ?? [];
    this.roomConfiguration = roomConfiguration ?? RoomConfiguration();
  }

  Room.fromMap(
    Map<String, dynamic> data,
    String currentUserId,
    List<Player>? players,
  ) {
    id = data['id'];
    title = data['title'];
    createdBy = data['created_by'];
    isCreatedByCurrentUser = createdBy == currentUserId;
    this.players = players ?? [];
    status = data['game_status'] ?? GameStatus.lobby;
    roomConfiguration = data['room_configuration'] == null
        ? RoomConfiguration.fromMap(data['room_configuration'])
        : RoomConfiguration();
  }

  /// only for game
  Map<String, dynamic> toMap() {
    return {
      'object_type': PresenceObjectType.room.index,
      "id": id,
      "title": title,
      "created_by": createdBy,
      "game_status": status.index,
      "room_configuration": roomConfiguration.toMap(),
    };
  }

  @override
  String toString() {
    final playersMapList = players?.map((player) => player.toMap()).toList();

    final room = toMap()
      ..addAll(
        {"players": playersMapList},
      );

    return room.toString();
  }

  void addPlayer(Player player) {
    players!.add(player);
  }

  void removePlayer(String id) {
    players!.removeWhere((player) => player.id == id);
  }

  void setConfirmation(
    PlayerConfirmation playerConfirmation,
  ) {
    final confirmedPlayer = players!.firstWhere(
      (player) => player.id == playerConfirmation.playerId,
    );

    confirmedPlayer.isConfirm = playerConfirmation.isConfirm;
  }

  void setStatus(GameStatus started) {
    status = started;
  }
}
