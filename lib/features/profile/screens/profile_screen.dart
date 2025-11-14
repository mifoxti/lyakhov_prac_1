import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileCubit _cubit;
  final List<String> _statuses = [
    'Онлайн',
    'Не беспокоить',
    'Оффлайн',
    'В пути',
    'В работе'
  ];

  @override
  void initState() {
    super.initState();
    _cubit = ProfileCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _changeStatus() {
    final currentIndex = _statuses.indexOf(_cubit.state.status);
    final nextIndex = (currentIndex + 1) % _statuses.length;
    _cubit.changeStatus(_statuses[nextIndex]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Статус изменен на: ${_statuses[nextIndex]}'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _showAddPlaylistDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Новый плейлист'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Название плейлиста'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  _cubit.addPlaylist(name);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Плейлист "$name" создан'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Создать'),
            ),
          ],
        );
      },
    );
  }

  void _showEditPlaylistDialog(BuildContext context, int index, String currentName) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать плейлист'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Новое название'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty && name != currentName) {
                  _cubit.updatePlaylist(index, name);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Плейлист переименован в "$name"'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
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

  void _removePlaylist(BuildContext context, int index, String name) {
    _cubit.removePlaylist(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Плейлист "$name" удален'),
        backgroundColor: Colors.deepPurple[300],
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            // В реальном приложении нужно было бы добавить метод undoRemove
          },
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final controller = TextEditingController(text: _cubit.state.profileImageUrl);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Сменить аватар'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'URL изображения'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final url = controller.text.trim();
                if (url.isNotEmpty) {
                  _cubit.updateProfileImage(url);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Аватар обновлен'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
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
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: AppBar(
          title: const Text('Мой профиль'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => _showEditProfileDialog(context),
                          child: _buildProfileAvatar(state.profileImageUrl),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Тимофей Ляхов',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          state.status,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Премиум статус
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'PREMIUM',
                            style: TextStyle(
                              color: Colors.amber[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text(
                          'Музыкальная статистика:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem('${state.playlistCount}', 'Плейлистов'),
                            _buildStatItem('${state.totalPlaytimeMinutes}', 'Минут прослушано'),
                            _buildStatItem('128', 'Всего треков'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem('28', 'Часов'),
                            _buildStatItem('15', 'Исполнителей'),
                            _buildStatItem('8', 'Альбомов'),
                          ],
                        ),
                        const SizedBox(height: 40),

                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _changeStatus,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              'Сменить статус',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Мои плейлисты:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _showAddPlaylistDialog(context),
                                icon: const Icon(Icons.add_circle, color: Colors.deepPurple, size: 30),
                                tooltip: 'Добавить плейлист',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: state.playlists
                              .asMap()
                              .entries
                              .map(
                                (entry) => Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.queue_music, color: Colors.deepPurple),
                                  title: Text(entry.value['name']),
                                  subtitle: Text('${entry.value['count']} треков'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.deepPurple),
                                        onPressed: () => _showEditPlaylistDialog(context, entry.key, entry.value['name']),
                                        tooltip: 'Редактировать',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _removePlaylist(context, entry.key, entry.value['name']),
                                        tooltip: 'Удалить',
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(color: Colors.grey, height: 1),
                              ],
                            ),
                          )
                              .toList(),
                        ),
                        const SizedBox(height: 30),

                        const Text(
                          'Настройки аккаунта:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildSettingItem('Редактировать профиль', Icons.edit, onTap: () => _showEditProfileDialog(context)),
                        _buildSettingItem('Настройки приватности', Icons.security),
                        _buildSettingItem('Качество звука', Icons.volume_up),
                        _buildSettingItem('Уведомления', Icons.notifications),
                        _buildSettingItem('Премиум-доступ', Icons.stars),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(String imageUrl) {
    return Container(
      width: 140,
      height: 140,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.deepPurple, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(70),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(62),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(59),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, progress) => Container(
              color: Colors.deepPurple[100],
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.deepPurple[100],
              child: const Center(
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.deepPurple[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSettingItem(String text, IconData icon, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(text, style: const TextStyle(color: Colors.deepPurple)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepPurple),
        onTap: onTap,
      ),
    );
  }
}