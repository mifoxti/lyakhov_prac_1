import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Map<String, dynamic>> _playlists = [
    {'id': 1, 'name': 'Любимые треки', 'count': 125},
    {'id': 2, 'name': 'Топ 2025', 'count': 50},
    {'id': 3, 'name': 'Для релакса', 'count': 30},
    {'id': 4, 'name': 'Тренировка', 'count': 45},
    {'id': 5, 'name': 'Дорожные хиты', 'count': 60},
  ];

  int _nextId = 6;
  final TextEditingController _playlistNameController = TextEditingController();
  final TextEditingController _editPlaylistNameController = TextEditingController();

  void _addPlaylist() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Создать плейлист',
            style: TextStyle(color: Colors.deepPurple),
          ),
          content: TextField(
            controller: _playlistNameController,
            decoration: const InputDecoration(
              hintText: 'Введите название плейлиста',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _playlistNameController.clear();
              },
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final playlistName = _playlistNameController.text.trim();
                if (playlistName.isNotEmpty) {
                  setState(() {
                    _playlists.add({
                      'id': _nextId++,
                      'name': playlistName,
                      'count': 0,
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Плейлист "$playlistName" создан'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                  Navigator.of(context).pop();
                  _playlistNameController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Создать',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editPlaylist(int index) {
    _editPlaylistNameController.text = _playlists[index]['name'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Редактировать плейлист',
            style: TextStyle(color: Colors.deepPurple),
          ),
          content: TextField(
            controller: _editPlaylistNameController,
            decoration: const InputDecoration(
              hintText: 'Введите новое название',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editPlaylistNameController.clear();
              },
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = _editPlaylistNameController.text.trim();
                if (newName.isNotEmpty) {
                  setState(() {
                    _playlists[index]['name'] = newName;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Плейлист переименован в "$newName"'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                  Navigator.of(context).pop();
                  _editPlaylistNameController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Сохранить',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _removePlaylist(int index) {
    final playlistName = _playlists[index]['name'];
    setState(() {
      _playlists.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Плейлист "$playlistName" удален'),
        backgroundColor: Colors.deepPurple[300],
      ),
    );
  }

  @override
  void dispose() {
    _playlistNameController.dispose();
    _editPlaylistNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Моя библиотека'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Добавленная картинка сверху
          Container(
            margin: const EdgeInsets.all(20),
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: 'https://i.pinimg.com/736x/7a/05/e2/7a05e28ac2cc660b976f03a70f84dba4.jpg',
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
                      Icons.library_music,
                      size: 60,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Верхняя часть с информацией
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Текущее количество плейлистов
                Text(
                  'Количество плейлистов:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_playlists.length}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 30),

                // Кнопка "Добавить плейлист"
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _addPlaylist,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Добавить плейлист',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Список плейлистов
          Expanded(
            child: ListView.builder(
              itemCount: _playlists.length,
              itemBuilder: (context, index) {
                final playlist = _playlists[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.queue_music, color: Colors.deepPurple),
                    ),
                    title: Text(
                      playlist['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurple,
                      ),
                    ),
                    subtitle: Text('${playlist['count']} треков'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _editPlaylist(index),
                          icon: const Icon(Icons.edit, color: Colors.deepPurple),
                          tooltip: 'Редактировать',
                        ),
                        IconButton(
                          onPressed: () => _removePlaylist(index),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Удалить',
                        ),
                        const Icon(Icons.play_arrow, color: Colors.deepPurple),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Кнопка "Вернуться на главный экран"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[300],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Вернуться на главный экран',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple[900],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}