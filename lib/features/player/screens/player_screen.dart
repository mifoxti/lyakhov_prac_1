import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/player_model.dart';
import '../widgets/player_table.dart';
import 'player_form_screen.dart';

class PlayerScreen extends StatelessWidget {
  final List<Track> tracks;
  final int currentIndex;
  final Track? currentTrack;
  final VoidCallback onNextTrack;
  final Function(int) onSelectTrack;
  final Function(Track) onAddTrack;
  final Function(int, Track) onEditTrack;
  final Function(int) onRemoveTrack;

  const PlayerScreen({
    super.key,
    required this.tracks,
    required this.currentIndex,
    required this.currentTrack,
    required this.onNextTrack,
    required this.onSelectTrack,
    required this.onAddTrack,
    required this.onEditTrack,
    required this.onRemoveTrack,
  });

  void _showAddForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: PlayerFormScreen(
          existingTrack: null,
          onSave: (track) {
            onAddTrack(track);
            Navigator.of(context).pop();
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showEditForm(BuildContext context, int index, Track track) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: PlayerFormScreen(
          existingTrack: track,
          onSave: (updatedTrack) {
            onEditTrack(index, updatedTrack);
            Navigator.of(context).pop();
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildCurrentTrackSection(),
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
              tracks: tracks,
              currentIndex: currentIndex,
              onEdit: (index) {
                final track = tracks[index];
                _showEditForm(context, index, track);
              },
              onDelete: onRemoveTrack,
              onSelect: onSelectTrack,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.pop(),
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
        onPressed: () => _showAddForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCurrentTrackSection() {
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
              imageUrl: currentTrack?.imageUrl ?? defaultImageUrl,
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
          currentTrack?.title ?? 'Нет треков',
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        const SizedBox(height: 10),
        Text(
          currentTrack?.artist ?? 'Добавьте треки',
          style: TextStyle(fontSize: 16, color: Colors.deepPurple[700]),
        ),
        const SizedBox(height: 5),
        Text(
          currentTrack == null ? '' : 'Длительность: ${currentTrack!.duration}',
          style: TextStyle(fontSize: 14, color: Colors.deepPurple[600]),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: tracks.isEmpty ? null : onNextTrack,
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