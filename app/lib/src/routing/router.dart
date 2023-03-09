import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/space_cubit.dart';
import 'package:meme_card_game/src/features/game/presentation/screens/game_create_screen.dart';
import 'package:meme_card_game/src/features/game/presentation/screens/game_lobby_screen.dart';
import 'package:meme_card_game/src/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:meme_card_game/src/routing/middleware_guard_wrapper.dart';

import '../features/auth/presentation/screens/auth_screen.dart';
import '../features/auth/presentation/screens/error_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/game/presentation/screens/game_finished_screen.dart';
import '../features/game/presentation/screens/game_space_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/game/presentation/screens/join_game_screen.dart';

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
          listener: (ctx, state) {
            if (state is! AuthenticatedState) {
              context.pushReplacementNamed(routes_constants.auth);
            }
          },
          child: const HomeScreen(),
        );
      },
      routes: [
        GoRoute(
          name: routes_constants.gameCreate,
          path: routes_constants.gameCreatePath,
          builder: (context, goRouterState) {
            return BlocListener<GameCubit, GameState>(
              listenWhen: (previous, current) {
                if (previous is CreatedGameState &&
                    current is JoinedRoomState) {
                  return true;
                }
                return false;
              },
              listener: (context, state) {
                context.pushReplacementNamed(routes_constants.gameLobby);
              },
              child: const GameCreateScreen(),
            );
          },
          redirect: (context, state) => middlewareGuardWrapper(
            context,
            state,
            [
              middleware_guards.authRequired,
            ],
          ),
        ),
        GoRoute(
          name: routes_constants.joinGame,
          path: routes_constants.joinGamePath,
          builder: (context, goRouterState) {
            return BlocListener<GameCubit, GameState>(
              listener: (ctx, state) {
                if (state is JoinedRoomState) {
                  GoRouter.of(ctx)
                      .pushReplacementNamed(routes_constants.gameLobby);
                } else if (state is DeletedGameState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Attempt to join a non-existent room."),
                    ),
                  );
                }
              },
              listenWhen: (previous, current) {
                if (current is LoadingGameState ||
                    current is JoinedRoomState ||
                    current is DeletedGameState) {
                  return true;
                }

                return false;
              },
              child: const JoinGameScreen(),
            );
          },
          redirect: (context, state) => middlewareGuardWrapper(
            context,
            state,
            [
              middleware_guards.authRequired,
            ],
          ),
        ),
        GoRoute(
          name: routes_constants.gameLobby,
          path: routes_constants.gameLobbyPath,
          builder: (context, goRouterState) =>
              BlocListener<GameCubit, GameState>(
            listenWhen: (previous, current) {
              if (current is StartedGameState ||
                  current is DeletedGameState ||
                  current is LeftRoomState) {
                return true;
              }
              return false;
            },
            listener: (ctx, state) {
              if (state is StartedGameState) {
                GoRouter.of(context)
                    .pushReplacementNamed(routes_constants.gameSpace);
              } else if (state is DeletedGameState || state is LeftRoomState) {
                GoRouter.of(context)
                    .pushReplacementNamed(routes_constants.gameCreate);
              }
            },
            child: const GameLobbyScreen(),
          ),
          redirect: (context, state) => middlewareGuardWrapper(
            context,
            state,
            [
              middleware_guards.authRequired,
              middleware_guards.gameRoomRequired,
            ],
          ),
        ),
        GoRoute(
          name: routes_constants.gameSpace,
          path: routes_constants.gameSpacePath,
          builder: (context, goRouterState) {
            return BlocProvider(
              create: (context) => SpaceCubit(
                authenticationCubit: context.read<AuthenticationCubit>(),
                gameCubit: context.read<GameCubit>(),
              ),
              child: BlocListener<SpaceCubit, SpaceState>(
                listenWhen: (previous, current) {
                  if (current is SpaceGameDeletedState) {
                    return true;
                  }
                  if (current is SpaceGameFinishedState) {
                    return true;
                  }
                  return false;
                },
                listener: (context, state) {
                  if (state is SpaceGameDeletedState) {
                    GoRouter.of(context)
                        .pushReplacementNamed(routes_constants.home);
                  } else if (state is SpaceGameFinishedState) {
                    GoRouter.of(context)
                        .pushReplacementNamed(routes_constants.gameFinished);
                  }
                },
                child: const GameSpaceScreen(),
              ),
            );
          },
          redirect: (context, state) => middlewareGuardWrapper(
            context,
            state,
            [
              middleware_guards.authRequired,
              middleware_guards.gameRoomRequired,
            ],
          ),
        ),
        GoRoute(
          name: routes_constants.gameFinished,
          path: routes_constants.gameFinishedPath,
          builder: (context, goRouterState) {
            final gameCubit = context.read<GameCubit>();

            return GameFinishedScreen(
              gameCubit: gameCubit,
            );
          },
          redirect: (context, state) => middlewareGuardWrapper(
            context,
            state,
            [middleware_guards.gameFinished],
          ),
        ),
      ],
    ),
    // todo: redo it
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
