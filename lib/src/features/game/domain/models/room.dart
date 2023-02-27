import 'package:meme_card_game/src/features/game/domain/enums/game_status.dart';
import 'package:meme_card_game/src/features/game/domain/models/player.dart';
import 'package:meme_card_game/src/features/game/domain/models/player_confirmation.dart';
import 'package:meme_card_game/src/features/game/domain/models/room_configuration.dart';
import 'package:meme_card_game/src/features/game/domain/models/taken_cards.dart';
import 'package:meme_card_game/src/features/game/domain/models/vote_for_card.dart';

import '../enums/presence_object_type.dart';
import 'game_card.dart';
import 'game_exception.dart';
import 'situation.dart';

import 'package:collection/collection.dart';

class Room {
  late final String id;
  late String title;
  late String createdBy;
  late final bool isCreatedByCurrentUser;
  late List<Player>? players;

  /// [status] game status
  late GameStatus status;

  late RoomConfiguration roomConfiguration;

  late List<GameCard> _currentPlayerCards;
  List<GameCard> get currentPlayerCards => _currentPlayerCards;

  int get currentRound => _situationList.length;
  late int currentRoundPlayersReadyCount;

  /// [currentRoundPlayersReadyCount] 70% players must be agree to go next

  late List<String> _availableCardIdList;
  List<String> get availableCardIdList => _availableCardIdList;

  /// [situationList] stored in memory every user
  late List<Situation> _situationList;
  List<Situation> get situationList => _situationList;
  // todo: check currentSituation
  Situation? get currentSituation =>
      _situationList.isNotEmpty ? _situationList.last : null;

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
    required List<String>? availableCardIdList,
  }) {
    this.players = players ?? [];
    this.roomConfiguration = roomConfiguration ?? RoomConfiguration();
    _situationList = [];
    _currentPlayerCards = [];
    _availableCardIdList = availableCardIdList ?? [];

    currentRoundPlayersReadyCount = 0;
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
    _situationList = [];
    _currentPlayerCards = [];
    _availableCardIdList = data["available_card_id_list"] ?? [];

    currentRoundPlayersReadyCount = 0;
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
      "available_card_id_list": _availableCardIdList,
    };
  }

  @override
  String toString() {
    final playersMapList = players?.map((player) => player.toMap()).toList();
    final currentUserCardList =
        _currentPlayerCards.map((card) => card.toMap()).toList();

    final room = toMap()
      ..addAll(
        {
          "players": playersMapList,
          "current_user_cards": currentUserCardList,
        },
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

  void addSituation(
    Situation situation,
  ) {
    // todo: check addSituation
    _situationList.add(situation);
  }

  /// _getLastSituation() for internal using
  Situation? _getLastSituation() {
    if (_situationList.isEmpty) {
      throw GameException("There are no need situations.");
    } else {
      return _situationList.last;
    }
  }

  /// addChosenCard() add ChosenCard to last situation
  void addChosenCard(
    GameCard card,
  ) {
    // todo: check  chosen card

    _getLastSituation()?.cards.add(card);
  }

  void addVotingResult(
      // String situationId,
      String userId,
      VoteForCard voteForCard) {
    // todo: add voting result by situation id

    _getLastSituation()
        ?.cards
        .firstWhere((chosenCard) => chosenCard.userId == userId)
        .votesList
        .add(voteForCard);
  }

  void addCardToCurrentPlayer(GameCard card) {
    _currentPlayerCards.add(card);
  }

  void removeCardFromCurrentPlayer(String cardId) {
    _currentPlayerCards.removeWhere((card) => card.cardId == cardId);
  }

  void removeCardFromAvailableCardIdList(String cardId) {
    _availableCardIdList.removeWhere((cardId) => cardId == cardId);
  }

  Map<String, dynamic> initialCardsDistribution() {
    List<TakenCards> distributedCards = [];

    const start = 0;
    final end = roomConfiguration.playerStartCardsCount * players!.length;

    final cards = _availableCardIdList
        .sublist(start, end)
        .slices(roomConfiguration.playerStartCardsCount)
        .toList();

    for (var i = 0; i < players!.length; i++) {
      final takenCards = TakenCards(
        playerId: players![i].id,
        takenCardIdList: cards[i],
      );
      distributedCards.add(takenCards);
    }

    _availableCardIdList.removeRange(
      start,
      end,
    );

    return {
      "distributed_cards":
          distributedCards.map((takenCards) => takenCards.toMap()).toList(),
    };
  }
}
