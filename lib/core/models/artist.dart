class Artist {
  final String name;
  final String? imageUrl;
  final String? genre;
  final int? listeners;

  const Artist({
    required this.name,
    this.imageUrl,
    this.genre,
    this.listeners,
  });

  @override
  String toString() {
    return 'Artist{name: $name, imageUrl: $imageUrl, genre: $genre, listeners: $listeners}';
  }
}
