import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_flutter/config/router.dart';
import 'package:social_flutter/config/theme_ext.dart';
import 'package:social_flutter/features/auth/bloc/auth_bloc.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _authState = context.read<AuthBloc>().state; // assign value in somewhere in the future
  late final usernameController = TextEditingController(text: _authState is AuthLoginInitial ?  (_authState).username : '');
  late final passwordController = TextEditingController(text: _authState is AuthLoginInitial ?  (_authState).password : '');

  void _handleLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
          AuthLoginStarted(usernameController.text, passwordController.text));
    }
  }

  void _handleRetry(BuildContext context) {
    context.read<AuthBloc>().add(AuthStarted());
  }

  Widget _buildInitialLoginWidget() {
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
                FilledButton.icon(
                  onPressed: () {
                    _handleLogin(context);
                  },
                  label: const Text('Login'),
                  icon: const Icon(Icons.arrow_forward),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    context.go(RouteName.register);
                  },
                  child: const Text('Don\'t have an account? Register'),
                ),
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

  Widget _buildInProgressLoginWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildFailureLoginWidget(String message) {
    return Column(
      children: [
        Text(
          message,
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
    final authState = context.watch<AuthBloc>().state; // alternative for BlocBuilder, listen to the states

    var loginWidget = (switch (authState) {
      AuthAuthenticateUnauthenticated() => _buildInitialLoginWidget(),
      AuthLoginInitial() => _buildInitialLoginWidget(),
      AuthLoginInProgress() => _buildInProgressLoginWidget(),
      AuthLoginFailure(message: final msg) => _buildFailureLoginWidget(msg),
      AuthLogInSuccess() => Container(),
      _ => Container(),
    });

    loginWidget = BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthLogInSuccess():
              context.read<AuthBloc>().add(AuthAuthenticateStarted());
              break;
            case AuthAuthenticateSuccess():
              context.go(RouteName.home);
              break;
            default:
          }
        },
      child: loginWidget,
    );


    return Scaffold(
        body: SingleChildScrollView(
            child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Login',
            style: context.text.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold, color: context.color.onSurface),
          ),
          const SizedBox(
            height: 24,
          ),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              decoration: BoxDecoration(
                color: context.color.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: loginWidget,
            ),
          )
        ],
      ),
    )));
  }
}
