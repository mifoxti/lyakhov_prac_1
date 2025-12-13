import '../../../core/models/playlist.dart';
import '../models/playlist_dto.dart';
import 'track_mapper.dart';

class PlaylistMapper {
  static Playlist fromDto(PlaylistDto dto) {
    return Playlist(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      tracks: dto.tracks.map((trackDto) => trackDto.toModel()).toList(),
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
      tracks: entity.tracks.map((track) => track.toDto()).toList(),
      isPublic: entity.isPublic,
      allowCollaboration: entity.allowCollaboration,
      createdAt: entity.createdAt,
    );
  }
}
