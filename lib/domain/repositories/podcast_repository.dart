import '../../core/models/podcast.dart';

abstract class PodcastRepository {
  Future<List<PodcastModel>> getPodcasts();
  Future<void> addPodcast(PodcastModel podcast);
  Future<void> updatePodcast(int id, PodcastModel podcast);
  Future<void> removePodcast(int id);
}
