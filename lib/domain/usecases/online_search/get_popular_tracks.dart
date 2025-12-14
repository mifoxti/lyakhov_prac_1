import '../../../core/models/track.dart';
import '../../repositories/online_search_repository.dart';

class GetPopularTracksUseCase {
  final OnlineSearchRepository repository;

  GetPopularTracksUseCase(this.repository);

  Future<List<Track>> call() async {
    return await repository.getPopularTracks();
  }
}
