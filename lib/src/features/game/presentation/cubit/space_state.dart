part of 'space_cubit.dart';

@immutable
abstract class SpaceState {}

class SpaceInitialState extends SpaceState {}

class SpaceSituationPickedState extends SpaceState {}

class SpaceCardChosenState extends SpaceState {}

class SpaceVotedForCardState extends SpaceState {}

class SpaceLoadingState extends SpaceState {}

class SpaceFailureState extends SpaceState {
  Object? error;
  SpaceFailureState(error);
}

class SpaceAddedCardToCurrentPlayer extends SpaceState {}

class SpaceSomePlayerLeftState extends SpaceState {}

class SpacePlayerLeftState extends SpaceState {}

class SpaceGameDeletedState extends SpaceState {}

class SpaceGameFinishedState extends SpaceState {}
