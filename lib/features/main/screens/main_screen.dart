// lib/features/main/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../cubit/auth_cubit.dart';
import '../cubit/main_cubit.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: const _MainScreenContent(),
    );
  }
}

class _MainScreenContent extends StatefulWidget {
  const _MainScreenContent();

  @override
  State<_MainScreenContent> createState() => _MainScreenContentState();
}

class _MainScreenContentState extends State<_MainScreenContent> {
  void _showEditSessionDialog(BuildContext context) {
    final cubit = context.read<MainCubit>();
    final currentState = cubit.state;

    final titleController = TextEditingController(text: currentState.currentTrackTitle);
    final artistController = TextEditingController(text: currentState.currentArtist);
    final participantsController = TextEditingController(text: currentState.participantsCount.toString());
    bool isShared = currentState.isSharedMode;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать сессию'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Трек'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: artistController,
                  decoration: const InputDecoration(labelText: 'Исполнитель'),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Совместный режим'),
                  value: isShared,
                  onChanged: (value) {
                    setState(() {
                      isShared = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                if (isShared)
                  TextField(
                    controller: participantsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Участников'),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final artist = artistController.text.trim();
                final participantsText = participantsController.text.trim();
                final participants = isShared && participantsText.isNotEmpty
                    ? int.tryParse(participantsText) ?? 1
                    : 1;

                if (title.isNotEmpty && artist.isNotEmpty) {
                  cubit.updateCurrentTrack(title, artist);
                  if (isShared != currentState.isSharedMode) {
                    cubit.toggleSharedMode();
                  }
                  if (isShared) {
                    cubit.updateParticipants(participants);
                  }
                }
                Navigator.of(context).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.deepPurple[50],
          appBar: AppBar(
            title: const Text('MiMusic - Главная'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                tooltip: 'Настройки',
                icon: const Icon(Icons.settings),
                onPressed: () {
                  context.push('/main/settings');
                },
              ),
              IconButton(
                tooltip: 'Выход',
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthCubit>().logout();
                  context.pushReplacement('/intro');
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Сейчас играет:\n${state.currentTrackTitle} — ${state.currentArtist}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                if (state.isSharedMode)
                  Text(
                    '👥 Совместное прослушивание (${state.participantsCount} участников)',
                    style: const TextStyle(color: Colors.deepPurple, fontSize: 16),
                  ),
                const SizedBox(height: 30),
                // 🔹 Кнопка редактирования сессии
                SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: () => _showEditSessionDialog(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.deepPurple),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Редактировать сессию',
                      style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildNavigationButton(context, '🎵 Библиотека', '/main/library'),
                const SizedBox(height: 20),
                _buildNavigationButton(context, '🎙️ Подкасты', '/main/podcasts'),
                const SizedBox(height: 20),
                _buildNavigationButton(context, '📻 Радио', '/main/radio'),
                const SizedBox(height: 20),
                _buildNavigationButton(context, '▶️ Плеер', '/main/player'),
                const SizedBox(height: 20),
                _buildNavigationButton(context, '🔍 Поиск', '/main/search'),
                const SizedBox(height: 20),
                _buildNavigationButton(context, '👤 Профиль', '/main/profile'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationButton(BuildContext context, String text, String route) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () => context.push(route),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
