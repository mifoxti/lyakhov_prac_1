import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/playlist.dart';
import '../../../cubit/service_locator.dart';
import '../../../domain/usecases/playlists/create_playlist.dart';
import '../../../domain/usecases/playlists/delete_playlist.dart';
import '../../../domain/usecases/playlists/get_playlists.dart';
import '../../../domain/usecases/playlists/update_playlist.dart';

class LibraryState {
  final List<Playlist> playlists;

  const LibraryState({this.playlists = const []});

  LibraryState copyWith({List<Playlist>? playlists}) {
    return LibraryState(playlists: playlists ?? this.playlists);
  }

  int get playlistCount => playlists.length;
}

class LibraryCubit extends Cubit<LibraryState> {
  final GetPlaylists getPlaylistsUseCase;
  final CreatePlaylist createPlaylistUseCase;
  final UpdatePlaylist updatePlaylistUseCase;
  final DeletePlaylist deletePlaylistUseCase;

  LibraryCubit()
      : getPlaylistsUseCase = locator<GetPlaylists>(),
        createPlaylistUseCase = locator<CreatePlaylist>(),
        updatePlaylistUseCase = locator<UpdatePlaylist>(),
        deletePlaylistUseCase = locator<DeletePlaylist>(),
        super(const LibraryState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    try {
      final playlists = await getPlaylistsUseCase.call();
      emit(state.copyWith(playlists: playlists));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> addPlaylist(String name) async {
    try {
      final newPlaylist = Playlist(name: name);
      await createPlaylistUseCase.call(newPlaylist);
      await loadPlaylists();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updatePlaylist(int index, String newName) async {
    try {
      final playlist = state.playlists[index];
      final updatedPlaylist = playlist.copyWith(name: newName);
      await updatePlaylistUseCase.call(playlist.id!, updatedPlaylist);
      await loadPlaylists();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> removePlaylist(int index) async {
    try {
      final playlist = state.playlists[index];
      await deletePlaylistUseCase.call(playlist.id!);
      await loadPlaylists();
    } catch (e) {
      // Handle error
    }
  }
}
