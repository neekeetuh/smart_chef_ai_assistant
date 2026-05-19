import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewModeProvider with ChangeNotifier {
  static const String _homeViewModeKey = 'home_view_mode';
  static const String _favoritesViewModeKey = 'favorites_view_mode';

  bool _isHomeGridView = false;
  bool _isFavoritesGridView = false;

  ViewModeProvider() {
    _loadViewModes();
  }

  bool get isHomeGridView => _isHomeGridView;
  bool get isFavoritesGridView => _isFavoritesGridView;

  Future<void> _loadViewModes() async {
    final prefs = await SharedPreferences.getInstance();
    _isHomeGridView = prefs.getBool(_homeViewModeKey) ?? false;
    _isFavoritesGridView = prefs.getBool(_favoritesViewModeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleHomeViewMode() async {
    _isHomeGridView = !_isHomeGridView;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_homeViewModeKey, _isHomeGridView);
  }

  Future<void> toggleFavoritesViewMode() async {
    _isFavoritesGridView = !_isFavoritesGridView;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_favoritesViewModeKey, _isFavoritesGridView);
  }
}
