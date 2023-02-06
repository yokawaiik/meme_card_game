import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

FutureOr<String?> middlewareGuardWrapper(
  BuildContext context,
  GoRouterState goRouterState,
  List<FutureOr<String?> Function(BuildContext, GoRouterState)> middlewares,
) {
  for (var middleware in middlewares) {
    final guardResult = middleware(context, goRouterState);
    if (guardResult != null) return guardResult;
  }
  return null;
}
