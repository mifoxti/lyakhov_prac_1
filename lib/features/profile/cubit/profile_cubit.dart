import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/playlist.dart';
import '../../../cubit/service_locator.dart';
import '../../../data/datasources/preferences_helper.dart';
import '../../../data/datasources/secure_storage_helper.dart' as secure_storage;
import '../../../domain/usecases/playlists/create_playlist.dart';
import '../../../domain/usecases/playlists/delete_playlist.dart';
import '../../../domain/usecases/playlists/get_playlists.dart';
import '../../../domain/usecases/playlists/update_playlist.dart';

class ProfileState {
  final String status;
  final int totalPlaytimeMinutes;
  final List<Playlist> playlists;
  final String profileImageUrl;
  final String displayName;

  const ProfileState({
    this.status = 'Онлайн',
    this.totalPlaytimeMinutes = 0,
    this.playlists = const [],
    this.profileImageUrl = 'https://i.pinimg.com/736x/0a/ba/41/0aba4155e6ae9d116d25bf83c4eac798.jpg',
    this.displayName = 'Тимофей Ляхов',
  });

  int get playlistCount => playlists.length;

  ProfileState copyWith({
    String? status,
    int? totalPlaytimeMinutes,
    List<Playlist>? playlists,
    String? profileImageUrl,
    String? displayName,
  }) {
    return ProfileState(
      status: status ?? this.status,
      totalPlaytimeMinutes: totalPlaytimeMinutes ?? this.totalPlaytimeMinutes,
      playlists: playlists ?? this.playlists,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      displayName: displayName ?? this.displayName,
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  final GetPlaylists getPlaylistsUseCase;
  final CreatePlaylist createPlaylistUseCase;
  final UpdatePlaylist updatePlaylistUseCase;
  final DeletePlaylist deletePlaylistUseCase;

  ProfileCubit()
      : getPlaylistsUseCase = locator<GetPlaylists>(),
        createPlaylistUseCase = locator<CreatePlaylist>(),
        updatePlaylistUseCase = locator<UpdatePlaylist>(),
        deletePlaylistUseCase = locator<DeletePlaylist>(),
        super(const ProfileState()) {
    print('Создан ProfileCubit');
    _initialize();
  }

  Future<void> _initialize() async {
    await loadProfileData();
    await loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    try {
      final playlists = await getPlaylistsUseCase.call();
      emit(state.copyWith(playlists: playlists));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> changeStatus(String newStatus) async {
    emit(state.copyWith(status: newStatus));
    await PreferencesHelper.instance.setUserStatus(newStatus);
  }

  Future<void> updatePlaytime(int minutes) async {
    emit(state.copyWith(totalPlaytimeMinutes: minutes));
    await PreferencesHelper.instance.setTotalPlaytime(minutes);
  }

  Future<void> loadProfileData() async {
    final savedStatus = await PreferencesHelper.instance.getUserStatus();
    final savedPlaytime = await PreferencesHelper.instance.getTotalPlaytime();

    // Загружаем сохраненное имя для текущего пользователя из secure storage
    final currentUserLogin = await secure_storage.SecureStorageHelper.instance.getLogin();
    final savedName = await secure_storage.SecureStorageHelper.instance.storage.read(key: 'display_name_$currentUserLogin');

    // Загружаем сохраненное изображение профиля
    final savedImageUrl = await secure_storage.SecureStorageHelper.instance.storage.read(key: 'profile_image_$currentUserLogin');

    print('ProfileCubit: Loading data for user $currentUserLogin');
    print('ProfileCubit: Saved name: $savedName');
    print('ProfileCubit: Saved image: $savedImageUrl');

    final newDisplayName = savedName ?? currentUserLogin ?? state.displayName;
    final newImageUrl = savedImageUrl ?? state.profileImageUrl;

    print('ProfileCubit: Using display name: $newDisplayName');

    emit(state.copyWith(
      status: savedStatus ?? state.status,
      totalPlaytimeMinutes: savedPlaytime,
      displayName: newDisplayName,
      profileImageUrl: newImageUrl,
    ));
  }

  Future<void> addPlaylist(String name) async {
    try {
      final newPlaylist = Playlist(name: name);
      await createPlaylistUseCase.call(newPlaylist);
      await loadPlaylists();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updatePlaylist(int index, String newName) async {
    try {
      final playlist = state.playlists[index];
      final updatedPlaylist = playlist.copyWith(name: newName);
      await updatePlaylistUseCase.call(playlist.id!, updatedPlaylist);
      await loadPlaylists();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> removePlaylist(int index) async {
    try {
      final playlist = state.playlists[index];
      await deletePlaylistUseCase.call(playlist.id!);
      await loadPlaylists();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateProfileImage(String imageUrl) async {
    emit(state.copyWith(profileImageUrl: imageUrl));
    // Сохраняем в secure storage для текущего пользователя
    final prefs = await secure_storage.SecureStorageHelper.instance.storage;
    final currentUserLogin = await secure_storage.SecureStorageHelper.instance.getLogin();
    await prefs.write(key: 'profile_image_$currentUserLogin', value: imageUrl);
  }

  Future<void> updateDisplayName(String name) async {
    print('ProfileCubit: Updating display name to $name');
    emit(state.copyWith(displayName: name));
    // Сохраняем в secure storage для текущего пользователя
    final prefs = await secure_storage.SecureStorageHelper.instance.storage;
    final currentUserLogin = await secure_storage.SecureStorageHelper.instance.getLogin();
    final key = 'display_name_$currentUserLogin';
    print('ProfileCubit: Saving to key $key');
    await prefs.write(key: key, value: name);
    print('ProfileCubit: Saved successfully');
  }

  void incrementPlaytime() {
    emit(state.copyWith(totalPlaytimeMinutes: state.totalPlaytimeMinutes + 1));
  }
}
