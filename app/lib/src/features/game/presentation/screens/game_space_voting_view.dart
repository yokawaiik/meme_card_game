import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_card_game/src/features/game/domain/models/game_card.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/space_cubit.dart';

class GameSpaceVotingView extends StatelessWidget {
  const GameSpaceVotingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<SpaceCubit, SpaceState>(
      buildWhen: (previous, current) {
        if (current is SpaceSomePlayerLeftState ||
            current is SpaceSituationPickedState ||
            current is SpacePlayerPickedCardState ||
            current is SpaceReadyForNextRoundState ||
            current is SpaceVotedForCardState ||
            current is SpaceNextRoundState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        final spaceCubit = context.read<SpaceCubit>();
        final room = spaceCubit.room!;
        final currentSituation = room.currentSituation;

        final isSpaceLoadingState = state is SpaceLoadingState;

        if (currentSituation == null) {
          return Center(
            child: Text("Situation haven't been picked yet."),
          );
        }

        if (currentSituation.cards.isEmpty) {
          return Center(
            child: Text("Players haven't chosen cards yet."),
          );
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: currentSituation.cards.length,
          itemBuilder: (context, index) {
            final card = currentSituation.cards[index];

            return InkWell(
              key: Key(card.cardId),
              onTap: () => _openCard(context),
              child: _buildCard(
                isLoading: isSpaceLoadingState,
                imageUrl: card.imageUrl,
                votedCardId: room.currentGameRound.votedCardId,
                cardId: card.cardId,
                unvotedColor: colorScheme.primary,
                votedColor: colorScheme.primary,
                callback: () => spaceCubit.voteForCard(card.cardId),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCard({
    required String imageUrl,
    required bool isLoading,
    required String? votedCardId,
    required String cardId,
    required Color unvotedColor,
    required Color votedColor,
    required void Function()? callback,
  }) {
    late final void Function()? onPressed;
    late final IconData iconData;
    late final Color iconButtonCollor;

    if (isLoading) {
      iconButtonCollor = unvotedColor;
      iconData = Icons.star_border_rounded;
      onPressed = null;
    } else if (votedCardId == null) {
      iconButtonCollor = unvotedColor;
      onPressed = callback;
      iconData = Icons.star_border_rounded;
    } else if (votedCardId == cardId) {
      iconButtonCollor = votedColor;
      iconData = Icons.star;
      onPressed = null;
    } else {
      iconButtonCollor = unvotedColor;
      iconData = Icons.star_border_rounded;
      onPressed = null;
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          if (votedCardId == null || votedCardId == cardId)
            Positioned(
              right: 20,
              bottom: 20,
              child: IconButton(
                iconSize: 50,
                icon: Icon(
                  iconData,
                  color: iconButtonCollor,
                ),
                onPressed: onPressed,
              ),
            ),
        ],
      ),
    );
  }

  _openCard(BuildContext context) {
    // todo: implements
  }
}
