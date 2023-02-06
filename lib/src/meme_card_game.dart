import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import './routing/router.dart';

import 'features/auth/presentation/cubit/authentication_cubit.dart';

class MemeCardGame extends StatelessWidget {
  const MemeCardGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationCubit(),
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color.fromARGB(255, 127, 134, 61),
        ),
        routerConfig: router,
      ),
    );
  }
}
