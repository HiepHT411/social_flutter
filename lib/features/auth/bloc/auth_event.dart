part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthLoginStarted extends AuthEvent {
  final String username;
  final String password;

  AuthLoginStarted(this.username, this.password);
}

class AuthLoginPrefilled extends AuthEvent {
  AuthLoginPrefilled({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;
}

class AuthRegisterStarted extends AuthEvent {
  AuthRegisterStarted({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;
  final String password;
}

class AuthAuthenticateStarted extends AuthEvent {}

class AuthLogoutStarted extends AuthEvent {}