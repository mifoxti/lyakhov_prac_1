import 'package:flutter/material.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  int _currentTrackIndex = 0;
  final List<Map<String, String>> _tracks = [
    {
      'title': 'Perfect Symphony',
      'artist': 'Ed Sheeran & Andrea Bocelli',
      'duration': '4:20'
    },
    {
      'title': 'Blinding Lights',
      'artist': 'The Weeknd',
      'duration': '3:22'
    },
    {
      'title': 'Shape of You',
      'artist': 'Ed Sheeran',
      'duration': '3:53'
    },
    {
      'title': 'Dance Monkey',
      'artist': 'Tones and I',
      'duration': '3:29'
    },
  ];

  final TextEditingController _trackTitleController = TextEditingController();
  final TextEditingController _trackArtistController = TextEditingController();
  final TextEditingController _trackDurationController = TextEditingController();
  final TextEditingController _editTrackTitleController = TextEditingController();
  final TextEditingController _editTrackArtistController = TextEditingController();
  final TextEditingController _editTrackDurationController = TextEditingController();

  void _nextTrack() {
    setState(() {
      _currentTrackIndex = (_currentTrackIndex + 1) % _tracks.length;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Переключено на: ${_tracks[_currentTrackIndex]['title']}'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _addTrack() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Добавить трек',
            style: TextStyle(color: Colors.deepPurple),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _trackTitleController,
                  decoration: const InputDecoration(
                    hintText: 'Название трека',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _trackArtistController,
                  decoration: const InputDecoration(
                    hintText: 'Исполнитель',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _trackDurationController,
                  decoration: const InputDecoration(
                    hintText: 'Длительность (например: 3:45)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearTrackControllers();
              },
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final title = _trackTitleController.text.trim();
                final artist = _trackArtistController.text.trim();
                final duration = _trackDurationController.text.trim();

                if (title.isNotEmpty && artist.isNotEmpty && duration.isNotEmpty) {
                  setState(() {
                    _tracks.add({
                      'title': title,
                      'artist': artist,
                      'duration': duration,
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Трек "$title" добавлен'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                  Navigator.of(context).pop();
                  _clearTrackControllers();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Добавить',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editTrack(int index) {
    _editTrackTitleController.text = _tracks[index]['title']!;
    _editTrackArtistController.text = _tracks[index]['artist']!;
    _editTrackDurationController.text = _tracks[index]['duration']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Редактировать трек',
            style: TextStyle(color: Colors.deepPurple),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _editTrackTitleController,
                  decoration: const InputDecoration(
                    hintText: 'Название трека',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _editTrackArtistController,
                  decoration: const InputDecoration(
                    hintText: 'Исполнитель',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _editTrackDurationController,
                  decoration: const InputDecoration(
                    hintText: 'Длительность',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearEditTrackControllers();
              },
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final title = _editTrackTitleController.text.trim();
                final artist = _editTrackArtistController.text.trim();
                final duration = _editTrackDurationController.text.trim();

                if (title.isNotEmpty && artist.isNotEmpty && duration.isNotEmpty) {
                  setState(() {
                    _tracks[index] = {
                      'title': title,
                      'artist': artist,
                      'duration': duration,
                    };
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Трек изменен на "$title"'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                  Navigator.of(context).pop();
                  _clearEditTrackControllers();
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

  void _removeTrack(int index) {
    final trackTitle = _tracks[index]['title']!;
    setState(() {
      _tracks.removeAt(index);
      if (_currentTrackIndex >= _tracks.length) {
        _currentTrackIndex = _tracks.isEmpty ? 0 : _tracks.length - 1;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Трек "$trackTitle" удален'),
        backgroundColor: Colors.deepPurple[300],
      ),
    );
  }

  void _clearTrackControllers() {
    _trackTitleController.clear();
    _trackArtistController.clear();
    _trackDurationController.clear();
  }

  void _clearEditTrackControllers() {
    _editTrackTitleController.clear();
    _editTrackArtistController.clear();
    _editTrackDurationController.clear();
  }

  @override
  void dispose() {
    _trackTitleController.dispose();
    _trackArtistController.dispose();
    _trackDurationController.dispose();
    _editTrackTitleController.dispose();
    _editTrackArtistController.dispose();
    _editTrackDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Сейчас играет'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Обложка альбома
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note,
                size: 80,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 30),

            // Информация о текущем треке
            Text(
              _tracks.isEmpty ? 'Нет треков' : _tracks[_currentTrackIndex]['title']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _tracks.isEmpty ? 'Добавьте треки' : _tracks[_currentTrackIndex]['artist']!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple[700],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _tracks.isEmpty ? '' : 'Длительность: ${_tracks[_currentTrackIndex]['duration']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.deepPurple[600],
              ),
            ),
            const SizedBox(height: 30),

            // Кнопка "Следующий трек"
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _tracks.isEmpty ? null : _nextTrack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Следующий трек',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Кнопка "Добавить трек"
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _addTrack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[200],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Добавить трек',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple[800],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Заголовок списка треков
            const Text(
              'Следующие треки:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 15),

            // Список треков с ListView.separated
            _tracks.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Треки отсутствуют',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tracks.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final track = _tracks[index];
                return ListTile(
                  leading: Icon(
                    Icons.music_note,
                    color: index == _currentTrackIndex
                        ? Colors.deepPurple
                        : Colors.deepPurple[300],
                  ),
                  title: Text(
                    track['title']!,
                    style: TextStyle(
                      fontWeight: index == _currentTrackIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: Colors.deepPurple,
                    ),
                  ),
                  subtitle: Text(
                    '${track['artist']!} • ${track['duration']!}',
                    style: TextStyle(
                      color: Colors.deepPurple[600],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _editTrack(index),
                        icon: const Icon(Icons.edit, color: Colors.deepPurple),
                        tooltip: 'Редактировать',
                      ),
                      IconButton(
                        onPressed: () => _removeTrack(index),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Удалить',
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _currentTrackIndex = index;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 30),

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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}