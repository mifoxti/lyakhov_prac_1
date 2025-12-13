import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/datasources/remote/error_interceptor.dart';
import '../data/datasources/remote/logging_interceptor.dart';
import '../data/datasources/remote/retry_interceptor.dart';

import '../data/datasources/in_memory_podcast_data_source.dart';
import '../data/datasources/playlist_local_data_source.dart';
import '../data/datasources/remote/deezer_data_source.dart';
import '../data/datasources/remote/lastfm_data_source.dart';
import '../data/datasources/remote/logging_interceptor.dart';
import '../data/datasources/remote/error_interceptor.dart';
import '../data/datasources/track_local_data_source.dart';
import '../data/repositories/online_search_repository_impl.dart';
import '../data/repositories/playlist_repository_impl.dart';
import '../data/repositories/podcast_repository_impl.dart';
import '../data/repositories/track_repository_impl.dart';
import '../domain/repositories/online_search_repository.dart';
import '../domain/repositories/playlist_repository.dart';
import '../domain/repositories/podcast_repository.dart';
import '../domain/repositories/track_repository.dart';
import '../domain/usecases/online_search/get_artists_by_country.dart';
import '../domain/usecases/online_search/get_artists_by_genre.dart';
import '../domain/usecases/online_search/get_popular_tracks.dart';
import '../domain/usecases/online_search/get_track_info.dart';
import '../domain/usecases/online_search/get_tracks_by_artist.dart';
import '../domain/usecases/online_search/get_tracks_by_tag.dart';
import '../domain/usecases/online_search/get_trending_artists.dart';
import '../domain/usecases/online_search/search_artists.dart';
import '../domain/usecases/online_search/search_tracks.dart';

// Re-export for convenience
export '../domain/usecases/online_search/search_tracks.dart';
export '../domain/usecases/online_search/get_popular_tracks.dart';
export '../domain/usecases/online_search/get_tracks_by_artist.dart';
export '../domain/usecases/online_search/get_tracks_by_tag.dart';
export '../domain/usecases/online_search/get_track_info.dart';
export '../domain/usecases/online_search/search_artists.dart';
export '../domain/usecases/online_search/get_trending_artists.dart';
export '../domain/usecases/online_search/get_artists_by_country.dart';
export '../domain/usecases/online_search/get_artists_by_genre.dart';
import '../domain/usecases/playlists/create_playlist.dart';
import '../domain/usecases/playlists/delete_playlist.dart';
import '../domain/usecases/playlists/get_playlists.dart';
import '../domain/usecases/playlists/update_playlist.dart';
import '../domain/usecases/podcasts/add_podcast.dart';
import '../domain/usecases/podcasts/get_podcasts.dart';
import '../domain/usecases/podcasts/remove_podcast.dart';
import '../domain/usecases/podcasts/update_podcast.dart';
import '../domain/usecases/tracks/add_track.dart';
import '../domain/usecases/tracks/get_tracks.dart';
import '../domain/usecases/tracks/remove_track.dart';
import '../domain/usecases/tracks/update_track.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Dio client for API calls
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    dio.interceptors.addAll([
      RetryInterceptor(maxRetries: 2, retryDelay: const Duration(seconds: 1)),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
    return dio;
  });

  // Data sources
  locator.registerLazySingleton<InMemoryPodcastDataSource>(() => InMemoryPodcastDataSource());
  locator.registerLazySingleton<TrackLocalDataSource>(() => TrackLocalDataSource());
  locator.registerLazySingleton<PlaylistLocalDataSource>(() => PlaylistLocalDataSource());

  // Repositories
  locator.registerLazySingleton<PodcastRepository>(
    () => PodcastRepositoryImpl(locator<InMemoryPodcastDataSource>()),
  );
  locator.registerLazySingleton<TrackRepository>(
    () => TrackRepositoryImpl(locator<TrackLocalDataSource>()),
  );
  locator.registerLazySingleton<PlaylistRepository>(
    () => PlaylistRepositoryImpl(locator<PlaylistLocalDataSource>()),
  );
  locator.registerLazySingleton<OnlineSearchRepository>(
    () => OnlineSearchRepositoryImpl(locator<Dio>()),
  );

  // Use cases
  locator.registerLazySingleton<GetPodcasts>(() => GetPodcasts(locator<PodcastRepository>()));
  locator.registerLazySingleton<AddPodcast>(() => AddPodcast(locator<PodcastRepository>()));
  locator.registerLazySingleton<UpdatePodcast>(() => UpdatePodcast(locator<PodcastRepository>()));
  locator.registerLazySingleton<RemovePodcast>(() => RemovePodcast(locator<PodcastRepository>()));

  locator.registerLazySingleton<GetTracks>(() => GetTracks(locator<TrackRepository>()));
  locator.registerLazySingleton<AddTrack>(() => AddTrack(locator<TrackRepository>()));
  locator.registerLazySingleton<UpdateTrack>(() => UpdateTrack(locator<TrackRepository>()));
  locator.registerLazySingleton<RemoveTrack>(() => RemoveTrack(locator<TrackRepository>()));

  locator.registerLazySingleton<GetPlaylists>(() => GetPlaylists(locator<PlaylistRepository>()));
  locator.registerLazySingleton<CreatePlaylist>(() => CreatePlaylist(locator<PlaylistRepository>()));
  locator.registerLazySingleton<UpdatePlaylist>(() => UpdatePlaylist(locator<PlaylistRepository>()));
  locator.registerLazySingleton<DeletePlaylist>(() => DeletePlaylist(locator<PlaylistRepository>()));

  // Online search use cases
  locator.registerLazySingleton<SearchTracksUseCase>(() => SearchTracksUseCase(locator()));
  locator.registerLazySingleton<GetPopularTracksUseCase>(() => GetPopularTracksUseCase(locator()));
  locator.registerLazySingleton<GetTracksByArtistUseCase>(() => GetTracksByArtistUseCase(locator()));
  locator.registerLazySingleton<GetTracksByTagUseCase>(() => GetTracksByTagUseCase(locator()));
  locator.registerLazySingleton<GetTrackInfoUseCase>(() => GetTrackInfoUseCase(locator()));
  locator.registerLazySingleton<SearchArtistsUseCase>(() => SearchArtistsUseCase(locator()));
  locator.registerLazySingleton<GetTrendingArtistsUseCase>(() => GetTrendingArtistsUseCase(locator()));
  locator.registerLazySingleton<GetArtistsByCountryUseCase>(() => GetArtistsByCountryUseCase(locator()));
  locator.registerLazySingleton<GetArtistsByGenreUseCase>(() => GetArtistsByGenreUseCase(locator()));
}
