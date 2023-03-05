part of 'space_cubit.dart';

@immutable
abstract class SpaceState {}

class SpaceInitialState extends SpaceState {}

class SpaceSituationPickedState extends SpaceState {}

class SpacePlayerPickedCardState extends SpaceState {
  bool isCurrentUser;
  SpacePlayerPickedCardState(this.isCurrentUser);
}

class SpaceVotedForCardState extends SpaceState {}

class SpaceLoadingState extends SpaceState {}

class SpaceFailureState extends SpaceState {
  Object? error;
  SpaceFailureState(this.error);
}

class SpaceReadyForNextRoundState extends SpaceState {}

class SpaceNextRoundState extends SpaceState {}

class SpaceAddedCardToCurrentPlayerState extends SpaceState {}

class SpaceSomePlayerLeftState extends SpaceState {}

class SpacePlayerLeftState extends SpaceState {}

class SpaceGameDeletedState extends SpaceState {}

class SpaceGameFinishedState extends SpaceState {}
