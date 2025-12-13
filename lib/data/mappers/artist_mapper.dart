import '../models/artist_dto.dart';

extension ArtistMapper on ArtistDto {
  Map<String, dynamic> toModel() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'genre': genre,
      'listeners': listeners,
    };
  }
}
