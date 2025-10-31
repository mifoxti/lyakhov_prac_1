import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            const SizedBox(height: 20),
            CachedNetworkImage(
              imageUrl: 'https://i.pinimg.com/736x/f9/63/6a/f9636a282f8d673219ddc29bdd742bd5.jpg',
              progressIndicatorBuilder: (context, url, progress) =>
              const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Center(
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildNavigationButton(
              context,
              '🎵 Библиотека',
              '/library',
            ),
            const SizedBox(height: 20),
            _buildNavigationButton(
              context,
              '▶️ Плеер',
              '/player',
            ),
            const SizedBox(height: 20),
            _buildNavigationButton(
              context,
              '🔍 Поиск',
              '/search',
            ),
            const SizedBox(height: 20),
            _buildNavigationButton(
              context,
              '👤 Профиль',
              '/profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String text, String route) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          context.push(route);
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