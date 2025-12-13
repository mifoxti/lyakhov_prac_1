import '../../../core/models/track.dart';
import '../../../core/models/artist.dart';

abstract class OnlineSearchRepository {
  Future<List<Track>> searchTracks(String query);
  Future<List<Track>> getPopularTracks();
  Future<List<Track>> getTracksByArtist(String artist);
  Future<List<Track>> getTracksByTag(String tag);
  Future<Track?> getTrackInfo(String artist, String track);
  Future<List<Artist>> searchArtists(String query);
  Future<List<Artist>> getTrendingArtists();
}
