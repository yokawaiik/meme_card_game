import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';

import '../../../../routing/routes_constants.dart' as routes_constants;

class SelectGameModeView extends StatelessWidget {
  const SelectGameModeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton.tonalIcon(
            icon: const Icon(Icons.add),
            label: const Text("Create new game"),
            onPressed: () => _createNewGame(context),
            style: FilledButton.styleFrom(
              minimumSize: const Size(
                160,
                46,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FilledButton.icon(
            icon: const Icon(Icons.handshake),
            label: const Text("Join game"),
            onPressed: () => _joinGame(context),
            style: FilledButton.styleFrom(
              minimumSize: const Size(
                100,
                46,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _createNewGame(BuildContext context) async {
    context.pushNamed(routes_constants.gameCreate);
  }

  void _joinGame(BuildContext context) async {
    context.pushNamed(routes_constants.joinGame);
  }
}
