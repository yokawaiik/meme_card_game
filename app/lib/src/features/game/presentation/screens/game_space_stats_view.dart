import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/player_list_tile.dart';
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

        return ListView.builder(
          itemCount: spaceCubit.room!.players!.length,
          itemBuilder: (context, index) {
            final player = spaceCubit.room!.players![index];

            return PlayerListTile(
              id: player.id,
              login: player.login,
              backgroundColor: player.backgroundColor,
              color: player.color,
              points: player.points,
            );
          },
        );
      },
    );
  }
}
