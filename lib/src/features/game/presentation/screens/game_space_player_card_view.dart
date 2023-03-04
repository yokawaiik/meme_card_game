import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/space_cubit.dart';

class GameSpacePlayerCardView extends StatelessWidget {
  const GameSpacePlayerCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SpaceCubit, SpaceState>(
      buildWhen: (previous, current) {
        if (current is SpaceNextRoundState ||
            current is SpaceCardPickedState ||
            current is SpaceSituationPickedState ||
            current is SpaceAddedCardToCurrentPlayerState) {}
        return false;
      },
      builder: (context, state) {
        final spaceCubit = context.read<SpaceCubit>();

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
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FilledButton.tonalIcon(
                    // todo: handle if image has already been chosen
                    onPressed: gameCard.isImagePicked
                        ? null
                        : () => spaceCubit.chooseCard(gameCard.cardId),
                    icon: Icon(Icons.done),
                    label:
                        Text(gameCard.isImagePicked ? "Chosen" : "Pick image"),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _pickImage(BuildContext context) {}
}
