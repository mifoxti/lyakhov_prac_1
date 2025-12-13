import '../../core/models/playlist.dart';

abstract class PlaylistRepository {
  Future<List<Playlist>> getPlaylists();
  Future<Playlist?> getPlaylistById(int id);
  Future<void> createPlaylist(Playlist playlist);
  Future<void> updatePlaylist(int id, Playlist playlist);
  Future<void> deletePlaylist(int id);
  Future<void> addTrackToPlaylist(int playlistId, int trackId);
  Future<void> removeTrackFromPlaylist(int playlistId, int trackId);
}
