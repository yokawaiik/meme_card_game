part of 'game_cubit.dart';

@immutable
abstract class GameState {}

class GameInitialState extends GameState {}

class CreatedGameState extends GameState {}

class LobbyConnectingState extends GameState {}

class StartedGameState extends GameState {}

class SitautionChoosingState extends GameState {}

class ChoosingCardState extends GameState {}

class FinishedGameState extends GameState {}
