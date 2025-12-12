import '../../repositories/track_repository.dart';

class RemoveTrack {
  final TrackRepository repository;

  RemoveTrack(this.repository);

  Future<void> call(int id) async {
    await repository.removeTrack(id);
  }
}
