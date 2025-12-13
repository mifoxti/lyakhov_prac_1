import '../../core/models/user.dart';
import 'secure_storage_helper.dart';

class UserLocalDataSource {
  final SecureStorageHelper _secureStorage = SecureStorageHelper.instance;

  Future<MusicUser> getCurrentUser() async {
    final login = await _secureStorage.getLogin();
    final userId = await _secureStorage.getUserId();

    return MusicUser(
      id: userId ?? 'music_user_001',
      login: login ?? 'music_lover',
      displayName: 'mifoxti',
      subscriptionType: 'Premium',
      profileImageUrl: 'https://i.pinimg.com/736x/0a/ba/41/0aba4155e6ae9d116d25bf83c4eac798.jpg',
      isPremiumUser: true,
    );
  }

  Future<void> updateLogin(String login) async {
    await _secureStorage.setLogin(login);
  }

  Future<void> updateUserInfo(String userId, String displayName) async {
    await _secureStorage.setUserId(userId);
    final prefs = await _secureStorage.storage;
    await prefs.write(key: 'display_name', value: displayName);
  }

  Future<void> clearUserData() async {
    await _secureStorage.clearAllAuthData();
  }

  Future<bool> isLoggedIn() async {
    return await _secureStorage.hasLoginCredentials();
  }

  Future<String?> getDisplayName() async {
    final prefs = await _secureStorage.storage;
    return await prefs.read(key: 'display_name');
  }
}
