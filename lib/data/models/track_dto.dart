class TrackDto {
  final int id;
  final String title;
  final String artist;
  final String duration;
  final String? imageUrl;

  TrackDto({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    this.imageUrl,
  });

  factory TrackDto.fromJson(Map<String, dynamic> json) {
    return TrackDto(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      duration: json['duration'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'duration': duration,
      'imageUrl': imageUrl,
    };
  }
}
