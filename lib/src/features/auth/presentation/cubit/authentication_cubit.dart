import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meme_card_game/src/extensions/color_extension.dart';
import 'package:meme_card_game/src/features/auth/data/current_user.dart';
import 'package:meme_card_game/src/features/auth/domain/avatar_generator_api_service.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/auth_api_service.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  CurrentUser? _currentUser;

  CurrentUser? get currentUser => _currentUser;

  bool get isUserSignedIn => _currentUser == null ? false : true;

  late StreamSubscription _onAuthStateChange;

  AuthenticationCubit() : super(AuthenticationInitialState()) {
    print('AuthCubit - start');

    final _supabase = Supabase.instance;

    _restoreSession(); // attempt to restores session

    final authSubscription = AuthApiService.onAuthStateChange()
      ..onData(_handleAuthStateChange);

    _onAuthStateChange = authSubscription;
  }

  void Function(AuthState)? _handleAuthStateChange(AuthState data) {
    try {
      final AuthChangeEvent event = data.event;
      if (kDebugMode) {
        print("AuthCubit - onAuthStateChange - event : $event ");
      }

      if (event == AuthChangeEvent.signedOut) {
        emit(UnAuthenticatedState());
      }
    } catch (e) {
      if (kDebugMode) {
        print("AuthCubit - onAuthStateChange - event : $e ");
      }
      emit(UnAuthenticatedState());
      rethrow;
    }
  }

  Future<void> _restoreSession() async {
    try {
      _currentUser = await AuthApiService.getCurrentUser();
      if (_currentUser == null) {
        emit(UnAuthenticatedState());
        _onAuthStateChange.pause();
      } else {
        emit(AuthenticatedState());
        _onAuthStateChange.resume();
      }
    } catch (e) {
      if (kDebugMode) {
        print('AuthCubit - _restoreSession - e: $e');
      }
      emit(UnAuthenticatedState());
      await logOut();
      _currentUser = null;
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      emit(AuthenticationLoadingState());
      _currentUser = await AuthApiService.signIn(email, password);
      emit(AuthenticatedState());
      _onAuthStateChange.resume();
    } catch (e) {
      emit(UnAuthenticatedState());
      _onAuthStateChange.pause();
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      emit(AuthenticationLoadingState());

      await AuthApiService.logOut();
    } catch (e) {
      if (kDebugMode) {
        print('AuthCubit - logOut - e : $e');
      }

      rethrow;
    } finally {
      _onAuthStateChange.pause();
      _currentUser = null;
      emit(UnAuthenticatedState());
    }
  }

  Future<void> signUp(
    String login,
    String email,
    String password,
  ) async {
    try {
      emit(AuthenticationLoadingState());

      final userColor = ColorExtension.generateColor().toHex();

      final generatedUserAvatarBinary =
          await AvatarGeneratorApiService.generateRandomAvatarBinary();

      _currentUser = await AuthApiService.signUp(
        login,
        email,
        password,
        userColor,
        generatedUserAvatarBinary,
      );

      emit(AuthenticatedState());
      _onAuthStateChange.resume();
    } catch (e) {
      emit(UnAuthenticatedState());
      _currentUser = null;
      _onAuthStateChange.pause();
      rethrow;
    }
  }
}
