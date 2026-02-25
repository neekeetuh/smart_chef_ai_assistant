import 'package:flutter/material.dart';
import 'package:smart_chef_ai_assistant/src/core/theme/data/theme_data_source.dart';

class ThemeProvider with ChangeNotifier {
  final ThemeDataSource _themeDataSource;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider({required ThemeDataSource themeDataSource})
    : _themeDataSource = themeDataSource {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _loadTheme() async {
    _themeMode = await _themeDataSource.getThemeMode();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _themeDataSource.saveThemeMode(mode);
  }
}
