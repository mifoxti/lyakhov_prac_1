// lib/features/intro/cubit/intro_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

class IntroState {
  final String featuredTrackTitle;
  final String featuredArtist;

  const IntroState({
    this.featuredTrackTitle = 'Летние хиты',
    this.featuredArtist = 'MiMusic Top',
  });

  IntroState copyWith({
    String? featuredTrackTitle,
    String? featuredArtist,
  }) {
    return IntroState(
      featuredTrackTitle: featuredTrackTitle ?? this.featuredTrackTitle,
      featuredArtist: featuredArtist ?? this.featuredArtist,
    );
  }
}

class IntroCubit extends Cubit<IntroState> {
  IntroCubit() : super(const IntroState());

  void updateFeaturedTrack(String title, String artist) {
    emit(state.copyWith(
      featuredTrackTitle: title,
      featuredArtist: artist,
    ));
  }
}