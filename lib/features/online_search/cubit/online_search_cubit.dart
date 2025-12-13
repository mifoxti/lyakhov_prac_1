import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/track.dart';
import '../../../core/models/artist.dart';
import '../../../cubit/service_locator.dart';
import '../../../domain/repositories/online_search_repository.dart';

class OnlineSearchState {
  final List<Track> tracks;
  final List<Artist> artists;
  final bool isLoadingTracks;
  final bool isLoadingArtists;
  final String? error;
  final bool isTagSearch;
  final bool showTracksInArtistsTab;
  final List<Track> artistTabTracks; // Tracks to show in artists tab

  const OnlineSearchState({
    this.tracks = const [],
    this.artists = const [],
    this.isLoadingTracks = false,
    this.isLoadingArtists = false,
    this.error,
    this.isTagSearch = false,
    this.showTracksInArtistsTab = false,
    this.artistTabTracks = const [],
  });

  OnlineSearchState copyWith({
    List<Track>? tracks,
    List<Artist>? artists,
    bool? isLoadingTracks,
    bool? isLoadingArtists,
    String? error,
    bool? isTagSearch,
    bool? showTracksInArtistsTab,
    List<Track>? artistTabTracks,
  }) {
    return OnlineSearchState(
      tracks: tracks ?? this.tracks,
      artists: artists ?? this.artists,
      isLoadingTracks: isLoadingTracks ?? this.isLoadingTracks,
      isLoadingArtists: isLoadingArtists ?? this.isLoadingArtists,
      error: error,
      isTagSearch: isTagSearch ?? this.isTagSearch,
      showTracksInArtistsTab: showTracksInArtistsTab ?? this.showTracksInArtistsTab,
      artistTabTracks: artistTabTracks ?? this.artistTabTracks,
    );
  }
}

class OnlineSearchCubit extends Cubit<OnlineSearchState> {
  final OnlineSearchRepository _repository;

  OnlineSearchCubit()
      : _repository = locator<OnlineSearchRepository>(),
        super(const OnlineSearchState());

  Future<void> searchTracks(String query) async {
    emit(state.copyWith(isLoadingTracks: true, error: null));

    try {
      // Check if query starts with # for tag search
      if (query.startsWith('#') && query.length > 1) {
        final tag = query.substring(1).trim();
        if (tag.isNotEmpty) {
          final tracks = await _repository.getTracksByTag(tag);
          emit(state.copyWith(
            tracks: tracks,
            isLoadingTracks: false,
            isTagSearch: true,
          ));
          return;
        }
      }

      // Check if query starts with artisttop: for artist top tracks
      if (query.toLowerCase().startsWith('artisttop:') && query.length > 10) {
        final artistName = query.substring(10).trim();
        if (artistName.isNotEmpty) {
          final tracks = await (_repository as dynamic).getTopTracksByArtist(artistName);
          emit(state.copyWith(
            tracks: tracks,
            isLoadingTracks: false,
            isTagSearch: false,
          ));
          return;
        }
      }

      // Check if query starts with duration: for duration filter
      if (query.toLowerCase().startsWith('duration:') && query.length > 9) {
        final durationQuery = query.substring(9).trim();
        if (durationQuery.isNotEmpty) {
          // Get popular tracks and filter by duration
          final allTracks = await _repository.getPopularTracks();
          final filteredTracks = _filterTracksByDuration(allTracks, durationQuery);
          emit(state.copyWith(
            tracks: filteredTracks,
            isLoadingTracks: false,
            isTagSearch: false,
          ));
          return;
        }
      }

      // Regular track search
      final tracks = await _repository.searchTracks(query);
      emit(state.copyWith(
        tracks: tracks,
        isLoadingTracks: false,
        isTagSearch: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoadingTracks: false,
      ));
    }
  }

  List<Track> _filterTracksByDuration(List<Track> tracks, String durationQuery) {
    // Parse duration query (e.g., "3:00", ">5:00", "<2:30", "4:00-6:00")

    // Range query (e.g., "3:00-5:00")
    if (durationQuery.contains('-')) {
      final parts = durationQuery.split('-');
      if (parts.length == 2) {
        final minSeconds = _parseDurationToSeconds(parts[0].trim());
        final maxSeconds = _parseDurationToSeconds(parts[1].trim());
        if (minSeconds != null && maxSeconds != null) {
          return tracks.where((track) {
            final trackSeconds = _parseDurationToSeconds(track.duration);
            return trackSeconds != null &&
                   trackSeconds >= minSeconds &&
                   trackSeconds <= maxSeconds;
          }).toList();
        }
      }
    }

    // Greater than query (e.g., ">5:00")
    if (durationQuery.startsWith('>')) {
      final targetSeconds = _parseDurationToSeconds(durationQuery.substring(1).trim());
      if (targetSeconds != null) {
        return tracks.where((track) {
          final trackSeconds = _parseDurationToSeconds(track.duration);
          return trackSeconds != null && trackSeconds > targetSeconds;
        }).toList();
      }
    }

    // Less than query (e.g., "<2:30")
    if (durationQuery.startsWith('<')) {
      final targetSeconds = _parseDurationToSeconds(durationQuery.substring(1).trim());
      if (targetSeconds != null) {
        return tracks.where((track) {
          final trackSeconds = _parseDurationToSeconds(track.duration);
          return trackSeconds != null && trackSeconds < targetSeconds;
        }).toList();
      }
    }

    // Exact duration query (e.g., "3:00")
    final targetSeconds = _parseDurationToSeconds(durationQuery);
    if (targetSeconds != null) {
      // Allow ±10 seconds tolerance for exact match
      return tracks.where((track) {
        final trackSeconds = _parseDurationToSeconds(track.duration);
        return trackSeconds != null &&
               (trackSeconds - targetSeconds).abs() <= 10;
      }).toList();
    }

    return tracks;
  }

  int? _parseDurationToSeconds(String duration) {
    final parts = duration.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]);
      final seconds = int.tryParse(parts[1]);
      if (minutes != null && seconds != null) {
        return minutes * 60 + seconds;
      }
    }
    return null;
  }

  Future<void> searchArtists(String query) async {
    emit(state.copyWith(
      isLoadingArtists: true,
      error: null,
      showTracksInArtistsTab: false,
      artistTabTracks: [],
    ));

    try {
      // Check if query starts with artisttop: to get top tracks by artist
      if (query.toLowerCase().startsWith('artisttop:') && query.length > 10) {
        final artistName = query.substring(10).trim();
        if (artistName.isNotEmpty) {
          // Get top tracks for the artist and show them in artists tab
          final tracks = await (_repository as dynamic).getTopTracksByArtist(artistName);
          emit(state.copyWith(
            artistTabTracks: tracks,
            isLoadingArtists: false,
            showTracksInArtistsTab: true,
            artists: [], // Clear artists list
          ));
          return;
        }
      }

      // Regular artist search
      final artists = await _repository.searchArtists(query);
      emit(state.copyWith(
        artists: artists,
        isLoadingArtists: false,
        showTracksInArtistsTab: false,
        artistTabTracks: [],
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
      final tracks = await _repository.getPopularTracks();
      emit(state.copyWith(
        tracks: tracks,
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
      final artists = await _repository.getTrendingArtists();
      emit(state.copyWith(
        artists: artists,
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
