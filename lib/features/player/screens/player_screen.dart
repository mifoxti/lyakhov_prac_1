import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/track.dart';
import '../cubit/player_cubit.dart';
import '../widgets/player_table.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late PlayerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PlayerCubit();
    // Инициализируем начальные треки
    _initializeTracks();
  }

  void _initializeTracks() {
    final initialTracks = [
      Track(
        id: 1,
        title: 'Perfect Symphony',
        artist: 'Ed Sheeran & Andrea Bocelli',
        duration: '4:20',
      ),
      Track(
        id: 2,
        title: 'Blinding Lights',
        artist: 'The Weeknd',
        duration: '3:22',
      ),
      Track(
        id: 3,
        title: 'Shape of You',
        artist: 'Ed Sheeran',
        duration: '3:53',
      ),
    ];
    _cubit.initializeTracks(initialTracks);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final artistController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить трек'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Название трека'),
                ),
                TextField(
                  controller: artistController,
                  decoration: const InputDecoration(labelText: 'Исполнитель'),
                ),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: 'Длительность'),
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
                final duration = durationController.text.trim();

                if (title.isNotEmpty && artist.isNotEmpty) {
                  final newTrack = Track(
                    id: DateTime.now().microsecondsSinceEpoch,
                    title: title,
                    artist: artist,
                    duration: duration.isNotEmpty ? duration : '3:00',
                  );
                  _cubit.addTrack(newTrack);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Трек "$title" добавлен'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, int index, Track currentTrack) {
    final titleController = TextEditingController(text: currentTrack.title);
    final artistController = TextEditingController(text: currentTrack.artist);
    final durationController = TextEditingController(text: currentTrack.duration);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать трек'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Название трека'),
                ),
                TextField(
                  controller: artistController,
                  decoration: const InputDecoration(labelText: 'Исполнитель'),
                ),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: 'Длительность'),
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
                final newTrack = Track(
                  id: currentTrack.id,
                  title: titleController.text.trim(),
                  artist: artistController.text.trim(),
                  duration: durationController.text.trim(),
                  imageUrl: currentTrack.imageUrl,
                );
                if (newTrack.title.isNotEmpty && newTrack.artist.isNotEmpty) {
                  _cubit.updateTrack(currentTrack.id, newTrack);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Трек "${newTrack.title}" обновлен'),
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

  void _removeTrack(BuildContext context, int index, String trackName) {
    final track = _cubit.state.tracks[index];
    _cubit.removeTrack(track.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Трек "$trackName" удален'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.deepPurple[300],
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () => _cubit.undoRemove(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
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
        body: BlocBuilder<PlayerCubit, PlayerState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildCurrentTrackSection(state),
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
                  Text(
                    '${state.nextTracksCount} треков в очереди',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                  const SizedBox(height: 15),
                  PlayerTable(
                    tracks: state.tracks,
                    currentIndex: state.currentIndex,
                    onEdit: (index) => _showEditDialog(context, index, state.tracks[index]),
                    onDelete: (index) => _removeTrack(context, index, state.tracks[index].title),
                    onSelect: (index) => _cubit.selectTrack(index),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () => _showAddDialog(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCurrentTrackSection(PlayerState state) {
    final String defaultImageUrl =
        'https://avatars.yandex.net/get-music-content/14369544/2cf8dc1c.a.35846952-2/300x300';

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
              imageUrl: state.currentTrack?.imageUrl ?? defaultImageUrl,
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
          state.currentTrack?.title ?? 'Нет треков',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            final artistName = state.currentTrack?.artist;
            if (artistName != null && artistName.isNotEmpty) {
              context.push('/main/artist/$artistName');
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.currentTrack?.artist ?? 'Добавьте треки',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurple[700],
                  decoration: state.currentTrack != null ? TextDecoration.underline : TextDecoration.none,
                  decorationColor: Colors.deepPurple[700],
                ),
              ),
              if (state.currentTrack != null) ...[
                const SizedBox(width: 5),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Colors.deepPurple[700],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          state.currentTrack == null ? '' : 'Длительность: ${state.currentTrack!.duration}',
          style: TextStyle(fontSize: 14, color: Colors.deepPurple[600]),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: state.tracks.isEmpty ? null : () => _cubit.nextTrack(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text(
                'Следующий трек',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => context.push('/main/friends'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text(
                'Совместное прослушивание',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
