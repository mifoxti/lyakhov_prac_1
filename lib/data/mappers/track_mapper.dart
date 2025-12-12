import '../../../core/models/track.dart';
import '../models/track_dto.dart';

class TrackMapper {
  static Track fromDto(TrackDto dto) {
    return Track(
      id: dto.id,
      title: dto.title,
      artist: dto.artist,
      duration: dto.duration,
      imageUrl: dto.imageUrl,
    );
  }

  static TrackDto toDto(Track entity) {
    return TrackDto(
      id: entity.id,
      title: entity.title,
      artist: entity.artist,
      duration: entity.duration,
      imageUrl: entity.imageUrl,
    );
  }
}
