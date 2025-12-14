import '../../../core/models/artist.dart';
import '../../repositories/online_search_repository.dart';

class GetArtistsByCountryUseCase {
  final OnlineSearchRepository repository;

  GetArtistsByCountryUseCase(this.repository);

  Future<List<Artist>> call(String country) async {
    return await (repository as dynamic).getArtistsByCountry(country);
  }
}
