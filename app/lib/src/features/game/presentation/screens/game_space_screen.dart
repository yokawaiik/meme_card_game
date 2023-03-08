import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/common_widgets/default_text_field.dart';
import 'package:meme_card_game/src/common_widgets/keep_alive_wrapper.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';
import 'package:meme_card_game/src/features/game/presentation/screens/game_space_voting_view.dart';

import '../../../../routing/routes_constants.dart' as routes_constants;
import '../cubit/space_cubit.dart';
import 'game_space_board_view.dart';
import 'game_space_player_card_view.dart';
import 'game_space_stats_view.dart';

class GameSpaceScreen extends StatefulWidget {
  const GameSpaceScreen({super.key});

  @override
  State<GameSpaceScreen> createState() => _GameSpaceScreenState();
}

class _GameSpaceScreenState extends State<GameSpaceScreen> {
  late final List<Widget> _views;
  late int _currentPage;
  late final PageController _pageViewController;

  // late final SpaceCubit _spaceCubit;

  @override
  void initState() {
    _views = [
      const KeepAliveWrapper(
        child: GameSpaceBoardView(),
      ),
      const KeepAliveWrapper(
        child: GameSpacePlayerCardView(),
      ),
      const KeepAliveWrapper(
        child: GameSpaceVotingView(),
      ),
      const KeepAliveWrapper(
        child: GameSpaceStatsView(),
      ),
    ];
    _pageViewController = PageController(
      initialPage: 0,
    );

    _currentPage = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _closeRoom(context),
      child: BlocListener<SpaceCubit, SpaceState>(
        listener: (context, state) {
          if (state is SpaceFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.toString())),
            );
          }
          if (state is SpaceNextRoundState) {
            _onViewChange(0);
          }
        },
        listenWhen: (previous, current) {
          if (current is SpaceFailureState || current is SpaceNextRoundState) {
            return true;
          }
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Game space',
            ),
          ),
          body: PageView(
            controller: _pageViewController,
            pageSnapping: false,
            onPageChanged: _onViewChange,
            children: _views,
          ),
          floatingActionButton: BlocBuilder<SpaceCubit, SpaceState>(
            buildWhen: (previous, current) {
              if (current is SpaceGameFinishedState ||
                  (current is SpacePlayerPickedCardState &&
                      current.isCurrentUser == true) ||
                  current is SpaceLoadingState ||
                  current is SpaceSituationPickedState ||
                  current is SpaceVotedForCardState ||
                  current is SpaceReadyForNextRoundState ||
                  current is SpaceNextRoundState) {
                return true;
              }
              return false;
            },
            builder: (context, state) {
              // ? info notify player about mistake

              final spaceCubit = context.read<SpaceCubit>();

              late final void Function()? onPressedFloatingActionButton;
              late final String buttonText;

              // ? if situation wasn't chosen and necessary choose it

              if (state is SpaceLoadingState) {
                onPressedFloatingActionButton = null;
                buttonText = "Waiting";
              } else if (spaceCubit.room!.isCreatedByCurrentUser &&
                  spaceCubit.room!.currentGameRound.pickedSituationId == null) {
                if (spaceCubit
                    .room!.roomConfiguration.automaticSituationSelection) {
                  onPressedFloatingActionButton = () {
                    spaceCubit.pickSituation();
                  };
                  buttonText = "Auto pick situation";
                } else {
                  // todo: implements
                  throw UnimplementedError();

                  buttonText = "Pick situation";
                }
              } else if (!spaceCubit.room!.isCreatedByCurrentUser &&
                  spaceCubit.room!.currentSituation == null) {
                onPressedFloatingActionButton = () {
                  _onViewChange(0);
                };
                buttonText = "Wait for a situation";
              }
              // ?if situation was chosen and necessary to choose card
              else if (spaceCubit.room!.currentGameRound.pickedCardId == null) {
                onPressedFloatingActionButton = () {
                  _onViewChange(1);
                };
                buttonText = "Pick card";
              }

              // ? if card was chosen and necessary to vote

              else if (spaceCubit.room!.currentGameRound.votedCardId == null) {
                onPressedFloatingActionButton = () {
                  _onViewChange(2);
                };
                buttonText = "Vote for card";
              }
              // ? if card was chosen and necessary player ready for the next round
              // else if (spaceCubit.room!.currentRoundNumber - 1 ==
              //     spaceCubit.room!.roomConfiguration.roundsCount) {
              else if (spaceCubit.room!.isGameFinished) {
                // ? info: if round end creator have to press to finish

                onPressedFloatingActionButton = () {
                  spaceCubit.finishGame();
                };

                buttonText = "Finish game";
              } else if (spaceCubit
                      .room!.currentGameRound.isReadyForNextRound ==
                  false) {
                // ? vote for next round
                onPressedFloatingActionButton = () {
                  spaceCubit.readyForNextRound();
                  _onViewChange(3);
                };
                buttonText = "Ready for next round";
              } else if (spaceCubit.room!.currentRoundPlayersReadyCount >=
                  spaceCubit.room!.players!.length) {
                onPressedFloatingActionButton = () {
                  spaceCubit.nextRound();
                  _onViewChange(0);
                };
                buttonText = "Next round";
              } else {
                onPressedFloatingActionButton = () {
                  _onViewChange(3);
                };

                buttonText = "Wait for others";
              }

              // // todo: if game ended and need to look at stats

              return FloatingActionButton.extended(
                onPressed: onPressedFloatingActionButton,
                label: Text(buttonText),
                icon: Icon(Icons.image_rounded),
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentPage,
            onDestinationSelected: _onViewChange,
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.games_rounded,
                ),
                label: "Board",
              ),
              //     // todo: available only for creator if works non-generation situation mode

              //     // BottomNavigationBarItem(
              //     //   label: "Situations",
              //     //   icon: Icon(
              //     //     Icons.list_alt_rounded,
              //     //   ),
              //     // ),

              NavigationDestination(
                label: "My cards",
                icon: Icon(
                  Icons.sentiment_satisfied_alt_outlined,
                ),
              ),

              NavigationDestination(
                label: "Vote",
                icon: Icon(
                  Icons.group,
                ),
              ),

              NavigationDestination(
                label: "Stats",
                icon: Icon(
                  Icons.leaderboard,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onViewChange(int value) {
    print("_onViewChange value: $value");

    // _pageViewController.animateToPage(
    //   value,
    //   duration: Duration(milliseconds: 100),
    //   curve: Curves.easeOutQuad,
    // );

    _pageViewController.jumpToPage(value);

    setState(() {
      _currentPage = value;
    });
  }

  // Future<void> _onDestinationSelected(int value) async {
  //   // await _pageViewController.animateToPage(
  //   //   value,
  //   //   duration: Duration(milliseconds: 100),
  //   //   curve: Curves.easeOutQuad,
  //   // );

  //   setState(() {
  //     _currentPage = value;
  //   });
  // }

  Future<bool> _closeRoom(BuildContext context) async {
    try {
      var answer = false;

      final spaceCubit = context.read<SpaceCubit>();

      final isCreatedByCurrentUser = spaceCubit.room!.isCreatedByCurrentUser;

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
        await spaceCubit.closeRoom();
      }

      // ? it's necessary because if return true and then use router will be exception
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong."),
        ),
      );
    } finally {
      return false;
    }
  }
}
