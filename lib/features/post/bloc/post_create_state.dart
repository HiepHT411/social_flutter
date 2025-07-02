part of 'post_create_bloc.dart';

sealed class PostCreateState {}

class PostCreateStateInitial extends PostCreateState {}

class PostCreateStateInProgress extends PostCreateState {
  final String title;
  final String content;

  PostCreateStateInProgress({required this.title, required this.content});
}

class PostCreateStateSuccess extends PostCreateState {
  final String title;
  final String content;

  PostCreateStateSuccess({required this.title, required this.content});
}

class PostCreateStateFailure extends PostCreateState {
  final String title;
  final String content;
  final String errorMessage;

  PostCreateStateFailure({required this.title, required this.content, required this.errorMessage});
}

class PostCreateStateAborted extends PostCreateState {}
