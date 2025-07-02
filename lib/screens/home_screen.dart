import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_flutter/config/router.dart';
import 'package:social_flutter/config/theme_ext.dart';
import 'package:social_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:social_flutter/features/post/bloc/post_bloc.dart';
import 'package:social_flutter/features/post/bloc/post_create_bloc.dart';
import 'package:social_flutter/features/post/data/post_repository.dart';

import '../features/post/dtos/post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  /* Optimistic UI updating.
    In case it takes so long to create a post. We shouldn't let user waiting in the post_create_screen.
    The solution is to instantiate PostCreateBloc outside HomePage and show the uploading status on screen
  * */

  final List<PostCreateBloc> _postCreateBlocs = [];

  late final PostGetBloc _postGetBloc;
  // late List<Post> posts = [];

  @override
  void initState() {
    loadAllPosts();
    super.initState();
  }

  Future loadAllPosts() async {
    _postGetBloc = PostGetBloc(context.read<PostRepository>());
    _postGetBloc.add(PostGetEventGetListRequest());
    log('Sent PostGetEventGetListRequest');
    // return posts;
  }

  void _handleLogout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutStarted());
  }

  void _handPostCreateButton(BuildContext context) {
    final bloc = PostCreateBloc(context.read<PostRepository>());
    _postCreateBlocs.add(bloc);
    bloc.stream.listen((state) {
      if (state is PostCreateStateSuccess || state is PostCreateStateAborted) {
        _postCreateBlocs.remove(bloc);
        bloc.close();
        log('PostCreateBloc at end state, removed');
        _postGetBloc.add(PostGetEventGetListRequest());
        log('Sent PostGetEventGetListRequest to reload page');
      }
    });
    context.push(RouteName.postCreate, extra: bloc);
  }

  void _handlePendingPostRetry(PostCreateBloc bloc) {
    final state = bloc.state as PostCreateStateFailure;
    bloc.add(PostCreateEventRetryStarted(title: state.title, content: state.content));
  }

  Widget _buildPendingPost(PostCreateStateInProgress state) {
    final pendingPost = Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: context.color.surface,
            borderRadius: BorderRadius.circular(12)
        ),
        child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(state.title, style: context.text.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
                    const SizedBox(height: 8,),
                    Text(state.content, style: context.text.bodyMedium,)
                  ]
              ),
              Positioned.fill(  // fill color all the stack
                  child: Container(
                      color: Colors.white70,
                      child: const Center(child: CircularProgressIndicator())
                  )
              )
            ]
        )
    );
    return pendingPost;
  }

  Widget _buildFailurePost(PostCreateBloc bloc) {
    final state = bloc.state as PostCreateStateFailure;

    final failurePost = Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: context.color.surface,
            borderRadius: BorderRadius.circular(12)
        ),
        child: Stack(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(state.title, style: context.text.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
                    const SizedBox(height: 8,),
                    Text(state.content, style: context.text.bodyMedium,)
                  ]
              ),
              Positioned.fill(  // fill color all the stack
                  child: Container(
                      color: Colors.white70,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                      [
                        Icon(Icons.error, color: context.color.error,),
                        const SizedBox(width: 4,),
                        Text(state.errorMessage, style: context.text.bodySmall!.copyWith(color: context.color.error),),
                        const SizedBox(width: 4,),
                        IconButton.filled(onPressed: () {_handlePendingPostRetry(bloc);}, icon: const Icon(Icons.refresh))
                      ]
                      )
                  )
              )
            ]
        )
    );
    return failurePost;
  }

  Widget _buildCreatedPost(PostGetListStateSuccess state) {
    final posts = state.list;

    if (posts.isEmpty) {
      return const Center(
        child: Text(
          'No posts created yet.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    final listView = ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final post = posts[index];
          return Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: context.color.surface,
                  borderRadius: BorderRadius.circular(12)),
              child: Stack(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        post.title,
                        style: context.text.bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        post.body,
                        style: context.text.bodyMedium,
                      )
                    ])
              ]));
        });
    return SizedBox(
      height: 400,
      child: listView,
    );
  }

  @override
    Widget build(BuildContext context) {

      final pendingPosts = _postCreateBlocs.map((bloc) {
        return BlocProvider.value(
            value: bloc,
            child: BlocBuilder<PostCreateBloc, PostCreateState>(
                builder: (context, state) {
                  return (state is PostCreateStateInProgress)
                      ? _buildPendingPost(state)
                      : (state is PostCreateStateFailure) ? _buildFailurePost(bloc) : const SizedBox();
                }
            ));
      });

      log('CreatePostBlocs size: ${_postCreateBlocs.length}');

      final newPostButton = FilledButton(
        style: FilledButton.styleFrom(
            elevation: 0, // do bong = 0
            backgroundColor: context.color.surface,
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
            padding: const EdgeInsets.all(24)
        ),
        onPressed: () {
          _handPostCreateButton(context);
        },
        child: Row(
            children: [
              Icon(Icons.edit, color: context.color.onSurface.withOpacity(0.6),),
              const SizedBox(width: 8,),
              Text('Create new post', style: context.text.bodyLarge!.copyWith(color: context.color.onSurface.withOpacity(0.6))),
            ]
        ),
      );

      final createdPosts = BlocProvider.value(
            value: _postGetBloc,
            child: BlocBuilder<PostGetBloc, PostGetState>(
                builder: (context, state) {
                  log('Receive state $state');
                  return (state is PostGetListStateSuccess)
                      ? _buildCreatedPost(state)
                      : const SizedBox();
                }
            ));

      Widget homeWidget = Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Text('Home Screen', style: context.text.bodyLarge!.copyWith(color: context.color.onSurface,))),
          const SizedBox(
            height: 8,
          ),
          newPostButton,
          const SizedBox(
            height: 8,
          ),
          ...pendingPosts,
          createdPosts,
          FilledButton(
              onPressed: () => _handleLogout(context),
              child: const Text('Logout'))
        ],
      ),
    ));

    homeWidget = BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthLogoutSuccess():
              context.read<AuthBloc>().add(AuthStarted());
              context.pushReplacement(RouteName.login);
              break;
            case AuthLogoutFailure(message: final msg):
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('Logout Failed'),
                  content: Text(msg),
                  backgroundColor: context.color.surface,
                );
              });
              break;
            default:
              break;
          }
        },
        child: homeWidget,
      );

      return homeWidget;
    }
  }
