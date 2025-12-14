import '../../../core/models/track.dart';
import '../../repositories/online_search_repository.dart';

class GetTrackInfoUseCase {
  final OnlineSearchRepository repository;

  GetTrackInfoUseCase(this.repository);

  Future<Track?> call(String artist, String track) async {
    return await repository.getTrackInfo(artist, track);
  }
}
