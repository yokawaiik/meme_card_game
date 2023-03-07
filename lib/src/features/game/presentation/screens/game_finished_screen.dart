import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes_constants.dart' as routes_constants;
import '../../widgets/player_list_tile.dart';
import '../cubit/game_cubit.dart';

class GameFinishedScreen extends StatefulWidget {
  late final GameCubit _gameCubit;

  GameFinishedScreen({super.key, required GameCubit gameCubit}) {
    _gameCubit = gameCubit;
  }

  @override
  State<GameFinishedScreen> createState() => _GameFinishedScreenState();
}

class _GameFinishedScreenState extends State<GameFinishedScreen> {
  @override
  void dispose() {
    widget._gameCubit.closeRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final room = widget._gameCubit.room!;

    final rankedPlayers = room.players!;
    rankedPlayers
        // .sort((playerA, playerB) => playerA.points.compareTo(playerB.points));
        .sort((playerA, playerB) => playerB.points.compareTo(playerA.points));

    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => _close(),
          ),
          title: Text("Results"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "The game finished",
                style: textTheme.displayMedium,
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: rankedPlayers.length,
                itemBuilder: (context, index) {
                  final player = rankedPlayers[index];

                  return PlayerListTile(
                    id: player.id,
                    login: player.login,
                    backgroundColor: player.backgroundColor,
                    color: player.color,
                    points: player.points,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    _close();
    return false;
  }

  void _close() {
    GoRouter.of(context).pushReplacementNamed(routes_constants.home);
  }
}
