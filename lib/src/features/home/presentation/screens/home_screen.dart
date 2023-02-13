import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:meme_card_game/src/features/profile/presentation/screens/profile_view.dart';

import '../../../../routing/routes_constants.dart' as routes_constants;
import '../../../game/presentation/screens/select_game_mode_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int currentPageIndex;

  late List<Widget> screens;

  @override
  void initState() {
    currentPageIndex = 0;

    screens = [SelectGameModeView(), ProfileView()];

    super.initState();
  }

  void _logOut(BuildContext context) async {
    try {
      final authCubit = context.read<AuthenticationCubit>();

      await authCubit.logOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unexpected Error.",
          ),
        ),
      );
    }
  }

  // _openProfile(BuildContext context) {
  //   context.goNamed(routes_constants.profile);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(actions: [
      //   PopupMenuButton(
      //     icon: const Icon(Icons.more_horiz),
      //     itemBuilder: (context) {
      //       return [
      //         PopupMenuItem(
      //           child: const ListTile(
      //             leading: Icon(Icons.person_4),
      //             title: Text("Profile"),
      //           ),
      //           onTap: () => _openProfile(context),
      //         ),
      //         PopupMenuItem(
      //           child: const ListTile(
      //             leading: Icon(Icons.logout),
      //             title: Text("Log out"),
      //           ),
      //           onTap: () => _logOut(context),
      //         ),
      //       ];
      //     },
      //   )
      // ]),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Center(
      //       child: Text('Home screen'),
      //     )
      //   ],
      // ),
      body: screens[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.games),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_4),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
