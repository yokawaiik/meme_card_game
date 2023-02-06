import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

// FutureOr<String?> routeExists(
//   BuildContext context,
//   GoRouterState goRouterState,
// ) {
//   if (goRouterState.error != null) {
//     // todo: add screen with error 404
//     return routes_constants.splash;
//   }

//   return null;
// }
