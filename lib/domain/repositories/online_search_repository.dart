import '../../../core/models/track.dart';

abstract class OnlineSearchRepository {
  Future<List<Track>> searchTracks(String query);
  Future<List<Track>> getPopularTracks();
  Future<List<dynamic>> searchArtists(String query);
  Future<List<dynamic>> getTrendingArtists();
}
