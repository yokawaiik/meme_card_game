import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meme_card_game/src/features/auth/data/current_user_model.dart';
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

    final authSubscription = AuthApiService.onAuthStateChange()
      ..onData(_handleAuthStateChange);

    _onAuthStateChange = authSubscription;

    _restoreSession(); // attempt to restores session
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
      emit(UnAuthenticatedState());
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
      _currentUser = await AuthApiService.signUp(login, email, password);
      emit(AuthenticatedState());
      _onAuthStateChange.resume();
    } catch (e) {
      emit(UnAuthenticatedState());
      _onAuthStateChange.pause();
      rethrow;
    }
  }
}
