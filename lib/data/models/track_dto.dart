class TrackDto {
  final int? id;
  final String title;
  final String artist;
  final String duration;
  final String? imageUrl;

  const TrackDto({
    this.id,
    required this.title,
    required this.artist,
    required this.duration,
    this.imageUrl,
  });

  factory TrackDto.fromMap(Map<String, dynamic> map) {
    return TrackDto(
      id: map['id'] as int?,
      title: map['title'] as String,
      artist: map['artist'] as String,
      duration: map['duration'] as String,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'title': title,
      'artist': artist,
      'duration': duration,
      'imageUrl': imageUrl,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  TrackDto copyWith({
    int? id,
    String? title,
    String? artist,
    String? duration,
    String? imageUrl,
  }) {
    return TrackDto(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
