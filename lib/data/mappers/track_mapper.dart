import '../../core/models/track.dart';
import '../models/track_dto.dart';

extension TrackMapper on TrackDto {
  Track toModel() {
    return Track(
      id: id ?? DateTime.now().millisecondsSinceEpoch,
      title: title,
      artist: artist,
      duration: duration,
      imageUrl: imageUrl,
    );
  }
}

extension TrackModelMapper on Track {
  TrackDto toDto() {
    return TrackDto(
      id: id,
      title: title,
      artist: artist,
      duration: duration,
      imageUrl: imageUrl,
    );
  }
}
