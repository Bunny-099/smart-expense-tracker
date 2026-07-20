import 'package:flutter/material.dart';
import 'hive_service.dart';

class ThemeService {
  ThemeService._();

  static const String _themeKey = 'theme_mode';

  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    final box = HiveService.getBox(HiveService.settingsBox);
    await box.put(_themeKey, themeMode.name);
  }

  static ThemeMode getThemeMode() {
    final box = HiveService.getBox(HiveService.settingsBox);
    final String? themeName = box.get(_themeKey);

    if (themeName == ThemeMode.light.name) {
      return ThemeMode.light;
    } else if (themeName == ThemeMode.dark.name) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }
}