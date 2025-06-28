import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_flutter/config/router.dart';
import 'package:social_flutter/config/theme_ext.dart';
import 'package:social_flutter/features/post/bloc/post_create_bloc.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final titleEditController = TextEditingController();
  final contentEditController = TextEditingController();

  void _handleSubmit(BuildContext context) {
    context.read<PostCreateBloc>().add(PostCreateEventStarted(
        title: titleEditController.text, content: contentEditController.text));
    context.pop();
  }

  @override
  void dispose() {
    titleEditController.dispose();
    contentEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleField = TextFormField(
      controller: titleEditController,
      decoration: InputDecoration(
        fillColor: context.color.surface,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        hintText: 'Enter the title',
      ),
      style: context.text.bodyLarge!
          .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter post title';
        }
        return null;
      },
    );

    final textField = TextFormField(
      controller: contentEditController,
      maxLines: 20,
      decoration: InputDecoration(
        fillColor: context.color.surface,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        hintText: 'Enter the content',
      ),
      style: context.text.bodyLarge!
          .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter post content';
        }
        return null;
      },
    );

    final submitButton = Padding(
        padding: const EdgeInsets.all(24),
        child: FilledButton(
            style: FilledButton.styleFrom(
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                textStyle: context.text.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            onPressed: () {
              _handleSubmit(context);
            },
            child: const Text('Submit')));

    final postCreateWidget = Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () {
            context.read<PostCreateBloc>().add(PostCreateEventAbort());
            Navigator.pop(context);
          }),
          title: const Text('Create new post'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
              child: Column(
            children: [
              titleField,
              const SizedBox(height: 16),
              textField,
              const SizedBox(height: 16),
              submitButton
            ],
          )),
        ));

    return postCreateWidget;
  }
}
