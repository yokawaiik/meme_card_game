import 'dart:developer';

import 'package:auto_scripts/models/situation.dart';

import '../utils/get_environments_from_yaml.dart';
import '../utils/get_map_from_json_file.dart';

import 'package:supabase/supabase.dart';

import '../utils/get_environment_file_name.dart' show getEnvironmentFileName;

/// [addSituationsScript] - upload all files and add it to db

Future<void> addSituationsScript({bool isRelease = false}) async {
  try {
    print("Script addSituationsScript started.");

    final environments = await getEnvironmentsFromYaml(
        getEnvironmentFileName(isRelease: isRelease));

    final client = SupabaseClient(
      environments['SUPABASE_URL']!,
      environments['SUPABASE_ANNON_KEY']!,
    );

    await client.auth.signInWithPassword(
      email: environments['SUPABASE_ADMIN_EMAIL']!,
      password: environments['SUPABASE_ADMIN_PASSWORD']!,
    );

    final situationPack =
        await getDataFromJsonFile("assets/situations/situations_pack_1.json");

    if (situationPack["isUploaded"] == true) {
      throw Exception("Such situations pack has already been uploaded.");
    }

    for (var situationRaw in situationPack["situations"]) {
      final situation = Situation(
        description: situationRaw["description"],
        createdBy: client.auth.currentUser!.id,
      );

      await client.from("situations").insert(situation.toMap());
    }
    print("Script finished.");
  } catch (e) {
    print('uploadDataScript threw an exception: ${e}.');
    rethrow;
  }
}
