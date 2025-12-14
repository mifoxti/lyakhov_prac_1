import 'package:dio/dio.dart';

import '../../domain/repositories/online_search_repository.dart';
import '../../core/models/track.dart';
import '../../core/models/artist.dart';
import '../mappers/artist_mapper.dart';
import '../mappers/track_mapper.dart' as track_mapper;
import '../datasources/remote/lastfm_data_source.dart';
import '../datasources/remote/deezer_data_source.dart';

class OnlineSearchRepositoryImpl implements OnlineSearchRepository {
  final LastFmDataSource _lastFmDataSource;
  final DeezerDataSource _deezerDataSource;

  OnlineSearchRepositoryImpl(Dio dio)
      : _deezerDataSource = DeezerDataSource(dio),
        _lastFmDataSource = LastFmDataSource(dio, deezerDataSource: DeezerDataSource(dio));

  @override
  Future<List<Track>> searchTracks(String query) async {
    final dtos = await _lastFmDataSource.searchTracks(query);
    return dtos.map((dto) => track_mapper.trackDtoToModel(dto)).toList();
  }

  @override
  Future<List<Track>> getPopularTracks() async {
    final dtos = await _lastFmDataSource.getPopularTracks();
    return dtos.map((dto) => track_mapper.trackDtoToModel(dto)).toList();
  }

  @override
  Future<List<Artist>> searchArtists(String query) async {
    final dtos = await _deezerDataSource.searchArtists(query);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<List<Artist>> getTrendingArtists() async {
    final dtos = await _deezerDataSource.getTopArtists();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<List<Track>> getTracksByArtist(String artist) async {
    final dtos = await _lastFmDataSource.getTracksByArtist(artist);
    return dtos.map((dto) => track_mapper.trackDtoToModel(dto)).toList();
  }

  @override
  Future<List<Track>> getTracksByTag(String tag) async {
    final dtos = await _lastFmDataSource.getTracksByTag(tag);
    return dtos.map((dto) => track_mapper.trackDtoToModel(dto)).toList();
  }

  @override
  Future<Track?> getTrackInfo(String artist, String track) async {
    final dto = await _lastFmDataSource.getTrackInfo(artist, track);
    return dto != null ? track_mapper.trackDtoToModel(dto) : null;
  }

  Future<List<Artist>> getArtistsByCountry(String country) async {
    final dtos = await _deezerDataSource.getArtistsByCountry(country);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  Future<List<Artist>> getArtistsByGenre(int genreId) async {
    final dtos = await _deezerDataSource.getArtistsByGenre(genreId);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  Future<List<Track>> getTopTracksByArtist(String artistName) async {
    final trackMaps = await _deezerDataSource.getTopTracksByArtistName(artistName);
    return trackMaps.map((trackMap) {
      return Track(
        id: trackMap['id'] as int? ?? 0,
        title: trackMap['title'] as String? ?? '',
        artist: trackMap['artist'] as String? ?? '',
        duration: trackMap['duration'] as String? ?? '0:00',
        imageUrl: trackMap['imageUrl'] as String?,
      );
    }).toList();
  }
}
