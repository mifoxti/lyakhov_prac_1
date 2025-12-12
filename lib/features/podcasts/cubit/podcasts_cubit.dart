import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/service_locator.dart';
import '../../../core/models/podcast.dart';
import '../../../domain/usecases/podcasts/add_podcast.dart';
import '../../../domain/usecases/podcasts/get_podcasts.dart';
import '../../../domain/usecases/podcasts/remove_podcast.dart';
import '../../../domain/usecases/podcasts/update_podcast.dart';

class PodcastState {
  final List<PodcastModel> podcasts;
  final bool isLoading;

  const PodcastState({
    this.podcasts = const [],
    this.isLoading = false,
  });

  PodcastState copyWith({
    List<PodcastModel>? podcasts,
    bool? isLoading,
  }) {
    return PodcastState(
      podcasts: podcasts ?? this.podcasts,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get podcastCount => podcasts.length;
}

class PodcastsCubit extends Cubit<PodcastState> {
  final GetPodcasts getPodcastsUseCase;
  final AddPodcast addPodcastUseCase;
  final UpdatePodcast updatePodcastUseCase;
  final RemovePodcast removePodcastUseCase;

  PodcastsCubit()
      : getPodcastsUseCase = locator<GetPodcasts>(),
        addPodcastUseCase = locator<AddPodcast>(),
        updatePodcastUseCase = locator<UpdatePodcast>(),
        removePodcastUseCase = locator<RemovePodcast>(),
        super(const PodcastState()) {
    loadPodcasts();
  }

  Future<void> loadPodcasts() async {
    emit(state.copyWith(isLoading: true));
    try {
      final podcasts = await getPodcastsUseCase.call();
      emit(state.copyWith(podcasts: podcasts, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // Handle error
    }
  }

  Future<void> addPodcast(String title, String author, String duration) async {
    try {
      final newPodcast = PodcastModel(
        id: 0, // ID will be set in data layer
        title: title,
        author: author,
        duration: duration,
      );
      await addPodcastUseCase.call(newPodcast);
      await loadPodcasts(); // Reload list
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updatePodcast(int id, PodcastModel updatedPodcast) async {
    try {
      await updatePodcastUseCase.call(id, updatedPodcast);
      await loadPodcasts(); // Reload list
    } catch (e) {
      // Handle error
    }
  }

  Future<void> removePodcast(int id) async {
    try {
      await removePodcastUseCase.call(id);
      await loadPodcasts(); // Reload list
    } catch (e) {
      // Handle error
    }
  }
}
