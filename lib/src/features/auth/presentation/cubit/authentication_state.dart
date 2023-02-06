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
  UnAuthenticatedState();
}

class AuthenticationLoadingState extends AuthenticationState {
  AuthenticationLoadingState();
}
