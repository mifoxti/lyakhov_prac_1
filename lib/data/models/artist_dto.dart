import 'package:json_annotation/json_annotation.dart';

part 'artist_dto.g.dart';

@JsonSerializable()
class ArtistDto {
  final String name;
  final String? imageUrl;
  final String? genre;
  final int? listeners;

  const ArtistDto({
    required this.name,
    this.imageUrl,
    this.genre,
    this.listeners,
  });

  factory ArtistDto.fromJson(Map<String, dynamic> json) => _$ArtistDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistDtoToJson(this);
}
