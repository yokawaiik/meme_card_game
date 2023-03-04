import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_card_game/src/features/game/domain/models/situation.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';

import '../cubit/space_cubit.dart';

class GameSpaceStatsView extends StatelessWidget {
  const GameSpaceStatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SpaceCubit, SpaceState>(
      buildWhen: (previous, current) {
        if (current is SpaceSomePlayerLeftState ||
            current is SpaceGameFinishedState ||
            current is SpaceVotedForCardState ||
            current is SpaceNextRoundState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        final spaceCubit = context.read<SpaceCubit>();

        return SingleChildScrollView(
          child: ListView.builder(
            itemCount: spaceCubit.room!.players!.length,
            itemBuilder: (context, index) {
              final player = spaceCubit.room!.players![index];

              return ListTile(
                minVerticalPadding: 5,
                key: Key(player.id),
                leading: CircleAvatar(
                  backgroundColor: player.backgroundColor,
                  foregroundColor: player.color,
                  child: const Icon(Icons.person_4),
                ),
                trailing: Checkbox(
                  value: player.isConfirm,
                  onChanged: null,
                ),
                title: Text(
                  player.login,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
                subtitle: Row(
                  children: [
                    Text("Points: ${player.points}"),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
