import 'dart:developer';

import 'package:social_flutter/dto/result_type.dart';
import 'package:social_flutter/features/auth/data/auth_api_client.dart';
import 'package:social_flutter/features/auth/data/auth_local_data_source.dart';
import 'package:social_flutter/features/auth/dtos/login_dto.dart';
import 'package:social_flutter/features/auth/dtos/register_dto.dart';

class AuthRepository {
  final AuthApiClient authApiClient;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepository({ required this.authApiClient, required this.authLocalDataSource});

  Future<Result<void>> login({required String username, required String password})  async {
    try {
      log("Start logging in");
      final authenticationResult = await authApiClient.login(LoginDTO(username, password));
      log("Successfully retrieve access token ${authenticationResult.accessToken}");
      if (authenticationResult.code != 200) {
        return Failure(authenticationResult.responseMessage);
      }
      await authLocalDataSource.saveAccessToken(authenticationResult.accessToken);
      log("Finnish login request");
      return Success(null);
    } catch (e) {
      log('Exception: $e');
      return Failure('$e');
    }
  }

  Future<Result<void>> register({required String username, required String email, required String password})  async {
    try {
      log("Start register");
      await authApiClient.register(RegisterDto(username: username, email: email, password: password));
      log("Finnish register request");
      return Success(null);
    } catch (e) {
      log('Exception: $e');
      return Failure('$e');
    }
  }

  Future<Result<String?>> getAccessToken() async {
    try {
      final token = await authLocalDataSource.getAccessToken();
      return Success(token);
    } catch (e) {
      log('Exception $e');
      return Failure('$e');
    }
  }

  Future<Result<void>> logout() async {
    try {
      await authLocalDataSource.removeAccessToken();
      return Success(null);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }
}