import 'package:flutter/material.dart';
import 'library_screen.dart';
import 'player_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('MiMusic - Главная'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Добро пожаловать в MiMusic!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 40),
            _buildNavigationButton(
              context,
              '🎵 Библиотека',
              const LibraryScreen(),
            ),
            const SizedBox(height: 20),
            _buildNavigationButton(
              context,
              '▶️ Плеер',
              const PlayerScreen(),
            ),
            const SizedBox(height: 20),
            _buildNavigationButton(
              context,
              '🔍 Поиск',
              const SearchScreen(),
            ),
            const SizedBox(height: 20),
            _buildNavigationButton(
              context,
              '👤 Профиль',
              const ProfileScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String text, Widget screen) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}