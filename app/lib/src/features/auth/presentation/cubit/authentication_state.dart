part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitialState extends AuthenticationState {
  AuthenticationInitialState();
}

class AuthenticatedState extends AuthenticationState {
  AuthenticatedState();
}

class UnAuthenticatedState extends AuthenticationState {
  final Object? message;

  UnAuthenticatedState([this.message]);
}

class AuthenticationLoadingState extends AuthenticationState {
  AuthenticationLoadingState();
}
