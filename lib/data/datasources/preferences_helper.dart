import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static final PreferencesHelper instance = PreferencesHelper._init();
  static SharedPreferences? _prefs;

  PreferencesHelper._init();

  Future<SharedPreferences> get preferences async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Настройки темы
  Future<void> setThemeMode(String themeMode) async {
    final prefs = await preferences;
    await prefs.setString('theme_mode', themeMode);
  }

  Future<String?> getThemeMode() async {
    final prefs = await preferences;
    return prefs.getString('theme_mode');
  }

  // Статус пользователя
  Future<void> setUserStatus(String status) async {
    final prefs = await preferences;
    await prefs.setString('user_status', status);
  }

  Future<String?> getUserStatus() async {
    final prefs = await preferences;
    return prefs.getString('user_status');
  }

  // Общее время прослушивания
  Future<void> setTotalPlaytime(int minutes) async {
    final prefs = await preferences;
    await prefs.setInt('total_playtime', minutes);
  }

  Future<int> getTotalPlaytime() async {
    final prefs = await preferences;
    return prefs.getInt('total_playtime') ?? 0;
  }

  Future<void> incrementPlaytime(int minutes) async {
    final current = await getTotalPlaytime();
    await setTotalPlaytime(current + minutes);
  }

  // Настройки плеера
  Future<void> setShuffleEnabled(bool enabled) async {
    final prefs = await preferences;
    await prefs.setBool('shuffle_enabled', enabled);
  }

  Future<bool> getShuffleEnabled() async {
    final prefs = await preferences;
    return prefs.getBool('shuffle_enabled') ?? false;
  }

  Future<void> setRepeatMode(String mode) async {
    final prefs = await preferences;
    await prefs.setString('repeat_mode', mode);
  }

  Future<String> getRepeatMode() async {
    final prefs = await preferences;
    return prefs.getString('repeat_mode') ?? 'none';
  }

  // Кэшированные данные
  Future<void> setLastPlayedTrackId(int? trackId) async {
    final prefs = await preferences;
    if (trackId != null) {
      await prefs.setInt('last_played_track_id', trackId);
    } else {
      await prefs.remove('last_played_track_id');
    }
  }

  Future<int?> getLastPlayedTrackId() async {
    final prefs = await preferences;
    return prefs.getInt('last_played_track_id');
  }

  Future<void> setLastPlayedPlaylistId(int? playlistId) async {
    final prefs = await preferences;
    if (playlistId != null) {
      await prefs.setInt('last_played_playlist_id', playlistId);
    } else {
      await prefs.remove('last_played_playlist_id');
    }
  }

  Future<int?> getLastPlayedPlaylistId() async {
    final prefs = await preferences;
    return prefs.getInt('last_played_playlist_id');
  }

  // Очистка всех данных
  Future<void> clearAll() async {
    final prefs = await preferences;
    await prefs.clear();
  }
}
