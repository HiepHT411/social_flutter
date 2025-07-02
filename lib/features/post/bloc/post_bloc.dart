import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_flutter/features/post/data/post_repository.dart';
import 'package:social_flutter/features/post/dtos/post.dart';

import '../../../dto/result_type.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostGetBloc extends Bloc<PostGetEvent, PostGetState> {

  final PostRepository postRepository;

  PostGetBloc(this.postRepository) : super(PostGetStateInitial()) {
    on<PostGetEventGetListRequest>(_onPostGetListReq);
    on<PostGetEventGetSingleDetailRequest>(_onPostGetSingleReq);
  }

  void _onPostGetListReq(PostGetEventGetListRequest event, Emitter<PostGetState> emit) async {
    emit(PostGetStateInProgress());
    await Future.delayed(const Duration(seconds: 1));
    log('Post bloc handle Get List Request');
    final result = await postRepository.getAllPost();
    return (switch (result) {
      Success() => {
        // if (result.data.isEmpty)
        //   emit(PostGetStateSuccess([]))
        // else
          emit(PostGetListStateSuccess(result.data))
      },
      Failure() => emit(PostGetStateFail(result.message))
    });
  }

  void _onPostGetSingleReq(PostGetEventGetSingleDetailRequest event, Emitter<PostGetState> emit) async {
    emit(PostGetStateInProgress());
    await Future.delayed(const Duration(seconds: 1));
    log('Post blog handle Get Single Request');
    final result = await postRepository.getPostDetail(event.id);
    return (switch (result) {
      Success() => {
        emit(PostGetSingleStateSuccess(result.data))
      },
      Failure() => emit(PostGetStateFail(result.message))
    });
  }

}