import '../../../core/models/track.dart';
import '../../repositories/track_repository.dart';

class AddTrack {
  final TrackRepository repository;

  AddTrack(this.repository);

  Future<void> call(Track track) async {
    await repository.addTrack(track);
  }
}
