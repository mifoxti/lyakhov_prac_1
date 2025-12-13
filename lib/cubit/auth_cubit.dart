import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/datasources/secure_storage_helper.dart';

class AuthState {
  final bool isAuthorized;
  final String? login;
  final bool isLoading;

  const AuthState({
    this.isAuthorized = false,
    this.login,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthorized,
    String? login,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthorized: isAuthorized ?? this.isAuthorized,
      login: login ?? this.login,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    emit(state.copyWith(isLoading: true));
    try {
      final savedLogin = await SecureStorageHelper.instance.getLogin();
      if (savedLogin != null && savedLogin.isNotEmpty) {
        emit(state.copyWith(
          isAuthorized: true,
          login: savedLogin,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> login(String login, String password) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Имитация проверки учетных данных
      await Future.delayed(const Duration(seconds: 1));

      // В реальном приложении здесь была бы проверка с сервером
      // Для демонстрации сохраняем данные
      await SecureStorageHelper.instance.setLogin(login);
      await SecureStorageHelper.instance.setPassword(password);

      // Сохраняем логин как отображаемое имя, если имя не было сохранено ранее для этого пользователя
      final existingName = await SecureStorageHelper.instance.storage.read(key: 'display_name_$login');
      print('AuthCubit: Login $login - existing name: $existingName');
      if (existingName == null || existingName.isEmpty) {
        await SecureStorageHelper.instance.storage.write(key: 'display_name_$login', value: login);
        print('AuthCubit: Set default name to $login');
      } else {
        print('AuthCubit: Keeping existing name $existingName');
      }

      emit(state.copyWith(
        isAuthorized: true,
        login: login,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      rethrow;
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));
    try {
      // Очищаем сохраненные данные аутентификации
      await SecureStorageHelper.instance.clearAllAuthData();
      // НЕ очищаем display name - оно должно сохраняться для каждого пользователя индивидуально

      emit(const AuthState());
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      rethrow;
    }
  }

  Future<void> updateLogin(String newLogin) async {
    if (state.isAuthorized) {
      await SecureStorageHelper.instance.setLogin(newLogin);
      emit(state.copyWith(login: newLogin));
    }
  }
}
