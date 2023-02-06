import 'package:flutter/material.dart';
import 'package:meme_card_game/src/bindings.dart';
import 'package:meme_card_game/src/meme_card_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Bindings.dependencies();

  runApp(const MemeCardGame());
}
