import '../../../core/models/podcast.dart';
import '../../domain/repositories/podcast_repository.dart';
import '../datasources/in_memory_podcast_data_source.dart';
import '../mappers/podcast_mapper.dart';

class PodcastRepositoryImpl implements PodcastRepository {
  final InMemoryPodcastDataSource dataSource;

  PodcastRepositoryImpl(this.dataSource);

  @override
  Future<List<PodcastModel>> getPodcasts() async {
    final dtos = await dataSource.getPodcasts();
    return dtos.map((dto) => PodcastMapper.fromDto(dto)).toList();
  }

  @override
  Future<void> addPodcast(PodcastModel podcast) async {
    final dto = PodcastMapper.toDto(podcast);
    await dataSource.addPodcast(dto);
  }

  @override
  Future<void> updatePodcast(int id, PodcastModel podcast) async {
    final dto = PodcastMapper.toDto(podcast);
    await dataSource.updatePodcast(id, dto);
  }

  @override
  Future<void> removePodcast(int id) async {
    await dataSource.removePodcast(id);
  }
}
