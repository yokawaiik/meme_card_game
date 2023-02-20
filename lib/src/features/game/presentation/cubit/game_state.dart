part of 'game_cubit.dart';

@immutable
abstract class GameState {}

class GameInitialState extends GameState {}

class LoadingGameState extends GameState {}

class CreatedGameState extends GameState {}

class JoinedRoomState extends GameState {}

class NewPlayerJoinedRoomState extends GameState {}

class PlayerLeftRoomState extends GameState {}

class CloseGameState extends GameState {}

class StartedGameState extends GameState {}

class SitautionChoosingState extends GameState {}

class ChoosingCardState extends GameState {}

class FinishedGameState extends GameState {}
