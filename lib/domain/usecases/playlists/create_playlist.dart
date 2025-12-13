import '../../../core/models/playlist.dart';
import '../../repositories/playlist_repository.dart';

class CreatePlaylist {
  final PlaylistRepository repository;

  CreatePlaylist(this.repository);

  Future<void> call(Playlist playlist) async {
    return await repository.createPlaylist(playlist);
  }
}
