import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_flutter/config/router.dart';
import 'package:social_flutter/config/theme_ext.dart';
import 'package:social_flutter/features/auth/bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  final confirmPasswordController = TextEditingController(text: '');

  void _handleRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthRegisterStarted(
          username: usernameController.text,
          email: emailController.text,
          password: passwordController.text
      ));
    }
  }

  void _handleRetry(BuildContext context) {
    context.read<AuthBloc>().add(AuthStarted());
  }

  Widget _buildInitialRegisterWidget() {
    return AutofillGroup(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: usernameController,
                  autofillHints: const [AutofillHints.username],
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24,),
                TextFormField(
                  controller: emailController,
                  autofillHints: const [AutofillHints.username],
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: passwordController,
                  autofillHints: const [AutofillHints.newPassword],
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                  ),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: confirmPasswordController,
                  autofillHints: const [AutofillHints.newPassword],
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                  ),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter confirm password';
                    } else if (value != passwordController.text) {
                      return 'Password confirmation does not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    _handleRegister(context);
                  },
                  label: const Text('Sign Up'),
                  icon: const Icon(Icons.arrow_forward),
                ),
                const SizedBox(height: 24),
              ]
                  .animate(
                interval: 50.ms,
              )
                  .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 400.ms,
              )
                  .fadeIn(
                curve: Curves.easeInOutCubic,
                duration: 400.ms,
              ),
            )));
  }

  Widget _buildInProgressRegisterWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildFailureRegisterWidget(String msg) {
    return Column(
      children: [
        Text(
          msg,
          style: context.text.bodyLarge!.copyWith(
            color: context.color.error,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            _handleRetry(context);
          },
          label: const Text('Retry'),
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    var registerWidget = (switch (authState) {
      AuthAuthenticateUnauthenticated() => _buildInitialRegisterWidget(),
      AuthRegisterInProgress() => _buildInProgressRegisterWidget(),
      AuthRegisterSuccess() => Container(),
      AuthRegisterFailure(message: final msg) => _buildFailureRegisterWidget(msg),
      _ => Container()
    });

    registerWidget = BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterSuccess) {
            showDialog(context: context, builder: (context) =>
                AlertDialog(
                    content: const Text('Register confirmation mail was sent. Please activate your account'),
                    title: const Text('Signed up successfully'),
                    actions: [
                      FilledButton(onPressed: () {
                        context.go(RouteName.login);
                        context.read<AuthBloc>().add(
                            AuthLoginPrefilled(username: usernameController.text, password: passwordController.text));
                      }, child: const Text('Back to login page')),
                      FilledButton(onPressed: () {Navigator.pop(context);}, child: const Text('Close'))
                    ]
                )
            );

          }
        },
        child: registerWidget,
    );
    return Scaffold(body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create new account',
                style: context.text.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.color.onSurface),
              ),
              const SizedBox(
                height: 24,
              ),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 48),
                  decoration: BoxDecoration(
                    color: context.color.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: registerWidget,
                ),
              )
            ],
          ),
        )));
  }
}
