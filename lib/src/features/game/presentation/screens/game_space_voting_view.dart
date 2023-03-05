import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            current is SpaceReadyForNextRoundState ||
            current is SpaceVotedForCardState ||
            current is SpaceNextRoundState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        final spaceCubit = context.read<SpaceCubit>();
        final currentSituation = spaceCubit.room!.currentSituation;

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
          ),
          itemCount: currentSituation.cards.length,
          itemBuilder: (context, index) {
            final card = currentSituation.cards[index];

            return InkWell(
              key: Key(card.cardId),
              onTap: () => _openCard(context),
              child: Stack(
                children: [
                  Image.network(
                    card.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  if (spaceCubit.room!.currentGameRound.votedCardId == null ||
                      spaceCubit.room!.currentGameRound.votedCardId ==
                          card.cardId)
                    Positioned(
                        right: 20,
                        bottom: 20,
                        child: IconButton(
                          icon: Icon(
                            Icons.star_border_rounded,
                            color: (spaceCubit
                                        .room!.currentGameRound.votedCardId !=
                                    card.cardId)
                                ? colorScheme.primary
                                : colorScheme.secondary,
                          ),
                          onPressed: isSpaceLoadingState ||
                                  (spaceCubit
                                          .room!.currentGameRound.votedCardId !=
                                      null)
                              ? null
                              : () => spaceCubit.voteForCard(card.cardId),
                        )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _openCard(BuildContext context) {}
}
