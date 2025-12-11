import 'package:flutter_bloc/flutter_bloc.dart';

class RadioStation {
  final int id;
  final String name;
  final String genre;
  final String frequency;
  final String description;
  final String imageUrl;
  final bool isPlaying;

  RadioStation({
    required this.id,
    required this.name,
    required this.genre,
    required this.frequency,
    required this.description,
    this.imageUrl = '',
    this.isPlaying = false,
  });

  RadioStation copyWith({
    int? id,
    String? name,
    String? genre,
    String? frequency,
    String? description,
    String? imageUrl,
    bool? isPlaying,
  }) {
    return RadioStation(
      id: id ?? this.id,
      name: name ?? this.name,
      genre: genre ?? this.genre,
      frequency: frequency ?? this.frequency,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

class RadioState {
  final List<RadioStation> stations;
  final RadioStation? currentStation;
  final bool isLoading;

  const RadioState({
    this.stations = const [],
    this.currentStation,
    this.isLoading = false,
  });

  RadioState copyWith({
    List<RadioStation>? stations,
    RadioStation? currentStation,
    bool? isLoading,
  }) {
    return RadioState(
      stations: stations ?? this.stations,
      currentStation: currentStation ?? this.currentStation,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get stationCount => stations.length;
}

class RadioCubit extends Cubit<RadioState> {
  RadioCubit() : super(const RadioState()) {
    _loadInitialStations();
  }

  void _loadInitialStations() {
    final stations = [
      RadioStation(
        id: 1,
        name: 'Relax FM',
        genre: 'Релакс, Чиллаут',
        frequency: '90.8 FM',
        description: 'Музыка для души и отдыха',
        imageUrl: 'https://avatars.yandex.net/get-music-content/8871144/f89b7a5e.a.28012653-1/m1000x1000',
      ),
      RadioStation(
        id: 2,
        name: 'Energy FM',
        genre: 'Танцевальная музыка',
        frequency: '104.2 FM',
        description: 'Лучшая танцевальная музыка 24/7',
        imageUrl: 'https://avatars.yandex.net/get-music-content/5878012/8e3c9f5d.a.24165301-1/m1000x1000',
      ),
      RadioStation(
        id: 3,
        name: 'Rock Radio',
        genre: 'Рок',
        frequency: '97.5 FM',
        description: 'Классический и современный рок',
        imageUrl: 'https://avatars.yandex.net/get-music-content/6213021/5d9e8c2a.a.22785701-1/m1000x1000',
      ),
      RadioStation(
        id: 4,
        name: 'Jazz FM',
        genre: 'Джаз, Блюз',
        frequency: '101.1 FM',
        description: 'Изысканный джаз и блюз',
        imageUrl: 'https://avatars.yandex.net/get-music-content/5879772/9f4d6e3b.a.24236501-1/m1000x1000',
      ),
      RadioStation(
        id: 5,
        name: 'Hit FM',
        genre: 'Поп, Хиты',
        frequency: '107.4 FM',
        description: 'Только хиты, только сейчас',
        imageUrl: 'https://avatars.yandex.net/get-music-content/8871144/a2b3c4d5.a.29012653-1/m1000x1000',
      ),
      RadioStation(
        id: 6,
        name: 'Classical Radio',
        genre: 'Классическая музыка',
        frequency: '93.3 FM',
        description: 'Лучшие произведения классической музыки',
        imageUrl: 'https://avatars.yandex.net/get-music-content/6213021/7e8f9a0b.a.23785701-1/m1000x1000',
      ),
    ];

    emit(RadioState(
      stations: stations,
      currentStation: stations.first,
    ));
  }

  void selectStation(int index) {
    if (index >= 0 && index < state.stations.length) {
      final updatedStations = state.stations.map((station) {
        return station.copyWith(isPlaying: false);
      }).toList();

      final selectedStation = updatedStations[index].copyWith(isPlaying: true);
      updatedStations[index] = selectedStation;

      emit(state.copyWith(
        stations: updatedStations,
        currentStation: selectedStation,
      ));
    }
  }

  void togglePlayPause() {
    if (state.currentStation != null) {
      final updatedStation = state.currentStation!.copyWith(
        isPlaying: !state.currentStation!.isPlaying,
      );
      final updatedStations = state.stations.map((station) {
        return station.id == updatedStation.id ? updatedStation : station.copyWith(isPlaying: false);
      }).toList();

      emit(state.copyWith(
        stations: updatedStations,
        currentStation: updatedStation,
      ));
    }
  }

  void addToFavorites(int stationId) {
    // Заглушка для добавления в избранное
  }
}
