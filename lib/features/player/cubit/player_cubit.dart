import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/player_model.dart';

class PlayerState {
  final List<Track> tracks;
  final int currentIndex;
  final Track? recentlyDeleted;
  final int? recentlyDeletedIndex;

  const PlayerState({
    this.tracks = const [],
    this.currentIndex = 0,
    this.recentlyDeleted,
    this.recentlyDeletedIndex,
  });

  Track? get currentTrack => tracks.isEmpty ? null : tracks[currentIndex];
  int get nextTracksCount => tracks.length - currentIndex - 1;

  PlayerState copyWith({
    List<Track>? tracks,
    int? currentIndex,
    Track? recentlyDeleted,
    int? recentlyDeletedIndex,
  }) {
    return PlayerState(
      tracks: tracks ?? this.tracks,
      currentIndex: currentIndex ?? this.currentIndex,
      recentlyDeleted: recentlyDeleted ?? this.recentlyDeleted,
      recentlyDeletedIndex: recentlyDeletedIndex ?? this.recentlyDeletedIndex,
    );
  }
}

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit() : super(const PlayerState());

  void initializeTracks(List<Track> initialTracks) {
    emit(state.copyWith(tracks: initialTracks));
  }

  void addTrack(Track track) {
    final updatedTracks = List<Track>.from(state.tracks)..add(track);
    emit(state.copyWith(tracks: updatedTracks));
  }

  void updateTrack(int index, Track updatedTrack) {
    if (index >= 0 && index < state.tracks.length) {
      final updatedTracks = List<Track>.from(state.tracks);
      updatedTracks[index] = updatedTrack;
      emit(state.copyWith(tracks: updatedTracks));
    }
  }

  void removeTrack(int index) {
    if (index >= 0 && index < state.tracks.length) {
      final updatedTracks = List<Track>.from(state.tracks);
      final deletedTrack = updatedTracks.removeAt(index);

      int newCurrentIndex = state.currentIndex;
      if (index == state.currentIndex) {
        newCurrentIndex = updatedTracks.isEmpty ? 0 : 0;
      } else if (index < state.currentIndex) {
        newCurrentIndex = state.currentIndex - 1;
      }

      if (newCurrentIndex >= updatedTracks.length) {
        newCurrentIndex = updatedTracks.isEmpty ? 0 : updatedTracks.length - 1;
      }

      emit(state.copyWith(
        tracks: updatedTracks,
        currentIndex: newCurrentIndex,
        recentlyDeleted: deletedTrack,
        recentlyDeletedIndex: index,
      ));
    }
  }

  void undoRemove() {
    if (state.recentlyDeleted != null && state.recentlyDeletedIndex != null) {
      final updatedTracks = List<Track>.from(state.tracks);
      updatedTracks.insert(state.recentlyDeletedIndex!, state.recentlyDeleted!);

      int newCurrentIndex = state.currentIndex;
      if (state.recentlyDeletedIndex! <= state.currentIndex) {
        newCurrentIndex = state.currentIndex + 1;
      }

      emit(state.copyWith(
        tracks: updatedTracks,
        currentIndex: newCurrentIndex,
        recentlyDeleted: null,
        recentlyDeletedIndex: null,
      ));
    }
  }

  void selectTrack(int index) {
    if (index >= 0 && index < state.tracks.length) {
      emit(state.copyWith(currentIndex: index));
    }
  }

  void nextTrack() {
    if (state.tracks.isEmpty) return;

    final nextIndex = (state.currentIndex + 1) % state.tracks.length;
    emit(state.copyWith(currentIndex: nextIndex));
  }
}