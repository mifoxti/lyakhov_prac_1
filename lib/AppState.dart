import 'package:flutter/material.dart';

class AppState extends InheritedWidget {
  final int totalPlaytimeMinutes;
  final bool isPremiumUser;
  final String currentTheme;

  const AppState({
    super.key,
    required this.totalPlaytimeMinutes,
    required this.isPremiumUser,
    required this.currentTheme,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppState>();
    assert(result != null, 'No AppState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant AppState oldWidget) {
    return totalPlaytimeMinutes != oldWidget.totalPlaytimeMinutes ||
        isPremiumUser != oldWidget.isPremiumUser ||
        currentTheme != oldWidget.currentTheme;
  }
}
