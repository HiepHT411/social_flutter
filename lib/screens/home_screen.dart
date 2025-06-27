import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_flutter/config/router.dart';
import 'package:social_flutter/config/theme_ext.dart';
import 'package:social_flutter/features/auth/bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _handleLogout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutStarted());
  }

  @override
  Widget build(BuildContext context) {
    Widget homeWidget = Scaffold(
      body: Column(
        children: [
          const Text('Home Screen'),

          FilledButton(
              onPressed: () => _handleLogout(context),
              child: const Text('Logout'))
        ],
      ),
    );
    
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
