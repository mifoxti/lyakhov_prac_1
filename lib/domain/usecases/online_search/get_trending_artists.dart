import '../../../core/models/artist.dart';
import '../../repositories/online_search_repository.dart';

class GetTrendingArtistsUseCase {
  final OnlineSearchRepository repository;

  GetTrendingArtistsUseCase(this.repository);

  Future<List<Artist>> call() async {
    return await repository.getTrendingArtists();
  }
}
