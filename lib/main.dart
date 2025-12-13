// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_router.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/theme_cubit.dart';
import 'cubit/bloc_observer.dart';
import 'cubit/service_locator.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  // Initialize sqflite for desktop platforms
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  setupLocator();
  Bloc.observer = AppBlocObserver();

  // Create cubits and load saved data
  final themeCubit = ThemeCubit();
  final authCubit = AuthCubit();

  await Future.wait([
    themeCubit.loadSavedTheme(),
    // AuthCubit инициализируется автоматически в конструкторе
  ]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => authCubit),
        BlocProvider(create: (context) => themeCubit),
      ],
      child: const MiMusicApp(),
    ),
  );
}

class MiMusicApp extends StatelessWidget {
  const MiMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp.router(
          title: 'MiMusic',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeState.materialThemeMode,
          routerConfig: appRouter,
        );
      },
    );
  }
}
