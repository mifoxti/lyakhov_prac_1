import 'track.dart';

class Playlist {
  final int? id;
  final String name;
  final String? description;
  final List<Track> tracks;
  final bool isPublic;
  final bool allowCollaboration;
  final String? createdAt;

  const Playlist({
    this.id,
    required this.name,
    this.description,
    this.tracks = const [],
    this.isPublic = false,
    this.allowCollaboration = false,
    this.createdAt,
  });

  Playlist copyWith({
    int? id,
    String? name,
    String? description,
    List<Track>? tracks,
    bool? isPublic,
    bool? allowCollaboration,
    String? createdAt,
  }) {
    return Playlist(
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
