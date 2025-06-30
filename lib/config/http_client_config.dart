
import 'package:dio/dio.dart';
// local web host: localhost
// local android host: 10.0.2.2
final dio = Dio(
  BaseOptions(baseUrl: 'http://10.0.2.2:3000/api', validateStatus: (status) => status != null,),
);