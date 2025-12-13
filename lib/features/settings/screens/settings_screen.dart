import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../cubit/theme_cubit.dart';
import '../../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final primaryColor = AppTheme.getPrimaryColor(context);
        final backgroundColor = AppTheme.getBackgroundColor(context);
        final textColor = AppTheme.getTextColor(context);
        final isDark = AppTheme.isDarkMode(context);

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: const Text('Настройки'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildSectionHeader(context, 'Внешний вид', Icons.palette, textColor),
                const SizedBox(height: 15),
                _buildThemeSection(context, themeState, primaryColor, isDark),
                const SizedBox(height: 30),
                _buildSectionHeader(context, 'Аудио', Icons.volume_up, textColor),
                const SizedBox(height: 15),
                _buildAudioSection(context, primaryColor, isDark),
                const SizedBox(height: 30),
                _buildSectionHeader(context, 'Уведомления', Icons.notifications, textColor),
                const SizedBox(height: 15),
                _buildNotificationsSection(context, primaryColor, isDark, textColor),
                const SizedBox(height: 30),
                _buildSectionHeader(context, 'Аккаунт', Icons.person, textColor),
                const SizedBox(height: 15),
                _buildAccountSection(context, primaryColor, isDark, textColor),
                const SizedBox(height: 30),
                _buildSectionHeader(context, 'О приложении', Icons.info, textColor),
                const SizedBox(height: 15),
                _buildAboutSection(context, primaryColor, isDark, textColor),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: textColor.withOpacity(0.7), size: 24),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSection(
    BuildContext context,
    ThemeState themeState,
    Color primaryColor,
    bool isDark,
  ) {
    final textColor = AppTheme.getTextColor(context);
    final cubit = context.read<ThemeCubit>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingTile(
            context: context,
            icon: Icons.brightness_6,
            title: 'Тема оформления',
            subtitle: cubit.getThemeModeName(),
            onTap: () => _showThemeDialog(context, themeState, cubit),
            primaryColor: primaryColor,
            textColor: textColor,
          ),
          Divider(height: 1, color: primaryColor.withOpacity(0.1)),
          _buildSettingTile(
            context: context,
            icon: Icons.color_lens,
            title: 'Акцентный цвет',
            subtitle: 'Фиолетовый',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Выбор цвета будет доступен в будущем'),
                  backgroundColor: primaryColor,
                ),
              );
            },
            primaryColor: primaryColor,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSection(BuildContext context, Color primaryColor, bool isDark) {
    final textColor = AppTheme.getTextColor(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingTile(
            context: context,
            icon: Icons.equalizer,
            title: 'Эквалайзер',
            subtitle: 'Настройка звука',
            onTap: () => context.push('/main/settings/equalizer'),
            trailing: const Icon(Icons.chevron_right),
            primaryColor: primaryColor,
            textColor: textColor,
          ),
          Divider(height: 1, color: primaryColor.withOpacity(0.1)),
          _buildSwitchTile(
            context: context,
            icon: Icons.high_quality,
            title: 'Высокое качество',
            subtitle: 'Стриминг в высоком качестве',
            value: true,
            onChanged: (value) {},
            primaryColor: primaryColor,
            textColor: textColor,
          ),
          Divider(height: 1, color: primaryColor.withOpacity(0.1)),
          _buildSwitchTile(
            context: context,
            icon: Icons.wifi_off,
            title: 'Офлайн режим',
            subtitle: 'Доступна только скачанная музыка',
            value: false,
            onChanged: (value) {},
            primaryColor: primaryColor,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(
    BuildContext context,
    Color primaryColor,
    bool isDark,
    Color textColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            context: context,
            icon: Icons.notifications_active,
            title: 'Push-уведомления',
            subtitle: 'Получать уведомления о новинках',
            value: true,
            onChanged: (value) {},
            primaryColor: primaryColor,
            textColor: textColor,
          ),
          Divider(height: 1, color: primaryColor.withOpacity(0.1)),
          _buildSwitchTile(
            context: context,
            icon: Icons.new_releases,
            title: 'Новые релизы',
            subtitle: 'Уведомлять о новых альбомах артистов',
            value: true,
            onChanged: (value) {},
            primaryColor: primaryColor,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(
    BuildContext context,
    Color primaryColor,
    bool isDark,
    Color textColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingTile(
            context: context,
            icon: Icons.person_outline,
            title: 'Редактировать профиль',
            subtitle: 'Изменить личные данные',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Переход к редактированию профиля'),
                  backgroundColor: primaryColor,
                ),
              );
            },
            primaryColor: primaryColor,
            textColor: textColor,
          ),
          Divider(height: 1, color: primaryColor.withOpacity(0.1)),
          _buildSettingTile(
            context: context,
            icon: Icons.security,
            title: 'Конфиденциальность',
            subtitle: 'Управление данными',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Настройки конфиденциальности'),
                  backgroundColor: primaryColor,
                ),
              );
            },
            primaryColor: primaryColor,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(
    BuildContext context,
    Color primaryColor,
    bool isDark,
    Color textColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingTile(
            context: context,
            icon: Icons.info_outline,
            title: 'Версия приложения',
            subtitle: '1.0.0',
            onTap: null,
            primaryColor: primaryColor,
            textColor: textColor,
          ),
          Divider(height: 1, color: primaryColor.withOpacity(0.1)),
          _buildSettingTile(
            context: context,
            icon: Icons.description,
            title: 'Условия использования',
            subtitle: 'Правила и политика',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Открытие условий использования'),
                  backgroundColor: primaryColor,
                ),
              );
            },
            primaryColor: primaryColor,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    required Color primaryColor,
    required Color textColor,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryColor, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: textColor.withOpacity(0.6),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color primaryColor,
    required Color textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryColor, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: textColor.withOpacity(0.6),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: primaryColor,
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeState themeState, ThemeCubit cubit) {
    final primaryColor = AppTheme.getPrimaryColor(context);
    final isDark = AppTheme.isDarkMode(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Выберите тему'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<AppThemeMode>(
              title: const Text('Светлая'),
              value: AppThemeMode.light,
              groupValue: themeState.themeMode,
              activeColor: primaryColor,
              onChanged: (value) {
                if (value != null) {
                  cubit.setThemeMode(value);
                  Navigator.pop(dialogContext);
                }
              },
            ),
            RadioListTile<AppThemeMode>(
              title: const Text('Темная'),
              value: AppThemeMode.dark,
              groupValue: themeState.themeMode,
              activeColor: primaryColor,
              onChanged: (value) {
                if (value != null) {
                  cubit.setThemeMode(value);
                  Navigator.pop(dialogContext);
                }
              },
            ),
            RadioListTile<AppThemeMode>(
              title: const Text('Системная'),
              value: AppThemeMode.system,
              groupValue: themeState.themeMode,
              activeColor: primaryColor,
              onChanged: (value) {
                if (value != null) {
                  final brightness = MediaQuery.of(context).platformBrightness;
                  cubit.setThemeMode(value, systemIsDark: brightness == Brightness.dark);
                  Navigator.pop(dialogContext);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}
