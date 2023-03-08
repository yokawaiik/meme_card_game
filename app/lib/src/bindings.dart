import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils/environment.dart' as environment;

class Bindings {
  /// Add dependencies to app
  static Future<void> dependencies() async {
    try {
      await dotenv.load(fileName: environment.fileName);

      await Future.wait([
        Supabase.initialize(
          url: dotenv.env['SUPABASE_URL']!,
          anonKey: dotenv.env['SUPABASE_ANNON_KEY']!,
          // debug: true,
        ),
      ]);
    } catch (e) {
      UnimplementedError('Error loading dependencies: $e');
    }
  }
}
