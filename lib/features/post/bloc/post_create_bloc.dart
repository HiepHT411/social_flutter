import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_flutter/features/post/data/post_repository.dart';

import '../../../dto/result_type.dart';

part 'post_create_event.dart';
part 'post_create_state.dart';

class PostCreateBloc extends Bloc<PostCreateEvent, PostCreateState> {
  final PostRepository postRepository;

  PostCreateBloc(this.postRepository) : super(PostCreateStateInitial()) {
    on<PostCreateEventStarted>(_onPostCreateStarted);
    on<PostCreateEventRetryStarted>(_onPostCreateRetryStarted);
    on<PostCreateEventAbort>(_onPostCreateEventAbort);
  }
  
  void _onPostCreateStarted (PostCreateEventStarted event, Emitter<PostCreateState> emit) async {
    emit(PostCreateStateInProgress(
      title: event.title,
      content: event.content
    ));
    await Future.delayed(const Duration(seconds: 2));
    log('Post blog handle Get List Request');
    final result = await postRepository.createNewPost(title: event.title, content: event.content);
    return (switch (result) {
      Success() => {
        // if (result.data.isEmpty)
        //   emit(PostGetStateSuccess([]))
        // else
        emit(PostCreateStateSuccess(title: result.data.title, content: result.data.body))
      },
      Failure() => emit(PostCreateStateFailure(title: event.title, content: event.content, errorMessage: result.message))
    });

    emit(PostCreateStateSuccess(title: '', content: ''));

    // mock
    // emit(PostCreateStateFailure(title: event.title, content: event.content, errorMessage: 'Connection Timed Out'));
  }

  void _onPostCreateRetryStarted(PostCreateEventRetryStarted event, Emitter<PostCreateState> emit) async {
    emit(PostCreateStateInProgress(
        title: event.title,
        content: event.content
    ));
    await Future.delayed(const Duration(seconds: 2));
    emit(PostCreateStateSuccess(title: event.title, content: event.content));
  }

  void _onPostCreateEventAbort(PostCreateEventAbort event, Emitter<PostCreateState> emit) {
    emit(PostCreateStateAborted());
  }
}
