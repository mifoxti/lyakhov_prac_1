import '../../../core/models/artist.dart';
import '../../repositories/online_search_repository.dart';

class SearchArtistsUseCase {
  final OnlineSearchRepository repository;

  SearchArtistsUseCase(this.repository);

  Future<List<Artist>> call(String query) async {
    return await repository.searchArtists(query);
  }
}
