import 'dart:developer';
import 'dart:io';

import 'package:yaml/yaml.dart';

import '../utils/read_directory_files.dart';
import '../models/card.dart' show Card;

import 'package:supabase/supabase.dart';

import '../utils/get_environment_file_name.dart' show getEnvironmentFileName;

import '../constants/supabase_constants.dart' as supabase_constants;

/// [uploadDataScript] - upload all files and add it to db

Future<void> uploadCardsScript({bool isRelease = false}) async {
  try {
    log("Script uploadCardsScript started.");
    final configFile = File(getEnvironmentFileName(isRelease: isRelease));
    final yamlString = await configFile.readAsString();
    final environments = loadYaml(yamlString);

    final client = SupabaseClient(
      environments['SUPABASE_URL']!,
      environments['SUPABASE_ANNON_KEY']!,
    );

    await client.auth.signInWithPassword(
      email: environments['SUPABASE_ADMIN_EMAIL']!,
      password: environments['SUPABASE_ADMIN_PASSWORD']!,
    );

    final storageBucket = client.storage.from(supabase_constants.appBucket);

    const pathToFolder = '../supabase/assets/memes_pack';
    final imagesPaths = await readDirectoryFiles(pathToFolder);

    final imageFiles =
        imagesPaths!.map((imagePath) => File(imagePath)).toList();

    for (var imageFile in imageFiles) {
      try {
        final imagePath =
            "${supabase_constants.pathToCardsDirectory}/${imageFile.uri.pathSegments.last}";

        final uploadedImagePath = await storageBucket.upload(
          imagePath,
          imageFile,
        );

        final uploadedImagePublicUrl = storageBucket.getPublicUrl(imagePath);

        final card = Card(
          createdBy: client.auth.currentUser!.id,
          imageUrl: uploadedImagePublicUrl,
        );

        await client.from("cards").insert(card.toMap());
      } on StorageException catch (e) {
        if (e.statusCode == "409") continue; // Duplicate
      } catch (e) {
        rethrow;
      }
    }
    log("Script finished.");
  } catch (e) {
    log('uploadDataScript threw an exception: ${e}.');
    rethrow;
  }
}
