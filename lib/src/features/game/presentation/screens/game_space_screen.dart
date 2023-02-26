import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/common_widgets/default_text_field.dart';
import 'package:meme_card_game/src/common_widgets/keep_alive_wrapper.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';

import '../../../../routing/routes_constants.dart' as routes_constants;
import 'game_space_board_view.dart';
import 'game_space_players_view.dart';

class GameSpaceScreen extends StatefulWidget {
  const GameSpaceScreen({super.key});

  @override
  State<GameSpaceScreen> createState() => _GameSpaceScreenState();
}

class _GameSpaceScreenState extends State<GameSpaceScreen> {
  late final List<Widget> _views;
  // late int _currentView;
  late final PageController _pageViewController;

  @override
  void initState() {
    _views = [
      const KeepAliveWrapper(
        child: GameSpaceBoardView(),
      ),
      const KeepAliveWrapper(
        child: GameSpacePlayersView(),
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
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              // todo: add logic here
              // GoRouter.of(context).pop();
              // _closeRoom(context);
            },
          ),
          title: const Text(
            'Game space',
          ),
        ),
        // body: _views[_currentView],
        body: PageView(
          controller: _pageViewController,
          pageSnapping: false,
          onPageChanged: _onViewChange,
          children: _views,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _chooseCard(context),
          label: Text("Show cards"),
          icon: Icon(Icons.image_rounded),
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
            BottomNavigationBarItem(
              label: "Players",
              icon: Icon(
                Icons.people_alt_rounded,
              ),
            ),

            // todo: available only for creator if works non-generation situation mode
            // BottomNavigationBarItem(
            //   label: "Situations",
            //   icon: Icon(
            //     Icons.list_alt_rounded,
            //   ),
            // ),
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

  void _chooseCard(BuildContext context) async {
    // todo: _chooseCard
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    await showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Choose a card",
                  // style: textTheme.headlineSmall,
                  style: textTheme.titleLarge,
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
          CarouselSlider.builder(
            options: CarouselOptions(
              height: 300,
              viewportFraction: 1,
              enableInfiniteScroll: false,
            ),
            itemCount: 10, // todo: change it
            itemBuilder: (context, index, realIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Container(
                  color: colorScheme.secondaryContainer,
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 100,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          // Text("Choose a card")
        ],
      ),
    );
  }
}
