import '../../repositories/online_search_repository.dart';

class SearchTracksUseCase {
  final OnlineSearchRepository repository;

  SearchTracksUseCase(this.repository);

  Future<List<dynamic>> call(String query) async {
    return await repository.searchTracks(query);
  }
}
