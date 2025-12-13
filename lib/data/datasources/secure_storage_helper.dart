import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static final SecureStorageHelper instance = SecureStorageHelper._init();
  static FlutterSecureStorage? _storage;

  SecureStorageHelper._init();

  FlutterSecureStorage get storage {
    _storage ??= const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
    return _storage!;
  }

  // Аутентификация пользователя
  Future<void> setLogin(String login) async {
    await storage.write(key: 'user_login', value: login);
  }

  Future<String?> getLogin() async {
    return await storage.read(key: 'user_login');
  }

  Future<void> setPassword(String password) async {
    await storage.write(key: 'user_password', value: password);
  }

  Future<String?> getPassword() async {
    return await storage.read(key: 'user_password');
  }

  // Токены авторизации
  Future<void> setAuthToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getAuthToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<void> setRefreshToken(String token) async {
    await storage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  // Пользовательские данные
  Future<void> setUserId(String userId) async {
    await storage.write(key: 'user_id', value: userId);
  }

  Future<String?> getUserId() async {
    return await storage.read(key: 'user_id');
  }

  Future<void> setUserEmail(String email) async {
    await storage.write(key: 'user_email', value: email);
  }

  Future<String?> getUserEmail() async {
    return await storage.read(key: 'user_email');
  }

  // Настройки безопасности
  Future<void> setBiometricEnabled(bool enabled) async {
    await storage.write(key: 'biometric_enabled', value: enabled.toString());
  }

  Future<bool> getBiometricEnabled() async {
    final value = await storage.read(key: 'biometric_enabled');
    return value == 'true';
  }

  Future<void> setAutoLockEnabled(bool enabled) async {
    await storage.write(key: 'auto_lock_enabled', value: enabled.toString());
  }

  Future<bool> getAutoLockEnabled() async {
    final value = await storage.read(key: 'auto_lock_enabled');
    return value == 'true';
  }

  // Удаление данных
  Future<void> deleteLogin() async {
    await storage.delete(key: 'user_login');
  }

  Future<void> deletePassword() async {
    await storage.delete(key: 'user_password');
  }

  Future<void> deleteAuthToken() async {
    await storage.delete(key: 'auth_token');
  }

  Future<void> deleteRefreshToken() async {
    await storage.delete(key: 'refresh_token');
  }

  Future<void> clearAllAuthData() async {
    await deleteLogin();
    await deletePassword();
    await deleteAuthToken();
    await deleteRefreshToken();
    await storage.delete(key: 'user_id');
    await storage.delete(key: 'user_email');
  }

  // Проверка наличия данных
  Future<bool> hasAuthToken() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> hasLoginCredentials() async {
    final login = await getLogin();
    final password = await getPassword();
    return login != null && password != null && login.isNotEmpty && password.isNotEmpty;
  }
}
