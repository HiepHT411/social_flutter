import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_flutter/dto/result_type.dart';
import 'package:social_flutter/features/auth/bloc/auth_event.dart';
import 'package:social_flutter/features/auth/bloc/auth_state.dart';
import 'package:social_flutter/features/auth/data/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginStarted>(_onLoginStarted);
    on<AuthRegisterStarted>(_onRegisterStarted);
    on<AuthLoginPrefilled>(_onLoginPrefilled);
    on<AuthAuthenticateStarted>(_onAuthenticateStarted);
    on<AuthLogoutStarted>(_onAuthLogoutStarted);
  }

  final AuthRepository authRepository;

  void _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthAuthenticateUnauthenticated());
  }

  void _onLoginStarted(AuthLoginStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoginInProgress());
    await Future.delayed(const Duration(seconds: 1));
    log('Auth blog handle AuthLoginStarted');
    final result = await authRepository.login(username: event.username, password: event.password);

    switch (result) {
      case Success():
        emit(AuthLogInSuccess());
      case Failure():
        emit(AuthLoginFailure(result.message));
    }
  }

  void _onRegisterStarted(AuthRegisterStarted event, Emitter<AuthState> emit) {

  }

  void _onLoginPrefilled(AuthLoginPrefilled event, Emitter<AuthState> emit) async {
    emit(AuthLoginInitial(username: event.username, password: event.password));
  }

  void _onAuthenticateStarted(
      AuthAuthenticateStarted event, Emitter<AuthState> emit) async {
    final result = await authRepository.getAccessToken();
    return (switch (result) {
      Success(data: final token) when token != null =>
          emit(AuthAuthenticateSuccess(token)),
      Success() => emit(AuthAuthenticateUnauthenticated()),
      Failure() => emit(AuthAuthenticateFailure(result.message)),
    });
  }

  void _onAuthLogoutStarted(
      AuthLogoutStarted event, Emitter<AuthState> emit) async {
    final result = await authRepository.logout();
    return (switch (result) {
      Success() => emit(AuthLogoutSuccess()),
      Failure() => emit(AuthLogoutFailure(result.message)),
    });
  }
}
