import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_flutter/config/http_client_config.dart';
import 'package:social_flutter/config/router.dart';
import 'package:social_flutter/config/theme.dart';
import 'package:social_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:social_flutter/features/auth/data/auth_api_client.dart';
import 'package:social_flutter/features/auth/data/auth_local_data_source.dart';
import 'package:social_flutter/features/auth/data/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // make sure flutter framework started completely
  final sharedPrefs = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPrefs: sharedPrefs));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.sharedPrefs});

  final SharedPreferences sharedPrefs;

  @override
  Widget build(BuildContext context) {
    // All screens need to have the same auth state => wrap by BlocProvider
    return RepositoryProvider(
        create: (context) => AuthRepository(
            authApiClient: AuthApiClient(dio),
            authLocalDataSource: AuthLocalDataSource(sharedPrefs)),
        child: BlocProvider(
            create: (context) => AuthBloc(context.read<AuthRepository>()),
            child: const AppContent()
        ));
  }
}

class AppContent extends StatefulWidget {
  const AppContent({super.key});

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthAuthenticateStarted());
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is AuthInitial) {
      return Container();
    }
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routerConfig: router,
    );

  }
}


