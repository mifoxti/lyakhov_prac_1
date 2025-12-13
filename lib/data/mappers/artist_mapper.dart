import '../../../core/models/artist.dart';
import '../models/artist_dto.dart';

extension ArtistMapper on ArtistDto {
  Artist toModel() {
    return Artist(
      name: name,
      imageUrl: imageUrl,
      genre: genre,
      listeners: listeners,
    );
  }
}
