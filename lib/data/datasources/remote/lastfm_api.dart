import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/models/track.dart';
import '../../models/track_dto.dart';

part 'lastfm_api.g.dart';

@RestApi(baseUrl: 'https://ws.audioscrobbler.com/2.0/')
abstract class LastFmApi {
  factory LastFmApi(Dio dio, {String baseUrl}) = _LastFmApi;

  @GET('/')
  Future<HttpResponse<dynamic>> searchTracks({
    @Query('method') String method = 'track.search',
    @Query('track') required String track,
    @Query('api_key') String apiKey = 'a3fbd8744518d9243d7465c6ef71d359',
    @Query('format') String format = 'json',
    @Query('limit') int limit = 20,
  });

  @GET('/')
  Future<HttpResponse<dynamic>> getTrackInfo({
    @Query('method') String method = 'track.getInfo',
    @Query('artist') required String artist,
    @Query('track') required String track,
    @Query('api_key') String apiKey = 'a3fbd8744518d9243d7465c6ef71d359',
    @Query('format') String format = 'json',
  });

  @GET('/')
  Future<HttpResponse<dynamic>> getTopTracks({
    @Query('method') String method = 'chart.getTopTracks',
    @Query('api_key') String apiKey = 'a3fbd8744518d9243d7465c6ef71d359',
    @Query('format') String format = 'json',
    @Query('limit') int limit = 20,
  });

  @GET('/')
  Future<HttpResponse<dynamic>> searchTracksByArtist({
    @Query('method') String method = 'artist.getTopTracks',
    @Query('artist') required String artist,
    @Query('api_key') String apiKey = 'a3fbd8744518d9243d7465c6ef71d359',
    @Query('format') String format = 'json',
    @Query('limit') int limit = 20,
  });

  @GET('/')
  Future<HttpResponse<dynamic>> getTracksByTag({
    @Query('method') String method = 'tag.getTopTracks',
    @Query('tag') required String tag,
    @Query('api_key') String apiKey = 'a3fbd8744518d9243d7465c6ef71d359',
    @Query('format') String format = 'json',
    @Query('limit') int limit = 20,
  });
}
