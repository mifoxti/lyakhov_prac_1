import 'track_dto.dart';

class PlaylistDto {
  final int? id;
  final String name;
  final String? description;
  final List<TrackDto> tracks;
  final bool isPublic;
  final bool allowCollaboration;
  final String? createdAt;

  const PlaylistDto({
    this.id,
    required this.name,
    this.description,
    this.tracks = const [],
    this.isPublic = false,
    this.allowCollaboration = false,
    this.createdAt,
  });

  factory PlaylistDto.fromMap(
    Map<String, dynamic> playlistMap,
    List<Map<String, dynamic>> trackMaps,
    Map<String, dynamic>? settingsMap,
  ) {
    final tracks = trackMaps.map((trackMap) => TrackDto.fromMap(trackMap)).toList();

    return PlaylistDto(
      id: playlistMap['id'] as int?,
      name: playlistMap['name'] as String,
      description: playlistMap['description'] as String?,
      createdAt: playlistMap['created_at'] as String?,
      tracks: tracks,
      isPublic: settingsMap?['is_public'] == 1,
      allowCollaboration: settingsMap?['allow_collaboration'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'name': name,
      'description': description,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  PlaylistDto copyWith({
    int? id,
    String? name,
    String? description,
    List<TrackDto>? tracks,
    bool? isPublic,
    bool? allowCollaboration,
    String? createdAt,
  }) {
    return PlaylistDto(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tracks: tracks ?? this.tracks,
      isPublic: isPublic ?? this.isPublic,
      allowCollaboration: allowCollaboration ?? this.allowCollaboration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  int get trackCount => tracks.length;
}
