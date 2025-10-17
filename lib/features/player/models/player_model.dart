class Track {
  final int id;
  final String title;
  final String artist;
  final String duration;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
  });

  Track copyWith({
    int? id,
    String? title,
    String? artist,
    String? duration,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      duration: duration ?? this.duration,
    );
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] as int,
      title: map['title'] as String,
      artist: map['artist'] as String,
      duration: map['duration'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'artist': artist,
    'duration': duration,
  };
}
