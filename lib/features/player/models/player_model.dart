class Track {
  final int id;
  final String title;
  final String artist;
  final String duration;

  Track({
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'duration': duration,
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      duration: map['duration'],
    );
  }
}




