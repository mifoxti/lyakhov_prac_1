import '../../core/models/podcast.dart';
import '../models/podcast_dto.dart';

class PodcastMapper {
  static PodcastModel fromDto(PodcastDto dto) {
    return PodcastModel(
      id: dto.id,
      title: dto.title,
      author: dto.author,
      duration: dto.duration,
      imageUrl: dto.imageUrl,
    );
  }

  static PodcastDto toDto(PodcastModel entity) {
    return PodcastDto(
      id: entity.id,
      title: entity.title,
      author: entity.author,
      duration: entity.duration,
      imageUrl: entity.imageUrl,
    );
  }
}
