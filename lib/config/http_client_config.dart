
import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(baseUrl: 'http://localhost:3000/api', validateStatus: (status) => status != null,),
);