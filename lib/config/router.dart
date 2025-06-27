import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:social_flutter/screens/home_screen.dart';
import 'package:social_flutter/screens/login_screen.dart';
import 'package:social_flutter/screens/register_screen.dart';

class RouteName {
  static const String home = '/';
  static const String login = '/login';
  static const String postDetail = '/post/:id';
  static const String profile = '/profile';
  static const String register = '/register';

  static const publicRoutes = [
    login,
    register,
  ];
}

final router = GoRouter(
  // run when try to redirect to another route
  // return null means user can access to the next route, else redirect to route login
  redirect: (context, state) {
    if (RouteName.publicRoutes.contains(state.fullPath)) {
      return null;
    }
    if (context.read<AuthBloc>().state is AuthAuthenticateSuccess) { // check if current sate is AuthAuthenticateSuccess
      return null;
    }

    return RouteName.login;
  },
  routes: [
    GoRoute(
      path: RouteName.home,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: RouteName.login,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: RouteName.postDetail,
      builder: (context, state) => LoginScreen(
        // id: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: RouteName.profile,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: RouteName.register,
      builder: (context, state) => RegisterScreen(),
    ),
  ],
);