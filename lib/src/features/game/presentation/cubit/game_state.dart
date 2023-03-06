part of 'game_cubit.dart';

@immutable
abstract class GameState {}

class GameInitialState extends GameState {}

class LoadingGameState extends GameState {}

class CreatedGameState extends GameState {}

class JoinedRoomState extends GameState {}

class NewPlayerJoinedRoomState extends GameState {}

class PlayerLeftRoomState extends GameState {}

class LeftRoomState extends GameState {}

class DeletedGameState extends GameState {}

class ConfirmLoadingGameState extends GameState {}

class ConfirmedGameState extends GameState {}

class SomePlayerConfirmedGameState extends GameState {}

class StartedGameState extends GameState {}

class CardsTakenState extends GameState {
  final bool currentUser;
  CardsTakenState({this.currentUser = false});
}

class GameSitautionPickedState extends GameState {
  Situation situation;
  GameSitautionPickedState(this.situation);
}

class GamePlayerPickedCardState extends GameState {
  bool isCurrentUser;
  GamePlayerPickedCardState(this.isCurrentUser);
}

class GameVotedForCardState extends GameState {}

class GameSomePlayerReadyForNextRound extends GameState {}

class GameNextRoundState extends GameState {}

class GameFinishedState extends GameState {}

class GameFailureState extends GameState {
  Object? error;
  GameFailureState(error);
}
