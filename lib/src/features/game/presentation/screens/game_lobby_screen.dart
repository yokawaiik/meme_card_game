import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';
import 'package:flutter/services.dart';

class GameLobbyScreen extends StatelessWidget {
  const GameLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final gameCubit = context.read<GameCubit>();

    final room = gameCubit.room!;

    return WillPopScope(
      onWillPop: () => _closeRoom(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lobby room',
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${room.title}",
                            style: textTheme.titleLarge),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SelectableText(
                              "ID: ${room.id}",
                              style: textTheme.titleSmall,
                            ),
                            IconButton(
                              onPressed: () => _copyRoomId(context),
                              iconSize: 16,
                              icon: Icon(
                                Icons.copy_rounded,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton.tonal(
                      onPressed: () => _startGame(context),
                      child: Text("Start Game"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _startGame(BuildContext context) {}

  _copyRoomId(BuildContext context) async {
    final gameCubit = context.read<GameCubit>();

    final room = gameCubit.room!;

    await Clipboard.setData(ClipboardData(text: room.id));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  Future<bool> _closeRoom(BuildContext context) async {
    var answer = false;

    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Saved successfully"),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop();
                    answer = false;
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    context.pop();
                    answer = true;
                  },
                  child: const Text("Yes, close it!"))
            ],
          );
        });

    if (answer) {
      context.read<GameCubit>().closeRoom();
    }
    return answer;
  }
}
