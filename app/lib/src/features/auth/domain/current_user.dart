import 'dart:ui';
import 'package:meme_card_game/src/extensions/color_extension.dart';
import '../../../constants/app_constants.dart' as app_constants;

class CurrentUser {
  late String id;
  late String login;
  late String? email;
  late Color? color;
  late Color? backgroundColor;
  String? imageUrl;

  CurrentUser({
    required this.id,
    required this.login,
    required this.email,
    required this.imageUrl,
    required this.color,
  });

  CurrentUser.fromMap(Map<String, dynamic> userRaw) {
    id = userRaw['id'];
    login = userRaw['login'];
    email = userRaw['email'];
    color = ColorExtension.fromHex(
        userRaw['color'] ?? app_constants.baseColorInHex);
    backgroundColor = ColorExtension.fromHex(
        userRaw['backgroundColor'] ?? app_constants.baseColorInHex);
    imageUrl = userRaw['imageUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "login": login,
      "email": email,
      "color": color?.toHex(),
      "backgroundColor": backgroundColor?.toHex(),
      "imageUrl": imageUrl,
    };
  }
}
