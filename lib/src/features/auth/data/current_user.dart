import 'dart:html';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:meme_card_game/src/extensions/color_extension.dart';
import '../../../constants/app_constants.dart' as app_constants;

class CurrentUser {
  late String id;
  late String login;
  late String? email;
  late Color? color;

  String? imageUrl;
  late bool isAvatartSvg;

  CurrentUser({
    required this.id,
    required this.login,
    required this.email,
    required this.imageUrl,
    required this.color,
    this.isAvatartSvg = false,
  });

  CurrentUser.fromMap(Map<String, dynamic> userRaw) {
    id = userRaw['id'];
    login = userRaw['login'];
    email = userRaw['email'];
    color = ColorExtension.fromHex(
        userRaw['color'] ?? app_constants.baseColorInHex);
    imageUrl = userRaw['imageUrl'];
    isAvatartSvg = userRaw['isImageSvg'] ?? false;
  }
}
