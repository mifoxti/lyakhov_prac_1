import '../../../core/models/podcast.dart';
import '../../repositories/podcast_repository.dart';

class AddPodcast {
  final PodcastRepository repository;

  AddPodcast(this.repository);

  Future<void> call(PodcastModel podcast) async {
    await repository.addPodcast(podcast);
  }
}
