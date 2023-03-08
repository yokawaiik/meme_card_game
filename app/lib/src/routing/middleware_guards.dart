import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';

import '../features/auth/presentation/cubit/authentication_cubit.dart';
import './routes_constants.dart' as routes_constants;

FutureOr<String?> authRequired(
  BuildContext context,
  GoRouterState goRouterState,
) {
  final authCubit = context.read<AuthenticationCubit>();

  if (!authCubit.isUserSignedIn) {
    return routes_constants.splashPath;
  } else if (authCubit.isUserSignedIn &&
      goRouterState.name == routes_constants.auth) {
    return routes_constants.homePath;
  }

  return null;
}

FutureOr<String?> guestRequired(
  BuildContext context,
  GoRouterState goRouterState,
) {
  final authCubit = context.read<AuthenticationCubit>();

  if (authCubit.isUserSignedIn) {
    return routes_constants.homePath;
  }

  return null;
}

FutureOr<String?> gameRoomRequired(
  BuildContext context,
  GoRouterState goRouterState,
) {
  final gameCubit = context.read<GameCubit>();

  if (gameCubit.room == null) {
    return routes_constants.homePath;
  }

  return null;
}

FutureOr<String?> gameFinished(
  BuildContext context,
  GoRouterState goRouterState,
) {
  final gameCubit = context.read<GameCubit>();

  if (gameCubit.room == null || gameCubit.room!.isGameFinished != true) {
    return routes_constants.homePath;
  }

  return null;
}
