import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/track.dart';
import '../screens/player_screen.dart';
import '../cubit/player_cubit.dart';

class PlayerContainer extends StatefulWidget {
  final String? initialTrack;
  final String? initialArtist;

  const PlayerContainer({super.key, this.initialTrack, this.initialArtist});

  @override
  State<PlayerContainer> createState() => _PlayerContainerState();

  static Widget withScreen({String? track, String? artist}) =>
      PlayerContainer(initialTrack: track, initialArtist: artist);
}

class _PlayerContainerState extends State<PlayerContainer> {
  late PlayerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PlayerCubit();
    _initializeTracks();
  }

  void _initializeTracks() {
    final initialTracks = <Track>[];

    // Если передан трек от друга, добавляем его первым
    if (widget.initialTrack != null && widget.initialArtist != null) {
      initialTracks.add(
        Track(
          id: DateTime.now().microsecondsSinceEpoch,
          title: widget.initialTrack!,
          artist: widget.initialArtist!,
          duration: '3:30',
        ),
      );
    }

    // Добавляем стандартные треки
    initialTracks.addAll([
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
    ]);

    _cubit.initializeTracks(initialTracks);

    // Если трек от друга был добавлен, начинаем его воспроизведение
    if (widget.initialTrack != null && widget.initialArtist != null) {
      _cubit.selectTrack(0);
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: PlayerScreen(),
    );
  }
}
