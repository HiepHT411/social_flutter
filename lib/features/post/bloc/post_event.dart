part of 'post_bloc.dart';

class PostGetEvent {}

class PostGetEventGetListRequest extends PostGetEvent {}

class PostGetEventGetSingleDetailRequest extends PostGetEvent {
  final int id;

  PostGetEventGetSingleDetailRequest(this.id);
}

