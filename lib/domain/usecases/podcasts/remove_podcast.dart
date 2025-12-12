import '../../repositories/podcast_repository.dart';

class RemovePodcast {
  final PodcastRepository repository;

  RemovePodcast(this.repository);

  Future<void> call(int id) async {
    await repository.removePodcast(id);
  }
}
