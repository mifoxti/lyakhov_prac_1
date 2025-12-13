import '../../../core/models/playlist.dart';
import '../../repositories/playlist_repository.dart';

class UpdatePlaylist {
  final PlaylistRepository repository;

  UpdatePlaylist(this.repository);

  Future<void> call(int id, Playlist playlist) async {
    return await repository.updatePlaylist(id, playlist);
  }
}
