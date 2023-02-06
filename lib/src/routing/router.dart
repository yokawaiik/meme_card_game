import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:meme_card_game/src/routing/middleware_guard_wrapper.dart';

import '../features/auth/presentation/screens/auth_screen.dart';
import '../features/auth/presentation/screens/error_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';

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
