import '../../../core/models/podcast.dart';
import '../../repositories/podcast_repository.dart';

class UpdatePodcast {
  final PodcastRepository repository;

  UpdatePodcast(this.repository);

  Future<void> call(int id, PodcastModel podcast) async {
    await repository.updatePodcast(id, podcast);
  }
}
