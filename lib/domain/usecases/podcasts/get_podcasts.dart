import '../../../core/models/podcast.dart';
import '../../repositories/podcast_repository.dart';

class GetPodcasts {
  final PodcastRepository repository;

  GetPodcasts(this.repository);

  Future<List<PodcastModel>> call() async {
    return await repository.getPodcasts();
  }
}
