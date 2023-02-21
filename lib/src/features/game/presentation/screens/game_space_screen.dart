import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/common_widgets/default_text_field.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';

import '../../../../routing/routes_constants.dart' as routes_constants;

class GameSpaceScreen extends StatefulWidget {
  const GameSpaceScreen({super.key});

  @override
  State<GameSpaceScreen> createState() => _GameSpaceScreenState();
}

class _GameSpaceScreenState extends State<GameSpaceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _closeRoom(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Game space"),
        ),
        body: Column(
          children: [],
        ),
      ),
    );
  }

  Future<bool> _closeRoom(BuildContext context) async {
    var answer = false;

    final gameCubit = context.read<GameCubit>();

    final isCreatedByCurrentUser = gameCubit.room!.isCreatedByCurrentUser;

    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Warning"),
            content: Text(
              isCreatedByCurrentUser
                  ? "Delete room and close it"
                  : "Leave the room",
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop();
                    answer = false;
                  },
                  child: const Text("No")),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                  answer = true;
                },
                child: const Text(
                  "Yes",
                ),
              )
            ],
          );
        });

    // if (answer && isCreatedByCurrentUser) {
    //   gameCubit.deleteRoom();
    // } else {
    //   gameCubit.leaveRoom();
    // }
    if (answer) {
      gameCubit.closeRoom();
    }

    // ? it's necessary because if return true and then use router will be exception
    return false;
  }
}
