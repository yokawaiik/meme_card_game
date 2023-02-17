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
            icon: Icon(Icons.add),
            label: Text("Create new game"),
            onPressed: () => _createNewGame(context),
            style: FilledButton.styleFrom(
              minimumSize: Size(
                160,
                46,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FilledButton.icon(
            icon: Icon(Icons.handshake),
            label: Text("Join game"),
            onPressed: () => _joinGame(context),
            style: FilledButton.styleFrom(
              minimumSize: Size(
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
    context.pushNamed(routes_constants.game);
  }

  void _joinGame(BuildContext context) async {
    context.pushNamed(routes_constants.joinGame);
  }
}
