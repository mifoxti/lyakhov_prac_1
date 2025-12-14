import '../../../core/models/artist.dart';
import '../../repositories/online_search_repository.dart';

class GetArtistsByGenreUseCase {
  final OnlineSearchRepository repository;

  GetArtistsByGenreUseCase(this.repository);

  Future<List<Artist>> call(int genreId) async {
    return await (repository as dynamic).getArtistsByGenre(genreId);
  }
}
