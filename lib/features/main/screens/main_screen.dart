// lib/features/main/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../cubit/auth_cubit.dart';
import '../../../theme/app_theme.dart';
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final titleController = TextEditingController(text: currentState.currentTrackTitle);
    final artistController = TextEditingController(text: currentState.currentArtist);
    final participantsController = TextEditingController(text: currentState.participantsCount.toString());
    bool isShared = currentState.isSharedMode;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colors.surface,
          title: Text('Редактировать сессию', style: TextStyle(color: colors.onSurface)),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Трек',
                    labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.7)),
                  ),
                  style: TextStyle(color: colors.onSurface),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: artistController,
                  decoration: InputDecoration(
                    labelText: 'Исполнитель',
                    labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.7)),
                  ),
                  style: TextStyle(color: colors.onSurface),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: Text('Совместный режим', style: TextStyle(color: colors.onSurface)),
                  value: isShared,
                  onChanged: (value) {
                    setState(() {
                      isShared = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  activeColor: colors.primary,
                ),
                if (isShared)
                  TextField(
                    controller: participantsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Участников',
                      labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.7)),
                    ),
                    style: TextStyle(color: colors.onSurface),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Отмена', style: TextStyle(color: colors.primary)),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
              ),
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
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final isDarkMode = AppTheme.isDarkMode(context);
        
        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            title: const Text('MiMusic - Главная'),
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            actions: [
              IconButton(
                tooltip: 'Настройки',
                icon: Icon(Icons.settings, color: colors.onPrimary),
                onPressed: () {
                  context.push('/main/settings');
                },
              ),
              IconButton(
                tooltip: 'Выход',
                icon: Icon(Icons.logout, color: colors.onPrimary),
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                if (state.isSharedMode)
                  Text(
                    '👥 Совместное прослушивание (${state.participantsCount} участников)',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(height: 30),
                // 🔹 Кнопка редактирования сессии
                SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: () => _showEditSessionDialog(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: colors.primary,
                    ),
                    child: Text(
                      'Редактировать сессию',
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildNavigationButton(context, '🎵 Библиотека', '/main/library', colors),
                const SizedBox(height: 20),
                _buildNavigationButton(context, '🎙️ Подкасты', '/main/podcasts', colors),
                const SizedBox(height: 20),
                _buildNavigationButton(context, '📻 Радио', '/main/radio', colors),
                const SizedBox(height: 20),
                _buildNavigationButton(context, '▶️ Плеер', '/main/player', colors),
                const SizedBox(height: 20),
                _buildNavigationButton(context, '🔍 Онлайн поиск', '/main/online-search', colors),
                const SizedBox(height: 20),
                _buildNavigationButton(context, '👥 Друзья', '/main/friends', colors),
                const SizedBox(height: 20),
                _buildNavigationButton(context, '👤 Профиль', '/main/profile', colors),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationButton(BuildContext context, String text, String route, ColorScheme colors) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () => context.push(route),
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: colors.onPrimary),
        ),
      ),
    );
  }
}
