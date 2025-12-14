import '../../../core/models/track.dart';
import '../../repositories/online_search_repository.dart';

class GetTracksByArtistUseCase {
  final OnlineSearchRepository repository;

  GetTracksByArtistUseCase(this.repository);

  Future<List<Track>> call(String artist) async {
    return await repository.getTracksByArtist(artist);
  }
}
