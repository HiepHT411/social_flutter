import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:social_flutter/config/http_client_config.dart';
import 'package:social_flutter/dto/response_wrapper.dart';
import 'package:social_flutter/features/post/dtos/create_post_req.dart';
import 'package:social_flutter/features/post/dtos/post.dart';

class PostApiClient {

  final Dio dio;

  PostApiClient(this.dio);

  Future<ResponseMetaData> createPost(CreatePostRequest createPost, String token) async {
    try {
      final response = await dio.post('/post', data: createPost.toJson(), options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },));
      log('Create post response $response');
      return ResponseMetaData.fromJson(response.data!, Post.fromJson);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<ResponseMetaData> getAllPost(String token) async {
    try {
      final response = await dio.get('/post', options: Options(
      headers: {
      'Authorization': 'Bearer $token',
      },));
      log('Get all post response $response');
      return ResponseMetaData.fromJsonList(response.data!, Post.fromJson);
    } on DioException catch (e) {
        throw Exception(e.message);
    }
  }

  Future<ResponseMetaData> getSinglePost(int id) async {
    try {
      final response = await dio.get('/post/$id');
      log('Get single post response $response');
      return ResponseMetaData.fromJson(response.data!, Post.fromJson);
    } on DioException catch (e) {
      if (e.response == null) {
        throw Exception(e.message);
      } else {
        throw Exception(e.message);
      }
    }
  }

}