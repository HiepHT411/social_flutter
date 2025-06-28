part of 'post_create_bloc.dart';

class PostCreateEvent {}

class PostCreateEventStarted extends PostCreateEvent {
  final String title;
  final String content;

  PostCreateEventStarted({required this.title, required this.content});
}

class PostCreateEventRetryStarted extends PostCreateEvent {
  final String title;
  final String content;

  PostCreateEventRetryStarted({required this.title, required this.content});
}

class PostCreateEventAbort extends PostCreateEvent {}