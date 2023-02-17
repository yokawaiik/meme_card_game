import 'dart:ui';

import 'package:meme_card_game/src/extensions/color_extension.dart';

import '../../../constants/app_constants.dart' as app_constants;

class Player {
  // base parameters
  final String id;
  final String login;
  late final Color color;
  late final Color backgroundColor;
  final bool isCurrentUser;
  final bool isCreator;

  int? points;

  Player({
    required this.id,
    required this.login,
    required this.isCurrentUser,
    this.isCreator = false,
    Color? color,
    Color? backgroundColor,
    this.points,
  }) {
    this.color = color ?? ColorExtension.fromHex(app_constants.baseColorInHex);
    this.backgroundColor = backgroundColor ??
        ColorExtension.fromHex(app_constants.baseBackgroundColorInHex);
  }
}
