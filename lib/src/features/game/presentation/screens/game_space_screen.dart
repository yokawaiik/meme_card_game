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
  // late int _currentView;
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
    // _currentView = 0;
    _pageViewController = PageController(
      initialPage: 0,
    );

    super.initState();
  }
  // todo: slider with cards in bottom modal sheet
  // todo: main screen has situation with description and in content-part chosen cards by players

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () => _closeRoom(context),
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.close),
          //   onPressed: () {
          //     // todo: add logic here
          //     // GoRouter.of(context).pop();
          //     // _closeRoom(context);
          //   },
          // ),

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
            if (current is SpaceCardPickedState ||
                current is SpaceGameFinishedState ||
                current is SpaceLoadingState ||
                current is SpaceSituationPickedState ||
                current is SpaceVotedForCardState ||
                current is SpaceNextRoundState ||
                current is SpaceFailureState) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            // ? info notify player about mistake
            if (state is SpaceFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error.toString())),
              );
            }

            final spaceCubit = context.read<SpaceCubit>();

            late final void Function()? onPressedFloatingActionButton;
            late final String buttonText;

            // ? if situation wasn't chosen and necessary choose it
            if (spaceCubit.room!.situationList.length !=
                    spaceCubit.room!.currentRoundNumber &&
                spaceCubit
                    .room!.roomConfiguration.automaticSituationSelection &&
                spaceCubit.room!.isCreatedByCurrentUser) {
              onPressedFloatingActionButton = () {
                // todo: realise pick situation by player
                UnimplementedError("This feature wasn't realised.");
              };
              buttonText = "Pick situation";
            }
            // ?if situation was chosen and necessary to choose card
            else if (spaceCubit.room!.currentGameRound.pickedCardId == null) {
              onPressedFloatingActionButton = () {
                _pageViewController.jumpToPage(1);
              };
              buttonText = "Pick card";
            }

            // ? if card was chosen and necessary to vote

            else if (spaceCubit.room!.currentGameRound.votedCardId == null) {
              onPressedFloatingActionButton = () {
                _pageViewController.jumpToPage(2);
              };
              buttonText = "Vote for card";
            }
            // ? if card was chosen and necessary player ready for the next round

            else if (spaceCubit.room!.currentGameRound.isReadyForNextRound ==
                false) {
              // ? vote for next round
              onPressedFloatingActionButton = () {
                spaceCubit.readyForNextRound();
              };
              buttonText = "Ready for next round";
            }

            if (spaceCubit.room!.currentRoundPlayersReadyCount >
                spaceCubit.room!.players!.length) {
              onPressedFloatingActionButton = () {
                spaceCubit.nextRound();
              };
              buttonText = "Next round";
            } else if (spaceCubit.room!.currentGameRound ==
                spaceCubit.room!.pickedSituationList) {
              onPressedFloatingActionButton = () {
                spaceCubit.finishGame();
              };
              buttonText = "Finish game";
            } else {
              onPressedFloatingActionButton = null;
              buttonText = "Wait for others";
            }

            //todo: if round end creator have to press to finish

            // // todo: if game ended and need to look at stats

            return FloatingActionButton.extended(
              onPressed: onPressedFloatingActionButton,
              label: Text(buttonText),
              icon: Icon(Icons.image_rounded),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onViewChange,
          items: const [
            BottomNavigationBarItem(
              label: "Board",
              icon: Icon(
                Icons.games_rounded,
              ),
            ),

            // todo: available only for creator if works non-generation situation mode
            // BottomNavigationBarItem(
            //   label: "Situations",
            //   icon: Icon(
            //     Icons.list_alt_rounded,
            //   ),
            // ),

            BottomNavigationBarItem(
              label: "Cards",
              icon: Icon(
                Icons.sentiment_satisfied_alt_outlined,
              ),
            ),

            BottomNavigationBarItem(
              label: "Stats",
              icon: Icon(
                Icons.leaderboard,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onViewChange(value) {
    setState(() {
      // _currentView = value;
      _pageViewController.jumpToPage(value);
    });
  }

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
      print("e : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong."),
        ),
      );
    } finally {
      return false;
    }
  }

  // void _chooseCard(BuildContext context) async {
  //   // todo: _chooseCard
  //   final colorScheme = Theme.of(context).colorScheme;
  //   final textTheme = Theme.of(context).textTheme;

  //   await showModalBottomSheet(
  //     context: context,
  //     builder: (context) => Column(
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 15),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               Text(
  //                 "Choose a card",
  //                 // style: textTheme.headlineSmall,
  //                 style: textTheme.titleLarge,
  //               ),
  //               Spacer(),
  //               IconButton(
  //                 onPressed: () {
  //                   GoRouter.of(context).pop();
  //                 },
  //                 icon: Icon(Icons.close),
  //               ),
  //             ],
  //           ),
  //         ),
  //         CarouselSlider.builder(
  //           options: CarouselOptions(
  //             height: 300,
  //             viewportFraction: 1,
  //             enableInfiniteScroll: false,
  //           ),
  //           itemCount: 10, // todo: change it
  //           itemBuilder: (context, index, realIndex) {
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 5,
  //               ),
  //               child: Container(
  //                 color: colorScheme.secondaryContainer,
  //                 child: Center(
  //                   child: Icon(
  //                     Icons.image,
  //                     size: 100,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         // Text("Choose a card")
  //       ],
  //     ),
  //   );
  // }
}
