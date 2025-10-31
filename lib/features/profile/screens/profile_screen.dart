import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentStatusIndex = 0;
  final List<String> _statuses = [
    'Онлайн',
    'Не беспокоить',
    'Оффлайн',
    'В пути',
    'В работе'
  ];

  final List<Map<String, dynamic>> _playlists = [
    {'id': 1, 'name': 'Любимые треки', 'count': 125},
    {'id': 2, 'name': 'Топ 2024', 'count': 50},
    {'id': 3, 'name': 'Для релакса', 'count': 30},
    {'id': 4, 'name': 'Тренировка', 'count': 45},
    {'id': 5, 'name': 'Дорожные хиты', 'count': 60},
  ];

  int _nextId = 6;

  final String _profileImageUrl = 'https://i.pinimg.com/736x/0a/ba/41/0aba4155e6ae9d116d25bf83c4eac798.jpg';

  void _changeStatus() {
    setState(() {
      _currentStatusIndex = (_currentStatusIndex + 1) % _statuses.length;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Статус изменен на: ${_statuses[_currentStatusIndex]}'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _addNewPlaylist() async {
    final Map<String, dynamic>? newPlaylist = await context.push(
      '/library/playlist-form',
    );

    if (newPlaylist != null) {
      setState(() {
        _playlists.add({
          'id': _nextId++,
          'name': newPlaylist['name'],
          'count': 0,
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Плейлист "${newPlaylist['name']}" создан'),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  }

  void _removePlaylist(Map<String, dynamic> playlist) {
    setState(() {
      _playlists.remove(playlist);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Плейлист "${playlist['name']}" удален'),
        backgroundColor: Colors.deepPurple[300],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
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
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(59),
                        child: CachedNetworkImage(
                          imageUrl: _profileImageUrl,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Container(
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
                    _statuses[_currentStatusIndex],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),
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
                      _buildStatItem('${_playlists.length}', 'Плейлистов'),
                      _buildStatItem('25', 'Найдено треков'),
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
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
                          onPressed: _addNewPlaylist,
                          icon: const Icon(Icons.add_circle, color: Colors.deepPurple, size: 30),
                          tooltip: 'Добавить плейлист',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: _playlists
                        .map(
                          (playlist) => Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.queue_music, color: Colors.deepPurple),
                            title: Text(playlist['name']),
                            subtitle: Text('${playlist['count']} треков'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removePlaylist(playlist),
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                            height: 1,
                          ),
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
                  _buildSettingItem('Редактировать профиль', Icons.edit),
                  _buildSettingItem('Настройки приватности', Icons.security),
                  _buildSettingItem('Качество звука', Icons.volume_up),
                  _buildSettingItem('Уведомления', Icons.notifications),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildSettingItem(String text, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(
          text,
          style: const TextStyle(color: Colors.deepPurple),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepPurple),
        onTap: () {},
      ),
    );
  }
}