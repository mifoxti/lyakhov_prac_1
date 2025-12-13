import 'dart:convert';
import '../../core/models/user_profile.dart';
import 'preferences_helper.dart';

class UserProfileLocalDataSource {
  final PreferencesHelper _preferencesHelper = PreferencesHelper.instance;

  Future<UserProfile> getUserProfile() async {
    final savedStatus = await _preferencesHelper.getUserStatus();
    final savedPlaytime = await _preferencesHelper.getTotalPlaytime();
    final savedImageUrl = await _getProfileImageUrl();

    return UserProfile(
      name: 'Тимофей Ляхов',
      institute: 'МИРЭА - Российский технологический университет',
      group: 'ИКБО-06-22',
      course: 4,
      profileImageUrl: savedImageUrl,
      status: savedStatus ?? 'Онлайн',
      totalPlaytimeMinutes: savedPlaytime,
      scientificActivities: await _getScientificActivities(),
    );
  }

  Future<String> _getProfileImageUrl() async {
    final prefs = await _preferencesHelper.preferences;
    return prefs.getString('profile_image_url') ?? 'https://i.pinimg.com/736x/0a/ba/41/0aba4155e6ae9d116d25bf83c4eac798.jpg';
  }

  Future<List<String>> _getScientificActivities() async {
    final prefs = await _preferencesHelper.preferences;
    final activitiesJson = prefs.getString('scientific_activities');
    if (activitiesJson != null) {
      final List<dynamic> decoded = json.decode(activitiesJson);
      return decoded.cast<String>();
    } else {
      // Возвращаем дефолтные активности при первом запуске
      final defaultActivities = [
        'Участие в хакатоне "Цифровой прорыв" - 2024',
        'Публикация статьи "Разработка кроссплатформенных приложений" - 2024',
        'Проект "MiMusic" - музыкальное приложение на Flutter - 2025',
      ];
      await _saveScientificActivities(defaultActivities);
      return defaultActivities;
    }
  }

  Future<void> _saveScientificActivities(List<String> activities) async {
    final prefs = await _preferencesHelper.preferences;
    final activitiesJson = json.encode(activities);
    await prefs.setString('scientific_activities', activitiesJson);
  }

  Future<void> updateStatus(String status) async {
    await _preferencesHelper.setUserStatus(status);
  }

  Future<void> updatePlaytime(int minutes) async {
    await _preferencesHelper.setTotalPlaytime(minutes);
  }

  Future<void> incrementPlaytime(int minutes) async {
    await _preferencesHelper.incrementPlaytime(minutes);
  }

  Future<void> updateProfileImage(String imageUrl) async {
    final prefs = await _preferencesHelper.preferences;
    await prefs.setString('profile_image_url', imageUrl);
  }

  Future<void> updateScientificActivities(List<String> activities) async {
    await _saveScientificActivities(activities);
  }

  Future<void> addScientificActivity(String activity) async {
    final currentActivities = await _getScientificActivities();
    currentActivities.add(activity);
    await _saveScientificActivities(currentActivities);
  }

  Future<void> removeScientificActivity(int index) async {
    final currentActivities = await _getScientificActivities();
    if (index >= 0 && index < currentActivities.length) {
      currentActivities.removeAt(index);
      await _saveScientificActivities(currentActivities);
    }
  }
}
