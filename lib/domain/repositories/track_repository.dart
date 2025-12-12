import '../../core/models/track.dart';

abstract class TrackRepository {
  Future<List<Track>> getTracks();
  Future<void> addTrack(Track track);
  Future<void> updateTrack(int id, Track track);
  Future<void> removeTrack(int id);
}
