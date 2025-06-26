

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:social_flutter/features/auth/dtos/login_dto.dart';
import 'package:social_flutter/features/auth/dtos/authentication_result.dart';

class AuthApiClient {

  final Dio dio; // mostly used in real world application over http package

  AuthApiClient(this.dio);

  Future<AuthenticationResult> login(LoginDTO loginDto) async {
    try {
      final response = await dio.post('/auth/authenticate', data: loginDto.toJson());
      log('Login response $response');
      return AuthenticationResult.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response == null) {
        throw Exception(e.message);
      } else {
        throw Exception(e.message);
      }
    }
  }
}