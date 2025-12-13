import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/track.dart';

class OnlineSearchState {
  final List<Track> tracks;
  final List<dynamic> artists;
  final bool isLoadingTracks;
  final bool isLoadingArtists;
  final String? error;

  const OnlineSearchState({
    this.tracks = const [],
    this.artists = const [],
    this.isLoadingTracks = false,
    this.isLoadingArtists = false,
    this.error,
  });

  OnlineSearchState copyWith({
    List<Track>? tracks,
    List<dynamic>? artists,
    bool? isLoadingTracks,
    bool? isLoadingArtists,
    String? error,
  }) {
    return OnlineSearchState(
      tracks: tracks ?? this.tracks,
      artists: artists ?? this.artists,
      isLoadingTracks: isLoadingTracks ?? this.isLoadingTracks,
      isLoadingArtists: isLoadingArtists ?? this.isLoadingArtists,
      error: error,
    );
  }
}

class OnlineSearchCubit extends Cubit<OnlineSearchState> {
  OnlineSearchCubit() : super(const OnlineSearchState());

  Future<void> searchTracks(String query) async {
    emit(state.copyWith(isLoadingTracks: true, error: null));

    try {
      // TODO: Implement track search using repository
      // For now, emit empty results
      emit(state.copyWith(
        tracks: [],
        isLoadingTracks: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoadingTracks: false,
      ));
    }
  }

  Future<void> searchArtists(String query) async {
    emit(state.copyWith(isLoadingArtists: true, error: null));

    try {
      // TODO: Implement artist search using repository
      // For now, emit empty results
      emit(state.copyWith(
        artists: [],
        isLoadingArtists: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoadingArtists: false,
      ));
    }
  }

  Future<void> loadPopularTracks() async {
    emit(state.copyWith(isLoadingTracks: true, error: null));

    try {
      // TODO: Load popular tracks
      emit(state.copyWith(
        tracks: [],
        isLoadingTracks: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoadingTracks: false,
      ));
    }
  }

  Future<void> loadTrendingArtists() async {
    emit(state.copyWith(isLoadingArtists: true, error: null));

    try {
      // TODO: Load trending artists
      emit(state.copyWith(
        artists: [],
        isLoadingArtists: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoadingArtists: false,
      ));
    }
  }
}
