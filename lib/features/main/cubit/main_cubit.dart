import 'package:flutter_bloc/flutter_bloc.dart';

class MainState {
  final String currentTrackTitle;
  final String currentArtist;
  final bool isSharedMode;
  final int participantsCount;

  const MainState({
    this.currentTrackTitle = 'Не выбрано',
    this.currentArtist = 'Неизвестен',
    this.isSharedMode = false,
    this.participantsCount = 1,
  });

  MainState copyWith({
    String? currentTrackTitle,
    String? currentArtist,
    bool? isSharedMode,
    int? participantsCount,
  }) {
    return MainState(
      currentTrackTitle: currentTrackTitle ?? this.currentTrackTitle,
      currentArtist: currentArtist ?? this.currentArtist,
      isSharedMode: isSharedMode ?? this.isSharedMode,
      participantsCount: participantsCount ?? this.participantsCount,
    );
  }
}

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState(
    currentTrackTitle: 'Тишина',
    currentArtist: 'Система',
    isSharedMode: false,
    participantsCount: 1,
  ));

  void updateCurrentTrack(String title, String artist) {
    emit(state.copyWith(currentTrackTitle: title, currentArtist: artist));
  }

  void toggleSharedMode() {
    emit(state.copyWith(isSharedMode: !state.isSharedMode));
  }

  void updateParticipants(int count) {
    if (count >= 1) {
      emit(state.copyWith(participantsCount: count));
    }
  }

  void resetToDefault() {
    emit(const MainState());
  }
}