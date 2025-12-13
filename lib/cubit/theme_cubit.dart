import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/datasources/preferences_helper.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

class ThemeState {
  final AppThemeMode themeMode;
  final bool isDarkMode;

  const ThemeState({
    required this.themeMode,
    required this.isDarkMode,
  });

  ThemeState copyWith({
    AppThemeMode? themeMode,
    bool? isDarkMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  ThemeMode get materialThemeMode {
    switch (themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(const ThemeState(
          themeMode: AppThemeMode.light,
          isDarkMode: false,
        ));

  Future<void> setThemeMode(AppThemeMode mode, {bool? systemIsDark}) async {
    bool isDark = false;

    switch (mode) {
      case AppThemeMode.light:
        isDark = false;
        break;
      case AppThemeMode.dark:
        isDark = true;
        break;
      case AppThemeMode.system:
        isDark = systemIsDark ?? false;
        break;
    }

    emit(state.copyWith(
      themeMode: mode,
      isDarkMode: isDark,
    ));

    // Сохраняем в SharedPreferences
    await PreferencesHelper.instance.setThemeMode(mode.name);
  }

  Future<void> loadSavedTheme() async {
    final savedTheme = await PreferencesHelper.instance.getThemeMode();
    if (savedTheme != null) {
      final mode = AppThemeMode.values.firstWhere(
        (mode) => mode.name == savedTheme,
        orElse: () => AppThemeMode.light,
      );
      await setThemeMode(mode);
    }
  }

  void toggleTheme() {
    if (state.themeMode == AppThemeMode.dark) {
      setThemeMode(AppThemeMode.light);
    } else {
      setThemeMode(AppThemeMode.dark);
    }
  }

  void setLightTheme() {
    setThemeMode(AppThemeMode.light);
  }

  void setDarkTheme() {
    setThemeMode(AppThemeMode.dark);
  }

  void setSystemTheme(bool systemIsDark) {
    setThemeMode(AppThemeMode.system, systemIsDark: systemIsDark);
  }

  String getThemeModeName() {
    switch (state.themeMode) {
      case AppThemeMode.light:
        return 'Светлая';
      case AppThemeMode.dark:
        return 'Темная';
      case AppThemeMode.system:
        return 'Системная';
    }
  }
}
