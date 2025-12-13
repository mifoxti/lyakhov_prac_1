import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/service_locator.dart';
import '../../../core/models/track.dart';
import '../../../domain/usecases/tracks/add_track.dart';
import '../../../domain/usecases/tracks/get_tracks.dart';
import '../../../domain/usecases/tracks/remove_track.dart';
import '../../../domain/usecases/tracks/update_track.dart';

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
  final GetTracks getTracksUseCase;
  final AddTrack addTrackUseCase;
  final UpdateTrack updateTrackUseCase;
  final RemoveTrack removeTrackUseCase;

  PlayerCubit()
      : getTracksUseCase = locator<GetTracks>(),
        addTrackUseCase = locator<AddTrack>(),
        updateTrackUseCase = locator<UpdateTrack>(),
        removeTrackUseCase = locator<RemoveTrack>(),
        super(const PlayerState()) {
    print('Создан PlayerCubit');
    _initialize();
  }

  Future<void> _initialize() async {
    await loadTracks();
  }

  Future<void> loadTracks() async {
    try {
      final tracks = await getTracksUseCase.call();
      emit(state.copyWith(tracks: tracks));
    } catch (e) {
      // Handle error
    }
  }

  void initializeTracks(List<Track> initialTracks) {
    emit(state.copyWith(tracks: initialTracks));
  }

  Future<void> addTrack(Track track) async {
    try {
      await addTrackUseCase.call(track);
      await loadTracks();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateTrack(int id, Track updatedTrack) async {
    try {
      await updateTrackUseCase.call(id, updatedTrack);
      await loadTracks();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> removeTrack(int id) async {
    try {
      // Найдем индекс удаляемого трека
      final trackIndex = state.tracks.indexWhere((track) => track.id == id);
      if (trackIndex != -1) {
        final trackToDelete = state.tracks[trackIndex];
        final wasCurrentTrack = trackIndex == state.currentIndex;
        final wasBeforeCurrent = trackIndex < state.currentIndex;

        // Удаляем трек
        await removeTrackUseCase.call(id);

        // Загружаем обновленный список
        final updatedTracks = await getTracksUseCase.call();

        // Корректируем currentIndex
        int newCurrentIndex = state.currentIndex;
        if (wasCurrentTrack && updatedTracks.isNotEmpty) {
          // Если удаляли текущий трек, выбираем следующий или последний
          newCurrentIndex = trackIndex < updatedTracks.length ? trackIndex : updatedTracks.length - 1;
        } else if (wasBeforeCurrent) {
          // Если удаляли трек перед текущим, сдвигаем индекс назад
          newCurrentIndex = state.currentIndex - 1;
        }

        // Убеждаемся, что индекс валиден
        if (newCurrentIndex >= updatedTracks.length) {
          newCurrentIndex = updatedTracks.isNotEmpty ? updatedTracks.length - 1 : 0;
        }
        if (newCurrentIndex < 0) {
          newCurrentIndex = 0;
        }

        emit(state.copyWith(
          tracks: updatedTracks,
          currentIndex: newCurrentIndex,
          recentlyDeleted: trackToDelete,
          recentlyDeletedIndex: trackIndex,
        ));
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> undoRemove() async {
    if (state.recentlyDeleted != null && state.recentlyDeletedIndex != null) {
      try {
        // Добавляем трек обратно в базу данных
        await addTrackUseCase.call(state.recentlyDeleted!);

        // Загружаем обновленный список
        final updatedTracks = await getTracksUseCase.call();

        // Корректируем currentIndex
        int newCurrentIndex = state.currentIndex;
        if (state.recentlyDeletedIndex! <= state.currentIndex) {
          newCurrentIndex = state.currentIndex + 1;
        }

        // Убеждаемся, что индекс валиден
        if (newCurrentIndex >= updatedTracks.length) {
          newCurrentIndex = updatedTracks.length - 1;
        }

        emit(state.copyWith(
          tracks: updatedTracks,
          currentIndex: newCurrentIndex,
          recentlyDeleted: null,
          recentlyDeletedIndex: null,
        ));
      } catch (e) {
        // Handle error
      }
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
