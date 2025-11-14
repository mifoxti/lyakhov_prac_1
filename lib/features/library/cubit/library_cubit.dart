import 'package:flutter_bloc/flutter_bloc.dart';

class Playlist {
  final int id;
  final String name;
  final int trackCount;

  Playlist({required this.id, required this.name, this.trackCount = 0});

  Playlist copyWith({int? id, String? name, int? trackCount}) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      trackCount: trackCount ?? this.trackCount,
    );
  }
}

class LibraryState {
  final List<Playlist> playlists;

  const LibraryState({this.playlists = const []});

  LibraryState copyWith({List<Playlist>? playlists}) {
    return LibraryState(playlists: playlists ?? this.playlists);
  }

  int get playlistCount => playlists.length;
}

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(const LibraryState()) {
    emit(
      LibraryState(
        playlists: [
          Playlist(id: 1, name: 'Любимые треки', trackCount: 125),
          Playlist(id: 2, name: 'Топ 2025', trackCount: 50),
          Playlist(id: 3, name: 'Для релакса', trackCount: 30),
          Playlist(id: 4, name: 'Тренировка', trackCount: 45),
          Playlist(id: 5, name: 'Дорожные хиты', trackCount: 60),
        ],
      ),
    );
  }

  int _nextId = 6;

  void addPlaylist(String name) {
    final newPlaylist = Playlist(id: _nextId++, name: name);
    emit(state.copyWith(playlists: List.of(state.playlists)..add(newPlaylist)));
  }

  void updatePlaylist(int index, String newName) {
    final updated = List.of(state.playlists);
    updated[index] = updated[index].copyWith(name: newName);
    emit(state.copyWith(playlists: updated));
  }

  void removePlaylist(int index) {
    final updated = List.of(state.playlists);
    updated.removeAt(index);
    emit(state.copyWith(playlists: updated));
  }
}