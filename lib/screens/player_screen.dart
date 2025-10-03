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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Сейчас играет'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              _tracks[_currentTrackIndex]['title']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _tracks[_currentTrackIndex]['artist']!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple[700],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Длительность: ${_tracks[_currentTrackIndex]['duration']}',
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
                onPressed: _nextTrack,
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

            // Кнопка "Вернуться на главный экран"
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[200],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Вернуться на главный экран',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}