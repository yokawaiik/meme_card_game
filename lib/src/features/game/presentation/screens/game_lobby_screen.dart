import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';
import 'package:flutter/services.dart';

import 'package:collection/collection.dart';

import "../../../../routing/routes_constants.dart" as routes_constants;

class GameLobbyScreen extends StatelessWidget {
  const GameLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // uses only for initial values
    final gameCubit = context.read<GameCubit>();
    final room = gameCubit.room;

    final isCreatedByCurrentUser = room!.isCreatedByCurrentUser;

    return WillPopScope(
      onWillPop: () => _closeRoom(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Lobby room ${isCreatedByCurrentUser ? "(Creator)" : "(Player)"}',
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
                  height: 10,
                ),
                BlocBuilder<GameCubit, GameState>(
                  buildWhen: (previous, current) {
                    print('BlocBuilder - current : $current');
                    if (current is NewPlayerJoinedRoomState ||
                        current is PlayerLeftRoomState) {
                      return true;
                    }
                    return false;
                  },
                  builder: (builderContext, state) {
                    final gameCubit = builderContext.read<GameCubit>();

                    print(
                        "GameLobbyScreen - players : ${gameCubit.room!.players}");

                    final creator = gameCubit.room!.players!
                        .firstWhereOrNull((player) => player.isCreator);

                    final players = gameCubit.room!.players!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total players: ${gameCubit.room!.players!.length}",
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: players.length,
                          itemBuilder: (_, index) {
                            final player = players[index];

                            return Padding(
                              key: Key(player.id),
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                onTap: () => _showPlayerProfile(context),
                                leading: CircleAvatar(
                                  backgroundColor: player.backgroundColor,
                                  foregroundColor: player.color,
                                  child: Icon(Icons.person_4),
                                ),
                                title: Text(
                                  player.login,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
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

    final gameCubit = context.read<GameCubit>();

    final isCreatedByCurrentUser = gameCubit.room!.isCreatedByCurrentUser;

    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Warning"),
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
                child: Text(
                  "Yes",
                ),
              )
            ],
          );
        });

    if (answer) {
      if (isCreatedByCurrentUser) {
        gameCubit.deleteRoom();
      } else {
        gameCubit.leaveRoom();
      }
    }
    return answer;
  }

  _showPlayerProfile(BuildContext context) {
    // todo: implements
  }
}
