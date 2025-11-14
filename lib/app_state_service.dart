import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

class AppStateService {
  int totalPlaytimeMinutes = 142;
  bool isPremiumUser = true;
  String currentTheme = 'dark';

  void setTotalPlaytimeMinutes(int newTime) {
    totalPlaytimeMinutes = newTime;
  }

  void setIsPremiumUser(bool isPremium) {
    isPremiumUser = isPremium;
  }

  void setCurrentTheme(String theme) {
    currentTheme = theme;
  }

  void setupLocator() {
    locator.registerSingleton<AppStateService>(AppStateService());
  }
}
