import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _playlistCount = 5;
  final List<String> _playlistNames = [
    'Любимые треки',
    'Топ 2025',
    'Для релакса',
    'Тренировка',
    'Дорожные хиты',
    'Осенняя грусть',
    'Летний хит-парад',
    'Рабочий фокус',
    'Вечеринка',
    'Романтическое настроение'
  ];

  void _addPlaylist() {
    if (_playlistCount < 10) {
      setState(() {
        _playlistCount++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Добавлен плейлист: ${_playlistNames[_playlistCount-1]}'),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  }

  void _removePlaylist() {
    if (_playlistCount > 1) {
      setState(() {
        _playlistCount--;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Плейлист удален'),
          backgroundColor: Colors.deepPurple[300],
        ),
      );
    }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              '$_playlistCount',
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
            const SizedBox(height: 15),

            // Кнопка "Удалить плейлист"
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _removePlaylist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[200],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Удалить плейлист',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple[800],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Список плейлистов
            Expanded(
              child: ListView.builder(
                itemCount: _playlistCount,
                itemBuilder: (context, index) {
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
                        _playlistNames[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                        ),
                      ),
                      subtitle: Text('${index + 7} треков'),
                      trailing: const Icon(Icons.play_arrow, color: Colors.deepPurple),
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
      ),
    );
  }
}