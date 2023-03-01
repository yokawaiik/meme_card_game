import 'dart:io';

import 'package:auto_scripts/scripts/add_situations_script.dart';
import 'package:auto_scripts/scripts/upload_cards_script.dart';

void main(List<String> arguments) async {
  await uploadCardsScript();
  await addSituationsScript();
  exit(0);
}
