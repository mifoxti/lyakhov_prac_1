import '../../../core/models/track.dart';
import '../../repositories/online_search_repository.dart';

class GetTracksByTagUseCase {
  final OnlineSearchRepository repository;

  GetTracksByTagUseCase(this.repository);

  Future<List<Track>> call(String tag) async {
    return await repository.getTracksByTag(tag);
  }
}
