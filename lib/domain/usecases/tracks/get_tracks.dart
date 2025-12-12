import '../../../core/models/track.dart';
import '../../repositories/track_repository.dart';

class GetTracks {
  final TrackRepository repository;

  GetTracks(this.repository);

  Future<List<Track>> call() async {
    return await repository.getTracks();
  }
}
