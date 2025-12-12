import '../../../core/models/track.dart';
import '../../repositories/track_repository.dart';

class UpdateTrack {
  final TrackRepository repository;

  UpdateTrack(this.repository);

  Future<void> call(int id, Track track) async {
    await repository.updateTrack(id, track);
  }
}
