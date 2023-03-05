import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/space_cubit.dart';
import 'package:meme_card_game/src/features/game/domain/models/game_card.dart';

class GameSpacePlayerCardView extends StatelessWidget {
  const GameSpacePlayerCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SpaceCubit, SpaceState>(
      buildWhen: (previous, current) {
        if (current is SpaceLoadingState ||
            current is SpaceNextRoundState ||
            current is SpacePlayerPickedCardState ||
            current is SpaceSituationPickedState ||
            current is SpaceAddedCardToCurrentPlayerState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        final spaceCubit = context.read<SpaceCubit>();

        // final isSpaceSituationPickedState = state is SpaceSituationPickedState;

        // final pickedCardId = spaceCubit.room!.currentGameRound.pickedCardId;

        // print(
        //     'GameSpacePlayerCardView - currentPlayerCards: ${spaceCubit.room!.currentPlayerCards.length}');

        // final isSpaceCardPickedState = state is SpaceCardPickedState;

        return CarouselSlider.builder(
          options: CarouselOptions(
            height: double.infinity,
            viewportFraction: 1,
            enableInfiniteScroll: false,
          ),
          itemCount:
              spaceCubit.room!.currentPlayerCards.length, // todo: change it
          itemBuilder: (context, index, realIndex) {
            final gameCard = spaceCubit.room!.currentPlayerCards[index];

            return Stack(
              children: [
                Image.network(
                  gameCard.imageUrl,
                  // fit: BoxFit.cover,
                  fit: BoxFit.fill,
                  height: double.infinity,
                ),
                if (spaceCubit.room!.currentSituation != null)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: _buildPickButton(
                      callback: () => spaceCubit.pickCard(gameCard.cardId),
                      pickedCardId:
                          spaceCubit.room!.currentGameRound.pickedCardId,
                      cardId: gameCard.cardId,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  FilledButton _buildPickButton({
    required String cardId,
    required String? pickedCardId,
    required void Function()? callback,
  }) {
    late final String labelText;
    late final void Function()? onPressed;

    if (cardId == pickedCardId) {
      labelText = "This card picked";
      onPressed = null;
    } else if (pickedCardId == null) {
      labelText = "Pick card";
      onPressed = callback;
    } else {
      // ? pickedCardId != null and cardId != pickedCardId
      labelText = "Already picked";
      onPressed = null;
    }

    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: Icon(Icons.done),
      label: Text(labelText),
    );
  }
}
