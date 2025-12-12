class PodcastDto {
  final int id;
  final String title;
  final String author;
  final String duration;
  final String imageUrl;

  PodcastDto({
    required this.id,
    required this.title,
    required this.author,
    required this.duration,
    this.imageUrl = '',
  });

  factory PodcastDto.fromJson(Map<String, dynamic> json) {
    return PodcastDto(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      duration: json['duration'],
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'duration': duration,
      'imageUrl': imageUrl,
    };
  }
}
