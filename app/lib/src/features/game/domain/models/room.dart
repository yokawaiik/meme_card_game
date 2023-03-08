import 'package:meme_card_game/src/features/game/domain/enums/game_status.dart';
import 'package:meme_card_game/src/features/game/domain/models/game_round.dart';
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
  // late GameStatus status;

  late RoomConfiguration roomConfiguration;

  late List<GameCard> _currentPlayerCards;
  List<GameCard> get currentPlayerCards => _currentPlayerCards;

  int get currentRound => _situationList.length;

  /// [currentRoundPlayersReadyCount] players must be agree to go next
  late int currentRoundPlayersReadyCount;

  late List<String> _availableCardIdList;
  List<String> get availableCardIdList => _availableCardIdList;

  /// [situationList] stored in memory every user
  late List<Situation> _situationList;

  List<Situation> get situationList => _situationList;

  ///[currentRoundNumber] is a round index for pickedSituationList
  late int currentRoundNumber;

  late List<Situation> _pickedSituationList;
  List<Situation> get pickedSituationList => _pickedSituationList;

  Situation? get currentSituation {
    return _pickedSituationList.firstWhereIndexedOrNull(
        (index, element) => index == currentRoundNumber);
  }

  late final GameRound currentGameRound;

  bool get isGameFinished =>
      currentRoundNumber == roomConfiguration.roundsCount - 1;

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
    RoomConfiguration? roomConfiguration,
    required List<String>? availableCardIdList,
  }) {
    this.players = players ?? [];
    this.roomConfiguration = roomConfiguration ?? RoomConfiguration();
    _situationList = [];
    _pickedSituationList = [];
    _currentPlayerCards = [];
    _availableCardIdList = availableCardIdList ?? [];

    currentRoundPlayersReadyCount = 0;
    currentRoundNumber = 0;
    currentGameRound = GameRound();
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
    roomConfiguration = data['room_configuration'] == null
        ? RoomConfiguration.fromMap(data['room_configuration'])
        : RoomConfiguration();
    _situationList = [];
    _currentPlayerCards = [];
    // _availableCardIdList = data["available_card_id_list"] ?? [];
    _availableCardIdList = (data["available_card_id_list"] as List<dynamic>)
        .map((item) => item.toString())
        .toList();
    _pickedSituationList = [];

    currentRoundPlayersReadyCount = 0;
    currentRoundNumber = 0;
    currentGameRound = GameRound();
  }

  /// only for game
  Map<String, dynamic> toMap() {
    return {
      'object_type': PresenceObjectType.room.index,
      "id": id,
      "title": title,
      "created_by": createdBy,
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

  void addSituation(
    Situation situation,
  ) {
    _situationList.add(situation);
  }

  /// _getLastSituation() for internal using
  Situation? _getLastSituation() {
    if (_pickedSituationList.isEmpty) {
      throw GameException("There are not any situations.");
    } else {
      return _pickedSituationList.last;
    }
  }

  /// addChosenCard() add ChosenCard to last situation
  void addPickedCard(
    GameCard card,
  ) {
    _getLastSituation()?.cards.add(card);
  }

  void addVotingResult(VoteForCard voteForCard) {
    final votedCard = _getLastSituation()
        ?.cards
        .firstWhere((chosenCard) => chosenCard.cardId == voteForCard.cardId);

    votedCard!.votesList.add(voteForCard);

    final cardByPlayerId = votedCard.userId;

    players!.firstWhere((player) => player.id == cardByPlayerId).points++;
  }

  void pickSituation(Situation pickedSituation) {
    _pickedSituationList.add(pickedSituation);
  }

  void addCardToCurrentPlayer(GameCard card) {
    _currentPlayerCards.add(card);
  }

  void removeCardFromCurrentPlayer(String cardId) {
    _currentPlayerCards.removeWhere((card) => card.cardId == cardId);
  }

  void removeCardFromAvailableCardIdList(String cardId) {
    _availableCardIdList
        .removeWhere((availableCardId) => availableCardId == cardId);
  }

  List<Map<String, dynamic>> distributeCards({int? count}) {
    List<TakenCards> distributedCards = [];

    final countCards = count ?? roomConfiguration.playerStartCardsCount;

    const start = 0;

    final end = countCards * players!.length;

    final cards =
        _availableCardIdList.sublist(start, end).slices(countCards).toList();

    for (var i = 0; i < players!.length; i++) {
      final takenCards = TakenCards(
        playerId: players![i].id,
        takenCardIdList: cards[i],
      );
      distributedCards.add(takenCards);
    }

    return distributedCards.map((takenCards) => takenCards.toMap()).toList();
  }

  void currentGameRoundPickSituationId(String situationId) {
    currentGameRound.pickedSituationId = situationId;
  }

  /// [currentGameRoundVoteForCard] in memory for support
  void currentGameRoundVoteForCard(String cardId) {
    currentGameRound.votedCardId = cardId;
  }

  /// [currentGameRoundPickCardId] in memory for support
  void currentGameRoundPickCardId(String cardId) {
    currentGameRound.pickedCardId = cardId;
  }

  /// [currentGameRoundReadyForNextRound] in memory for support
  void currentGameRoundReadyForNextRound([bool isReady = true]) {
    currentGameRound.isReadyForNextRound = isReady;
  }

  void someUserReadyForNextRound() {
    currentRoundPlayersReadyCount++;
  }

  void nextRound() {
    currentRoundPlayersReadyCount = 0;
    currentRoundNumber++;

    currentGameRound.pickedSituationId = null;
    currentGameRound.votedCardId = null;
    currentGameRound.pickedCardId = null;
    currentGameRound.isReadyForNextRound = false;
  }
}
