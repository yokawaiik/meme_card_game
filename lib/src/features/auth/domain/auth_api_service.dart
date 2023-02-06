import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/supabase_exception.dart';
import '../data/current_user_model.dart';
import '../presentation/cubit/authentication_cubit.dart'
    as authentication_cubit;

class AuthApiService {
  static final _supabase = Supabase.instance;

  static Future<CurrentUser?> signIn(String email, String password) async {
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

      final currentUser = CurrentUser.fromMap(userRaw);
      return currentUser;
    } catch (e) {
      if (kDebugMode) {
        print("AuthApiService - signIn - e : $e");
      }
      rethrow;
    }
  }

  static Future<CurrentUser?> signUp(
    String login,
    String email,
    String password,
  ) async {
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
      };

      await _supabase.client.from("users").insert(userParams);

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
        print("AuthService - signUp - e: $e");
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
        print("AuthService - checkIfLoginExists - e: $e");
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
