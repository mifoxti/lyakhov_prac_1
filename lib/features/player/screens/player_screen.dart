import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/player_model.dart';
import '../widgets/player_table.dart';
import 'player_form_screen.dart';
import '../state/player_container.dart';

class PlayerScreen extends StatelessWidget {
  final PlayerController container;
  final VoidCallback onAddTap;

  const PlayerScreen({
    super.key,
    required this.container,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final player = container;

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
            _buildCurrentTrackSection(player),
            const SizedBox(height: 30),
            const Text(
              'Следующие треки:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 15),
            PlayerTable(
              tracks: player.tracks,
              currentIndex: player.currentIndex,
              onEdit: (index) {
                final track = player.tracks[index];
                container.showForm(track);
              },
              onDelete: player.removeTrack,
              onSelect: player.selectTrack,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[300],
                padding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: Text(
                'Вернуться на главный экран',
                style: TextStyle(fontSize: 16, color: Colors.deepPurple[900]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: onAddTap,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCurrentTrackSection(PlayerController player) {
    final track = player.currentTrack;
    // URL картинки по умолчанию
    final String defaultImageUrl = 'https://avatars.yandex.net/get-music-content/14369544/2cf8dc1c.a.35846952-2/300x300';

    return Column(
      children: [
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: track?.imageUrl ?? defaultImageUrl,
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
                    Icons.music_note,
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          track?.title ?? 'Нет треков',
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        const SizedBox(height: 10),
        Text(
          track?.artist ?? 'Добавьте треки',
          style: TextStyle(fontSize: 16, color: Colors.deepPurple[700]),
        ),
        const SizedBox(height: 5),
        Text(
          track == null ? '' : 'Длительность: ${track.duration}',
          style: TextStyle(fontSize: 14, color: Colors.deepPurple[600]),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: track == null ? null : player.nextTrack,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          ),
          child: const Text('Следующий трек',
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ],
    );
  }
}