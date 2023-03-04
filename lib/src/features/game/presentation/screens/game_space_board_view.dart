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
      builder: (context, state) {
        final spaceCubit = context.read<SpaceCubit>();
        final situation = spaceCubit.room!.currentSituation;

        return SingleChildScrollView(
          child: Column(
            children: [
              if (situation == null) ...[
                Center(
                  child: Text("Waiting for situation."),
                ),
              ] else ...[
                Center(
                  child: Text(situation.description),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
