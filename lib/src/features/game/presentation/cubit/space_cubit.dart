import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meme_card_game/src/features/game/domain/models/game_card.dart';
import 'package:meme_card_game/src/features/game/domain/models/situation.dart';
import 'package:meme_card_game/src/features/game/domain/models/vote_for_card.dart';
import 'package:meme_card_game/src/features/game/domain/models/vote_for_next_round.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';
import 'package:meme_card_game/src/features/game/utils/generate_random_number.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/domain/current_user.dart';
import '../../../auth/presentation/cubit/authentication_cubit.dart';
import '../../domain/models/room.dart';

part 'space_state.dart';

class SpaceCubit extends Cubit<SpaceState> {
  late final GameCubit _gameCubit;
  late final AuthenticationCubit _authenticationCubit;
  late final StreamSubscription _streamSubscription;

  Room? get room => _gameCubit.room;

  Situation? get currentSituation => _gameCubit.room!.currentSituation;

  // bool get didPlayersVoteMoreThanHalf

  CurrentUser get currentUser => _authenticationCubit.currentUser!;

  SpaceCubit({
    required GameCubit gameCubit,
    required AuthenticationCubit authenticationCubit,
  }) : super(SpaceInitialState()) {
    _gameCubit = gameCubit;
    _authenticationCubit = authenticationCubit;

    _streamSubscription =
        gameCubit.stream.listen(_streamSubscriptionForGameCubit);

    _pickSituation();
  }

  void _streamSubscriptionForGameCubit(GameState state) {
    // if (state is LoadingGameState) {
    //   emit(LoadingSpaceState());
    // }
    if (state is PlayerLeftRoomState) {
      emit(SpacePlayerLeftState());
    } else if (state is LeftRoomState) {
      emit(SpaceSomePlayerLeftState());
    } else if (state is DeletedGameState) {
      emit(SpaceGameDeletedState());
    } else if (state is GameSitautionPickedState) {
      emit(SpaceSituationPickedState());
    } else if (state is CardsTakenState) {
      if (state.currentUser) {
        emit(SpaceAddedCardToCurrentPlayerState());
      }
    } else if (state is GamePickedCardState) {
      emit(SpaceCardPickedState());
    }
    // else if (state is SomePlayerReadyToNextRound) {
    //   _addCardToCurrentPlayer();
    // }
    else if (state is GameVotedForCardState) {
      emit(SpaceVotedForCardState());
    } else if (state is GameSomePlayerReadyToNextRound) {
      emit(SpaceReadyForNextRoundState());
    } else if (state is GameFinishedState) {
      emit(SpaceGameFinishedState());
    } else if (state is GameFailureState) {
      emit(SpaceFailureState(state.error));
    }
  }

  Future<void> _pickSituation([String? situationId]) async {
    try {
      late final String pickedSituationId;

      if (room!.roomConfiguration.automaticSituationSelection == false &&
          situationId == null) {
        throw Exception(
            "Player should pick situation if room has auto generation of situations.");
      }

      if (room!.roomConfiguration.automaticSituationSelection) {
        final pickedSituationIndex =
            generateRandomNumber(room!.situationList.length);
        pickedSituationId = room!.situationList[pickedSituationIndex].id;
      } else {
        pickedSituationId = situationId!;
      }

      await _gameCubit.gameChannel!.send(
        type: RealtimeListenTypes.broadcast,
        event: "pick_situation",
        payload: {
          "picked_situation_id": pickedSituationId,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("SpaceCubit - _pickSituation - e: $e");
      }
      emit(SpaceFailureState("Something went wrong."));
    }
  }

  Future<void> nextRound() async {
    // todo: nextRound

    try {
      emit(SpaceLoadingState());

      await _gameCubit.gameChannel!.send(
        type: RealtimeListenTypes.broadcast,
        event: "next_round",
        payload: {},
      );
    } catch (e) {
      print("SpaceCubit - nextRound - e: $e");
      emit(SpaceFailureState(e));
    }
  }

  Future<void> chooseCard(String cardId) async {
    try {
      // todo: chooseCard
      emit(SpaceLoadingState());

      // todo: add card in db

      final pickedCard = _gameCubit.room!.currentPlayerCards
          .firstWhere((card) => card.cardId == cardId);

      await _gameCubit.gameChannel!.send(
        type: RealtimeListenTypes.broadcast,
        event: "pick_card",
        payload: {
          "object_data": pickedCard.toMap(),
        },
      );

      pickedCard.isImagePicked = !pickedCard.isImagePicked;

      _gameCubit.room!.addChosenCard(pickedCard);
    } catch (e) {
      print("SpaceCubit - chooseCard - e: $e");
      emit(SpaceFailureState(e));
    }
  }

  Future<void> chooseSituation(String situationId) async {
    try {
      emit(SpaceLoadingState());
      final payload =
          Situation(id: situationId, description: "Skeleton situation").toMap();

      await _gameCubit.gameChannel!.send(
        type: RealtimeListenTypes.broadcast,
        event: "choose_situation",
        payload: {
          "data_object": payload,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("SpaceCubit - chooseSituation - e: $e");
      }
      emit(SpaceFailureState(e));
    }
  }

  Future<void> voteForCard(String cardId) async {
    try {
      emit(SpaceLoadingState());
      final payload = VoteForCard(
        playerId: currentUser.id,
        cardId: cardId,
      ).toMap();

      await _gameCubit.gameChannel!.send(
        type: RealtimeListenTypes.broadcast,
        event: "vote_for_card",
        payload: {
          "data_object": payload,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("SpaceCubit - voteForCard - e: $e.");
      }
      emit(SpaceFailureState(e));
    }
  }

  // Future<void> _addCardToCurrentPlayer() async {
  //   try {
  //     emit(SpaceAddedCardToCurrentPlayer());
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("SpaceCubit - _addCardToCurrentPlayer - e: $e");
  //     }
  //     emit(SpaceFailureState(e));
  //   }
  // }

  Future<void> closeRoom() async {
    emit(SpaceGameDeletedState());
    _gameCubit.close;
  }

  void readyForNextRound() async {
    // todo: voteForNextRound
    try {
      emit(SpaceLoadingState());

      await _gameCubit.gameChannel!.send(
        type: RealtimeListenTypes.broadcast,
        event: "ready_for_next_round",
        payload: {
          "data_object": {
            "user_id": _authenticationCubit.currentUser!.id,
          },
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("SpaceCubit - voteForNextRound - e: $e.");
      }
      emit(SpaceFailureState(e));
    }
  }

  void finishGame() {}
}
