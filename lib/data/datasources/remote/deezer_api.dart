import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'deezer_api.g.dart';

@RestApi(baseUrl: 'https://api.deezer.com/')
abstract class DeezerApi {
  factory DeezerApi(Dio dio, {String baseUrl}) = _DeezerApi;

  @GET('/search/artist')
  Future<HttpResponse<dynamic>> searchArtists({
    @Query('q') required String query,
    @Query('limit') int limit = 20,
  });

  @GET('/search/artist')
  Future<HttpResponse<dynamic>> searchArtistsByCountry({
    @Query('q') required String country,
    @Query('limit') int limit = 20,
  });

  @GET('/chart/0/artists')
  Future<HttpResponse<dynamic>> getTopArtists({
    @Query('limit') int limit = 20,
  });

  @GET('/artist/{id}/top')
  Future<HttpResponse<dynamic>> getArtistTopTracks({
    @Path('id') required int artistId,
    @Query('limit') int limit = 10,
  });

  @GET('/genre/{id}/artists')
  Future<HttpResponse<dynamic>> getArtistsByGenre({
    @Path('id') required int genreId,
    @Query('limit') int limit = 20,
  });

  @GET('/search/track')
  Future<HttpResponse<dynamic>> searchTracks({
    @Query('q') required String query,
    @Query('limit') int limit = 10,
  });
}
