import 'package:flutter/material.dart';
import 'features/home/screens/home_screen.dart';
import 'features/player/state/player_container.dart';

void main() {
  runApp(const MiMusicApp());
}

class MiMusicApp extends StatelessWidget {
  const MiMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiMusic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeScreen(),
    );
  }
}
