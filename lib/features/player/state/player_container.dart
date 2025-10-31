import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/player_model.dart';
import '../screens/player_screen.dart';

class PlayerContainer extends StatefulWidget {
  const PlayerContainer({super.key});

  @override
  State<PlayerContainer> createState() => _PlayerContainerState();

  static Widget withScreen() => const PlayerContainer();
}

class _PlayerContainerState extends State<PlayerContainer> {
  final List<Track> _tracks = [
    Track(
        id: 1,
        title: 'Perfect Symphony',
        artist: 'Ed Sheeran & Andrea Bocelli',
        duration: '4:20'),
    Track(id: 2, title: 'Blinding Lights', artist: 'The Weeknd', duration: '3:22'),
    Track(id: 3, title: 'Shape of You', artist: 'Ed Sheeran', duration: '3:53'),
  ];

  int _currentTrackIndex = 0;

  Track? _recentlyDeleted;
  int? _recentlyDeletedIndex;

  List<Track> get tracks => List.unmodifiable(_tracks);

  int get currentIndex => _currentTrackIndex;

  Track? get currentTrack => _tracks.isEmpty ? null : _tracks[_currentTrackIndex];

  void nextTrack() {
    if (_tracks.isEmpty) return;
    setState(() {
      _currentTrackIndex = (_currentTrackIndex + 1) % _tracks.length;
    });
  }

  void selectTrack(int index) {
    if (index >= 0 && index < _tracks.length) {
      setState(() {
        _currentTrackIndex = index;
      });
    }
  }

  void addTrack(Track track) {
    setState(() {
      _tracks.add(track);
    });
  }

  void editTrack(int index, Track updated) {
    if (index >= 0 && index < _tracks.length) {
      setState(() {
        _tracks[index] = updated;
      });
    }
  }

  void removeTrack(int index) {
    if (index >= 0 && index < _tracks.length) {
      _recentlyDeleted = _tracks[index];
      _recentlyDeletedIndex = index;

      setState(() {
        _tracks.removeAt(index);
        if (_currentTrackIndex >= _tracks.length) {
          _currentTrackIndex = _tracks.isEmpty ? 0 : _tracks.length - 1;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Трек удалён'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Отменить',
            onPressed: () {
              if (_recentlyDeleted != null && _recentlyDeletedIndex != null) {
                setState(() {
                  _tracks.insert(_recentlyDeletedIndex!, _recentlyDeleted!);
                  _recentlyDeleted = null;
                  _recentlyDeletedIndex = null;
                });
              }
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlayerScreen(
      tracks: tracks,
      currentIndex: currentIndex,
      currentTrack: currentTrack,
      onNextTrack: nextTrack,
      onSelectTrack: selectTrack,
      onAddTrack: addTrack,
      onEditTrack: editTrack,
      onRemoveTrack: removeTrack,
      onEditTap: (index) async {
        final Track? updatedTrack = await context.push(
          '/player/track-form',
          extra: tracks[index],
        );
        if (updatedTrack != null) {
          editTrack(index, updatedTrack);
        }
      },
    );
  }
}