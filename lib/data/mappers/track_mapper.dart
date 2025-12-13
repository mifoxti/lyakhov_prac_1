import '../../core/models/track.dart';
import '../models/track_dto.dart';

Track trackDtoToModel(TrackDto dto) {
  return Track(
    id: dto.id ?? DateTime.now().millisecondsSinceEpoch,
    title: dto.title,
    artist: dto.artist,
    duration: dto.duration,
    imageUrl: dto.imageUrl,
  );
}

TrackDto trackModelToDto(Track model) {
  return TrackDto(
    id: model.id,
    title: model.title,
    artist: model.artist,
    duration: model.duration,
    imageUrl: model.imageUrl,
  );
}
