import 'dart:developer';
import 'dart:io';

import 'package:dice_bear/dice_bear.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meme_card_game/src/models/avatar_generator_exception.dart';

class AvatarGeneratorApiService {
  static Future<Avatar?> generateRawRandomAvatar(
      [Color? backgroundColor]) async {
    try {
      log('AvatarGeneratorApiService - generateRawAvatar - start');
      Avatar avatar = DiceBearBuilder.withRandomSeed(
        sprite: DiceBearSprite.bigSmile,
        backgroundColor: backgroundColor,
      ).build();

      return avatar;
    } catch (e) {
      log('AvatarGeneratorApiService - Error : $e');
      throw AvatarGeneratorException('Unknown exception', e.toString());
    }
  }

  static Future<File?> generateRandomAvatarFile([
    Color? backgroundColor,
  ]) async {
    try {
      final rawSvgBytesAvatar =
          await (await generateRawRandomAvatar(backgroundColor))
              ?.asRawSvgBytes();

      if (rawSvgBytesAvatar == null) {
        throw Exception("Avatar wasn't generated.");
      }

      return File.fromRawPath(rawSvgBytesAvatar);
    } catch (e) {
      log('AvatarGeneratorApiService - Error : $e');
      throw AvatarGeneratorException('Unknown exception', e.toString());
    }
  }

  static Future<Uint8List?> generateRandomAvatarBinary([
    Color? backgroundColor,
  ]) async {
    try {
      final rawSvgBytesAvatar =
          await (await generateRawRandomAvatar(backgroundColor))
              ?.asRawSvgBytes();

      if (rawSvgBytesAvatar == null) {
        throw Exception("Avatar wasn't generated.");
      }

      return rawSvgBytesAvatar;
    } catch (e) {
      log('AvatarGeneratorApiService - Error : $e');
      throw AvatarGeneratorException('Unknown exception', e.toString());
    }
  }
}
