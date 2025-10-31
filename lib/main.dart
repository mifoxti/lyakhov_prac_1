import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';

void main() {
  runApp(const MiMusicApp());
}

class MiMusicApp extends StatelessWidget {
  const MiMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MiMusic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      routerConfig: appRouter,
    );
  }
}