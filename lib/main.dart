import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MiMusicApp());
}

class MiMusicApp extends StatelessWidget {
  const MiMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiMusic',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeScreen(),
    );
  }
}