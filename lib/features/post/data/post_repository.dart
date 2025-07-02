import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_flutter/config/http_client_config.dart';
import 'package:social_flutter/dto/response_wrapper.dart';
import 'package:social_flutter/dto/result_type.dart';
import 'package:social_flutter/features/auth/data/auth_local_data_source.dart';
import 'package:social_flutter/features/post/data/post_api_client.dart';
import 'package:social_flutter/features/post/dtos/create_post_req.dart';

import '../dtos/post.dart';

class PostRepository {
  final PostApiClient postApiClient;

  PostRepository({required this.postApiClient});

  Future<Result<List<Post>>> getAllPost() async {
    try {
      log("Start getting all posts");
      String? token = await getToken();
      final responseMetaData = await postApiClient.getAllPost(token!);

      if (responseMetaData.meta.code != 200) {
        return Failure(responseMetaData.meta.message);
      }
      return Success((responseMetaData.data as List)
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList());
    } catch (e) {
      log('Exception occurred: $e');
      return Failure(e.toString());
    }
  }

  Future<Result<Post>> getPostDetail(int id) async {
    try {
      log("Start getting post detail by id: $id");

      final responseMetaData = await postApiClient.getSinglePost(id);

      if (responseMetaData.meta.code != 200) {
        return Failure(responseMetaData.meta.message);
      }

      return Success(Post.fromJson(responseMetaData.data as Map<String, dynamic>));
    } catch (e) {
      log('Exception occurred: $e');
      return Failure(e.toString());
    }
  }

  Future<Result<Post>> createNewPost({required String title, required String content})  async {
    try {
      log("Start create new post");
      final sf = await SharedPreferences.getInstance();
      AuthLocalDataSource authLocalDataSource = AuthLocalDataSource(sf);
      String? token = await authLocalDataSource.getAccessToken();
      ResponseMetaData responseMetaData = await postApiClient.createPost(CreatePostRequest(title, content), token!);
      if (responseMetaData.meta.code != 200) {
        return Failure(responseMetaData.meta.message);
      }
      return Success(responseMetaData.data);
    } catch (e) {
      log('Exception occurred: $e');
      return Failure('$e');
    }
  }
}