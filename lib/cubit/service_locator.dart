import 'package:get_it/get_it.dart';

import '../data/datasources/in_memory_podcast_data_source.dart';
import '../data/datasources/in_memory_track_data_source.dart';
import '../data/repositories/podcast_repository_impl.dart';
import '../data/repositories/track_repository_impl.dart';
import '../domain/repositories/podcast_repository.dart';
import '../domain/repositories/track_repository.dart';
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
  // Data sources
  locator.registerLazySingleton<InMemoryPodcastDataSource>(() => InMemoryPodcastDataSource());
  locator.registerLazySingleton<InMemoryTrackDataSource>(() => InMemoryTrackDataSource());

  // Repositories
  locator.registerLazySingleton<PodcastRepository>(
    () => PodcastRepositoryImpl(locator<InMemoryPodcastDataSource>()),
  );
  locator.registerLazySingleton<TrackRepository>(
    () => TrackRepositoryImpl(locator<InMemoryTrackDataSource>()),
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
}
