part of 'post_bloc.dart';

class PostGetState {}

class PostGetStateInitial extends PostGetState {}

class PostGetStateInProgress extends PostGetState {}

class PostGetStateFail extends PostGetState {
  PostGetStateFail(this.message);

  final String message;
}

class PostGetListStateSuccess extends PostGetState {
  final List<Post> list;

  PostGetListStateSuccess(this.list);
}

class PostGetSingleStateSuccess extends PostGetState {
  final Post post;

  PostGetSingleStateSuccess(this.post);
}