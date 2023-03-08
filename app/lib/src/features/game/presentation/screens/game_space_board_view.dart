import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_card_game/src/features/game/domain/models/situation.dart';

import '../cubit/space_cubit.dart';

class GameSpaceBoardView extends StatelessWidget {
  const GameSpaceBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SpaceCubit, SpaceState>(
      buildWhen: (previous, current) {
        if (current is SpaceSituationPickedState ||
            current is SpaceNextRoundState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        final spaceCubit = context.read<SpaceCubit>();
        final room = spaceCubit.room!;
        final situation = room.currentSituation;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    room.currentRoundNumber !=
                            room.roomConfiguration.roundsCount
                        ? "Round: ${room.currentRoundNumber + 1}"
                        : "Final round",
                    style: textTheme.displayMedium,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (situation == null) ...[
                  Text("Waiting for situation."),
                ] else ...[
                  Text(
                    situation.description,
                    style: textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
