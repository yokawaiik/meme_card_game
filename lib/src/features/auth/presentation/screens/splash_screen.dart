import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes_constants.dart' as routes_constants;
import '../cubit/authentication_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> goToHome(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      if (context.mounted) {
        context.pushReplacementNamed(routes_constants.auth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    goToHome(context);

    return Scaffold(
      backgroundColor: colorScheme.secondaryContainer,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Meme Card Game',
              style: TextStyle(
                color: colorScheme.onSecondaryContainer,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
