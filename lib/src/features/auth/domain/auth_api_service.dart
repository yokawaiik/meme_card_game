import 'dart:async';
import 'dart:io' as io;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/supabase_exception.dart';
import '../data/current_user.dart';

import '../../../constants/supabase_constants.dart' as supabase_constants;
import '../utils/generate_image_path.dart';

// import 'package:mime/mime.dart';

class AuthApiService {
  static final _supabase = Supabase.instance;
  static final storage = _supabase.client.storage;

  static Future<CurrentUser?> signIn(String email, String password) async {
    // todo: when user doesn't exist
    try {
      final result = await _supabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        throw SupabaseException("Database error", "Sign in error");
      }

      final userRaw = await _supabase.client
          .from('users')
          .select()
          .eq('id', result.user!.id)
          .single() as Map<String, dynamic>;

      print("signIn - userRaw : $userRaw");

      final currentUser = CurrentUser.fromMap(userRaw);
      return currentUser;
    } catch (e) {
      if (kDebugMode) {
        print("AuthApiService - signIn - e : $e");
      }
      rethrow;
    }
  }

  static Future<CurrentUser?> signUp(String login, String email,
      String password, String? userColor, String? userBackgroundColor) async {
    try {
      Map<String, dynamic> paramsCheckUser = {
        "in_login": login,
        "in_email": email,
      };

      final isUserExists = await checkIfUserExists(paramsCheckUser);
      if (isUserExists.containsValue(true)) {
        List<String> message = [];

        if (isUserExists["result_login"]) {
          message.add("Such login already exist.");
        }
        if (isUserExists["result_email"]) {
          message.add("Such email already exist.");
        }
        throw SupabaseException(
          "Sign Up error",
          message.join(" "),
          KindOfException.auth,
        );
      }

      final result =
          await _supabase.client.auth.signUp(email: email, password: password);

      if (result.user == null) {
        throw SupabaseException(
          "Database error",
          "Sign up error.",
        );
      }

      final createdUser = _supabase.client.auth.currentUser;

      Map<String, dynamic> userParams = {
        "login": login,
        "email": email,
        "id": createdUser?.id,
        "createdAt": createdUser?.createdAt,
        "color": userColor,
        "backgroundColor": userBackgroundColor,
        "imageUrl": null,
      };

      await _supabase.client.from("users").insert(userParams);

      // if (generatedUserAvatarBinary != null) {
      //   // ? info: because uploadAvatarToStorage can not to upload a file
      //   final imageUrl = await uploadAvatarToStorage(
      //     createdUser!.id,
      //     generatedUserAvatarBinary,
      //   );

      //   Map<String, dynamic> updatedParams = {
      //     "isImageSvg": true,
      //     "imageUrl": imageUrl,
      //   };

      //   await _supabase.client
      //       .from("users")
      //       .update(
      //         updatedParams,
      //       )
      //       .eq("id", createdUser.id);
      // }

      final userRaw = await _supabase.client
          .from('users')
          .select()
          .eq('id', result.user!.id)
          .single() as Map<String, dynamic>;

      final currentUser = CurrentUser.fromMap(userRaw);

      return currentUser;
    } on SupabaseException catch (e) {
      if (kDebugMode) {
        print("AuthService - signUp - SupabaseException - e: $e");
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print("AuthService - signUp - e: ${e}");
      }
      rethrow;
    }
  }

  static Future<String?> uploadAvatarToStorage(
    String userId,
    Uint8List avatarBinary,
  ) async {
    try {
      final bucket = storage.from(supabase_constants.appBucket);

      final imagePath = generateImagePath(
        rawFilePath: supabase_constants.baseUserAvatarFileName,
        fileName: supabase_constants.baseUserAvatarFileName,
        inDirectoryName: '${supabase_constants.userAvatarDirectory}/$userId',
      );

      final uploadedImagePath =
          await bucket.uploadBinary(imagePath, avatarBinary);

      final uploadedImageUrl = bucket.getPublicUrl(uploadedImagePath);

      return uploadedImageUrl;
    } catch (e) {
      if (kDebugMode) {
        print("AuthService - uploadAvatarToStorage - e: $e");
      }
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> checkIfUserExists(
      Map<String, dynamic> params) async {
    try {
      final recordedUser = await _supabase.client.rpc(
        "check_if_user_exist",
        params: params,
      );

      return recordedUser;
    } catch (e) {
      if (kDebugMode) {
        print("AuthService - checkIfLoginExists - e: $e");
      }
      rethrow;
    }
  }

  static Future<CurrentUser?> getCurrentUser() async {
    try {
      if (_supabase.client.auth.currentUser == null) return null;

      final userRaw = await _supabase.client
          .from('users')
          .select()
          .eq('id', _supabase.client.auth.currentUser!.id)
          .single() as Map<String, dynamic>;

      final currentUser = CurrentUser.fromMap(userRaw);
      return currentUser;
    } catch (e) {
      if (kDebugMode) {
        print("AuthService - getCurrentUser - e: $e");
      }
      rethrow;
    }
  }

  static Future<void> logOut() async {
    try {
      await _supabase.client.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print("AuthService - logOut - e: $e");
      }
      rethrow;
    }
  }

  static StreamSubscription<AuthState> onAuthStateChange() {
    final authSubscription =
        _supabase.client.auth.onAuthStateChange.listen((data) => data);

    return authSubscription;
  }
}
