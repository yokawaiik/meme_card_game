import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/common_widgets/button_with_indicator.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';
import 'package:flutter/services.dart';

import 'package:collection/collection.dart';
import 'package:meme_card_game/src/features/game/widgets/player_list_tile.dart';

import "../../../../routing/routes_constants.dart" as routes_constants;

class GameLobbyScreen extends StatelessWidget {
  const GameLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // ? info uses only for initial values
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
                        Text(
                          "Name: ${room.title}",
                          style: textTheme.titleLarge,
                          // softWrap: true,
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                        ),
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
                              icon: const Icon(
                                Icons.copy_rounded,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Max players count: ${room.roomConfiguration.playersCount}",
                          style: textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<GameCubit, GameState>(
                  buildWhen: (previous, current) {
                    if (current is NewPlayerJoinedRoomState ||
                        current is PlayerLeftRoomState ||
                        current is ConfirmedGameState ||
                        current is SomePlayerConfirmedGameState) {
                      return true;
                    }
                    return false;
                  },
                  builder: (builderContext, state) {
                    final gameCubit = builderContext.read<GameCubit>();
                    // final creator = gameCubit.room!.players!
                    //     .firstWhereOrNull((player) => player.isCreator);

                    final players = gameCubit.room!.players!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total players: ${gameCubit.room!.players!.length}",
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: players.length,
                          itemBuilder: (_, index) {
                            final player = players[index];

                            return PlayerListTile(
                              id: player.id,
                              login: player.login,
                              backgroundColor: player.backgroundColor,
                              color: player.color,
                              points: player.points,
                              isConfirm: player.isConfirm,
                              onTap: () => _showPlayerProfile(context),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<GameCubit, GameState>(
                    buildWhen: (previous, current) {
                  if (current is ConfirmedGameState ||
                      // current is LoadingGameState
                      current is ConfirmLoadingGameState) {
                    return true;
                  }
                  return false;
                }, builder: (context, state) {
                  final isConfirmedGameState = state is ConfirmedGameState;
                  final isConfirmLoadingGameState =
                      state is ConfirmLoadingGameState;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonWithIndicator.tonal(
                        isLoading: isConfirmLoadingGameState,
                        onPressed: isConfirmedGameState
                            ? null
                            : () => _confirmParticipation(context),
                        child: Text(
                          isConfirmedGameState
                              ? "Wait for others"
                              : "Сonfirm participation",
                        ),
                      )
                    ],
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                if (room.isCreatedByCurrentUser)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // todo: correct error
                      BlocBuilder<GameCubit, GameState>(
                        buildWhen: (previous, current) {
                          if (current is SomePlayerConfirmedGameState ||
                              current is ConfirmedGameState) {
                            return true;
                          }
                          return false;
                        },
                        builder: (context, state) {
                          final gameCubit = context.read<GameCubit>();
                          final room = gameCubit.room!;

                          return FilledButton.tonal(
                            onPressed: room.isAllPlayersConfirm
                                ? () => _startGame(context)
                                : null,
                            child: Text(
                              room.isAllPlayersConfirm
                                  ? "Start Game"
                                  : "Waiting for the players confirmation",
                            ),
                          );
                        },
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

  _startGame(BuildContext context) async {
    try {
      final gameCubit = context.read<GameCubit>();

      await gameCubit.startGame();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    }
  }

  _copyRoomId(BuildContext context) async {
    late String snackBarTextContent;
    try {
      final gameCubit = context.read<GameCubit>();

      final room = gameCubit.room!;

      await Clipboard.setData(ClipboardData(text: room.id));
      snackBarTextContent = 'Copied to clipboard';
    } catch (e) {
      snackBarTextContent = "Something went wrong.";
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackBarTextContent),
        ),
      );
    }
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

    if (answer) {
      await gameCubit.closeRoom();
    }

    // ? it's necessary because if return true and then use router will be exception
    return false;
  }

  _showPlayerProfile(BuildContext context) async {
    // todo: implements _showPlayerProfile
    try {} catch (e) {}
  }

  _confirmParticipation(BuildContext context) async {
    try {
      final gameCubit = context.read<GameCubit>();

      // ? info: it may to add switch to true/false
      await gameCubit.confirmParticipation(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong."),
        ),
      );
    }
  }
}
