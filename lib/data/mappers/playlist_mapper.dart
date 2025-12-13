import '../../../core/models/playlist.dart';
import '../models/playlist_dto.dart';
import 'track_mapper.dart' as track_mapper;

class PlaylistMapper {
  static Playlist fromDto(PlaylistDto dto) {
    return Playlist(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      tracks: dto.tracks.map((trackDto) => track_mapper.trackDtoToModel(trackDto)).toList(),
      isPublic: dto.isPublic,
      allowCollaboration: dto.allowCollaboration,
      createdAt: dto.createdAt,
    );
  }

  static PlaylistDto toDto(Playlist entity) {
    return PlaylistDto(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      tracks: entity.tracks.map((track) => track_mapper.trackModelToDto(track)).toList(),
      isPublic: entity.isPublic,
      allowCollaboration: entity.allowCollaboration,
      createdAt: entity.createdAt,
    );
  }
}
