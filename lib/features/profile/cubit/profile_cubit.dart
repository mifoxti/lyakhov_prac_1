import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileState {
  final String status;
  final int totalPlaytimeMinutes;
  final List<Map<String, dynamic>> playlists;
  final String profileImageUrl;

  const ProfileState({
    this.status = 'Онлайн',
    this.totalPlaytimeMinutes = 0,
    this.playlists = const [],
    this.profileImageUrl = 'https://i.pinimg.com/736x/0a/ba/41/0aba4155e6ae9d116d25bf83c4eac798.jpg',
  });

  int get playlistCount => playlists.length;

  ProfileState copyWith({
    String? status,
    int? totalPlaytimeMinutes,
    List<Map<String, dynamic>>? playlists,
    String? profileImageUrl,
  }) {
    return ProfileState(
      status: status ?? this.status,
      totalPlaytimeMinutes: totalPlaytimeMinutes ?? this.totalPlaytimeMinutes,
      playlists: playlists ?? this.playlists,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState()) {
    _initializeData();
  }

  int _nextId = 6;

  void _initializeData() {
    final initialPlaylists = [
      {'id': 1, 'name': 'Любимые треки', 'count': 125},
      {'id': 2, 'name': 'Топ 2025', 'count': 50},
      {'id': 3, 'name': 'Для релакса', 'count': 30},
      {'id': 4, 'name': 'Тренировка', 'count': 45},
      {'id': 5, 'name': 'Дорожные хиты', 'count': 60},
    ];

    emit(state.copyWith(
      playlists: initialPlaylists,
      totalPlaytimeMinutes: 1280,
    ));
  }

  void changeStatus(String newStatus) {
    emit(state.copyWith(status: newStatus));
  }

  void updatePlaytime(int minutes) {
    emit(state.copyWith(totalPlaytimeMinutes: minutes));
  }

  void addPlaylist(String name) {
    final newPlaylist = {
      'id': _nextId++,
      'name': name,
      'count': 0,
    };
    final updatedPlaylists = List<Map<String, dynamic>>.from(state.playlists)..add(newPlaylist);
    emit(state.copyWith(playlists: updatedPlaylists));
  }

  void updatePlaylist(int index, String newName) {
    final updatedPlaylists = List<Map<String, dynamic>>.from(state.playlists);
    updatedPlaylists[index] = {...updatedPlaylists[index], 'name': newName};
    emit(state.copyWith(playlists: updatedPlaylists));
  }

  void removePlaylist(int index) {
    final updatedPlaylists = List<Map<String, dynamic>>.from(state.playlists);
    updatedPlaylists.removeAt(index);
    emit(state.copyWith(playlists: updatedPlaylists));
  }

  void updateProfileImage(String imageUrl) {
    emit(state.copyWith(profileImageUrl: imageUrl));
  }

  void incrementPlaytime() {
    emit(state.copyWith(totalPlaytimeMinutes: state.totalPlaytimeMinutes + 1));
  }
}