import '../../../core/models/playlist.dart';
import '../../../domain/repositories/playlist_repository.dart';
import '../datasources/playlist_local_data_source.dart';
import '../mappers/playlist_mapper.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final PlaylistLocalDataSource dataSource;

  PlaylistRepositoryImpl(this.dataSource);

  @override
  Future<List<Playlist>> getPlaylists() async {
    final dtos = await dataSource.getPlaylists();
    return dtos.map((dto) => PlaylistMapper.fromDto(dto)).toList();
  }

  @override
  Future<Playlist?> getPlaylistById(int id) async {
    final dto = await dataSource.getPlaylistById(id);
    return dto != null ? PlaylistMapper.fromDto(dto) : null;
  }

  @override
  Future<void> createPlaylist(Playlist playlist) async {
    final dto = PlaylistMapper.toDto(playlist);
    await dataSource.createPlaylist(dto);
  }

  @override
  Future<void> updatePlaylist(int id, Playlist playlist) async {
    final dto = PlaylistMapper.toDto(playlist);
    await dataSource.updatePlaylist(id, dto);
  }

  @override
  Future<void> deletePlaylist(int id) async {
    await dataSource.deletePlaylist(id);
  }

  @override
  Future<void> addTrackToPlaylist(int playlistId, int trackId) async {
    await dataSource.addTrackToPlaylist(playlistId, trackId);
  }

  @override
  Future<void> removeTrackFromPlaylist(int playlistId, int trackId) async {
    await dataSource.removeTrackFromPlaylist(playlistId, trackId);
  }
}
