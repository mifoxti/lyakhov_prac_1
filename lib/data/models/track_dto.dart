// lib/data/models/track_dto.dart

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

  factory TrackDto.fromLastFm({
    required String title,
    required String artist,
    required String duration,
    String? imageUrl,
  }) {
    return TrackDto(
      title: title.trim().isNotEmpty ? title.trim() : 'Unknown Track',
      artist: artist.trim().isNotEmpty ? artist.trim() : 'Unknown Artist',
      duration: _validateDuration(duration),
      imageUrl: imageUrl?.isNotEmpty == true ? imageUrl : null,
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

  Map<String, dynamic> toMap() {
    return toJson();
  }

  factory TrackDto.fromMap(Map<String, dynamic> map) {
    return TrackDto(
      id: map['id'] as int?,
      title: map['title'] as String? ?? 'Unknown Track',
      artist: map['artist'] as String? ?? 'Unknown Artist',
      duration: map['duration'] as String? ?? '0:00',
      imageUrl: map['imageUrl'] as String?,
    );
  }

  factory TrackDto.fromJson(Map<String, dynamic> json) {
    return TrackDto(
      id: json['id'] as int?,
      title: json['title'] as String? ?? 'Unknown Track',
      artist: json['artist'] as String? ?? 'Unknown Artist',
      duration: json['duration'] as String? ?? '0:00',
      imageUrl: json['imageUrl'] as String?,
    );
  }

  static String _validateDuration(String? input) {
    if (input == null) return '0:00';

    if (RegExp(r'^\d+$').hasMatch(input)) {
      final seconds = int.tryParse(input) ?? 0;
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    
    return input;
  }
}
