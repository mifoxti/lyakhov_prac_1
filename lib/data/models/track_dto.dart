import 'package:json_annotation/json_annotation.dart';

part 'track_dto.g.dart';

@JsonSerializable()
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

  factory TrackDto.fromJson(Map<String, dynamic> json) => _$TrackDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TrackDtoToJson(this);

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
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'duration': duration,
      'imageUrl': imageUrl,
    };
  }
}
