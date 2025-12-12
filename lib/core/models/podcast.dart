class PodcastModel {
  final int id;
  final String title;
  final String author;
  final String duration;
  final String imageUrl;

  PodcastModel({
    required this.id,
    required this.title,
    required this.author,
    required this.duration,
    this.imageUrl = '',
  });

  PodcastModel copyWith({
    int? id,
    String? title,
    String? author,
    String? duration,
    String? imageUrl,
  }) {
    return PodcastModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
