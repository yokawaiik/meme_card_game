import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';
import 'package:meme_card_game/src/features/game/presentation/screens/game_create_screen.dart';
import 'package:meme_card_game/src/features/game/presentation/screens/game_lobby_screen.dart';
import 'package:meme_card_game/src/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:meme_card_game/src/routing/middleware_guard_wrapper.dart';

import '../features/auth/presentation/screens/auth_screen.dart';
import '../features/auth/presentation/screens/error_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/game/presentation/screens/join_game_screen.dart';

import '../features/profile/presentation/screens/profile_view.dart';
import './routes_constants.dart' as routes_constants;
import './middleware_guards.dart' as middleware_guards;

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: routes_constants.splashPath,
  routerNeglect: true, // ? stop to tracking history in browser
  routes: [
    GoRoute(
      name: routes_constants.splash,
      path: routes_constants.splashPath,
      builder: (context, state) => const SplashScreen(),
      redirect: (context, state) => middlewareGuardWrapper(
        context,
        state,
        [
          middleware_guards.guestRequired,
        ],
      ),
    ),
    GoRoute(
      name: routes_constants.auth,
      path: routes_constants.authPath,
      builder: (context, goRouterState) {
        return BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticatedState) {
              context.pushReplacementNamed(routes_constants.home);
            }
          },
          child: const AuthScreen(),
        );
      },
      redirect: (context, state) => middlewareGuardWrapper(
        context,
        state,
        [
          middleware_guards.guestRequired,
        ],
      ),
    ),
    GoRoute(
      name: routes_constants.home,
      path: routes_constants.homePath,
      builder: (context, goRouterState) {
        return BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is! AuthenticatedState) {
              context.pushReplacementNamed(routes_constants.auth);
            }
          },
          child: const HomeScreen(),
        );
      },
      routes: [
        GoRoute(
          name: routes_constants.game,
          path: routes_constants.gameCreatePath,
          builder: (context, goRouterState) => BlocProvider.value(
            value: BlocProvider.of<GameCubit>(context),
            child: GameCreateScreen(),
          ),
          routes: [],
        ),
        GoRoute(
          name: routes_constants.joinGame,
          path: routes_constants.joinGamePath,
          builder: (context, goRouterState) => BlocProvider.value(
            value: BlocProvider.of<GameCubit>(context),
            child: JoinGameScreen(),
          ),
        ),
        GoRoute(
          name: routes_constants.gameLobby,
          path: routes_constants.gameLobbyPath,
          // todo add guard: user can't go here if channel wasn't connected
          builder: (context, goRouterState) => BlocProvider.value(
            value: BlocProvider.of<GameCubit>(context),
            child: GameLobbyScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      name: routes_constants.editProfile,
      path: routes_constants.editProfilePath,
      builder: (context, goRouterState) => const EditProfileScreen(),
      redirect: (context, state) => middlewareGuardWrapper(
        context,
        state,
        [
          middleware_guards.authRequired,
        ],
      ),
    ),
    GoRoute(
      name: routes_constants.error,
      path: routes_constants.errorPath,
      builder: (context, state) {
        return const ErrorScreen();
      },
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);
