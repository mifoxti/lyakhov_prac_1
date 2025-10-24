class Track {
  final int id;
  final String title;
  final String artist;
  final String duration;
  final String? imageUrl; // Добавляем поле для картинки

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    this.imageUrl, // Делаем необязательным
  });

  Track copyWith({
    int? id,
    String? title,
    String? artist,
    String? duration,
    String? imageUrl, // Добавляем в copyWith
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl, // Добавляем здесь
    );
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] as int,
      title: map['title'] as String,
      artist: map['artist'] as String,
      duration: map['duration'] as String,
      imageUrl: map['imageUrl'] as String?, // Добавляем здесь
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'artist': artist,
    'duration': duration,
    'imageUrl': imageUrl, // Добавляем здесь
  };
}