import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_flutter/config/constants.dart';

// local web host: localhost
// local android host: 10.0.2.2
String apiUrl = "http://localhost:3000/api";

final dio = Dio(
  BaseOptions(
    connectTimeout: const Duration(milliseconds: 30000),
    receiveTimeout: const Duration(milliseconds: 30000),
    baseUrl: apiUrl,
    responseType: ResponseType.json,
    contentType: ContentType.json.toString(),
    validateStatus: (status) => status != null,),
);

void setupInterceptors() {
  dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options,
            RequestInterceptorHandler handler) async {
          final accessToken = await getToken();

          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          return handler.next(error);
        },
      )
  );
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(Constants.accessTokenKey);
}