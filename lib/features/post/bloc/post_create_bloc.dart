import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_create_event.dart';
part 'post_create_state.dart';

class PostCreateBloc extends Bloc<PostCreateEvent, PostCreateState> {
  PostCreateBloc() : super(PostCreateStateInitial()) {
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
    // emit(PostCreateStateSuccess());

    // moc
    emit(PostCreateStateFailure(title: event.title, content: event.content, errorMessage: 'Connection Timed Out'));
  }

  void _onPostCreateRetryStarted(PostCreateEventRetryStarted event, Emitter<PostCreateState> emit) async {
    emit(PostCreateStateInProgress(
        title: event.title,
        content: event.content
    ));
    await Future.delayed(const Duration(seconds: 2));
    emit(PostCreateStateSuccess());
  }

  void _onPostCreateEventAbort(PostCreateEventAbort event, Emitter<PostCreateState> emit) {
    emit(PostCreateStateAborted());
  }
}
