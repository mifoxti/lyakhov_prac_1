import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../screens/player_screen.dart';
import '../screens/player_form_screen.dart';

enum PlayerScreenState { list, form }

abstract class PlayerController {
  List<Track> get tracks;
  int get currentIndex;
  Track? get currentTrack;

  void nextTrack();
  void selectTrack(int index);
  void addTrack(Track track);
  void editTrack(int index, Track updated);
  void removeTrack(int index);

  void showList();
  void showForm([Track? editingTrack]);
}

class PlayerContainer extends StatefulWidget {
  const PlayerContainer({super.key});

  @override
  State<PlayerContainer> createState() => _PlayerContainerState();

  static Widget withScreen() => const PlayerContainer();
}

class _PlayerContainerState extends State<PlayerContainer>
    implements PlayerController {
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
  PlayerScreenState _currentScreen = PlayerScreenState.list;

  Track? _editingTrack;
  int? _editingIndex;

  // Для реализации отмены удаления
  Track? _recentlyDeleted;
  int? _recentlyDeletedIndex;

  @override
  List<Track> get tracks => List.unmodifiable(_tracks);

  @override
  int get currentIndex => _currentTrackIndex;

  @override
  Track? get currentTrack =>
      _tracks.isEmpty ? null : _tracks[_currentTrackIndex];

  @override
  void nextTrack() {
    if (_tracks.isEmpty) return;
    setState(() {
      _currentTrackIndex = (_currentTrackIndex + 1) % _tracks.length;
    });
  }

  @override
  void selectTrack(int index) {
    if (index >= 0 && index < _tracks.length) {
      setState(() {
        _currentTrackIndex = index;
      });
    }
  }

  @override
  void addTrack(Track track) {
    setState(() {
      _tracks.add(track);
      _currentScreen = PlayerScreenState.list;
    });
  }

  @override
  void editTrack(int index, Track updated) {
    if (index >= 0 && index < _tracks.length) {
      setState(() {
        _tracks[index] = updated;
        _currentScreen = PlayerScreenState.list;
      });
    }
  }

  @override
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

  void _showForm([Track? editingTrack]) => setState(() {
    _currentScreen = PlayerScreenState.form;
    _editingTrack = editingTrack;
    _editingIndex =
    editingTrack != null ? _tracks.indexOf(editingTrack) : null;
  });

  void _showList() => setState(() {
    _currentScreen = PlayerScreenState.list;
    _editingTrack = null;
    _editingIndex = null;
  });

  @override
  void showForm([Track? editingTrack]) => _showForm(editingTrack);

  @override
  void showList() => _showList();

  @override
  Widget build(BuildContext context) {
    Widget body;

    // Выбор активного интерфейса на основе текущего состояния
    if (_currentScreen == PlayerScreenState.list) {
      body = PlayerScreen(
        container: this,
        onAddTap: _showForm,
      );
    } else {
      body = PlayerFormScreen(
        existingTrack: _editingTrack,
        onSave: (track) {
          if (_editingIndex != null) {
            editTrack(_editingIndex!, track);
          } else {
            addTrack(track);
          }
        },
        onCancel: _showList,
      );
    }

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: body,
      ),
    );
  }
}
