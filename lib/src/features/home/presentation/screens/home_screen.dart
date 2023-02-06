import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logOut(BuildContext context) async {
    try {
      final authCubit = context.read<AuthenticationCubit>();

      await authCubit.logOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unexpected Error.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        PopupMenuButton(
          icon: Icon(Icons.more_horiz),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Log out"),
                ),
                onTap: () => _logOut(context),
              ),
            ];
          },
        )
      ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('Home screen'),
          )
        ],
      ),
    );
  }
}
