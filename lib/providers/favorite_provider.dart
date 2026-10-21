import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Favorit disimpan per akun: { userId: {productId, ...} }
class FavoriteProvider extends ChangeNotifier {
  FavoriteProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;
  static const String _key = 'favorites';

  final Map<String, Set<String>> _favorites = {};

  bool isFavorite(String userId, String productId) =>
      _favorites[userId]?.contains(productId) ?? false;

  List<String> favoriteIdsOf(String userId) =>
      (_favorites[userId] ?? <String>{}).toList();

  void toggle(String userId, String productId) {
    final set = _favorites.putIfAbsent(userId, () => <String>{});
    if (!set.add(productId)) set.remove(productId);
    _save();
    notifyListeners();
  }

  void _load() {
    try {
      final raw = _prefs.getString(_key);
      if (raw == null) return;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      map.forEach((userId, list) {
        _favorites[userId] =
            (list as List).map((e) => e.toString()).toSet();
      });
    } catch (_) {
      _favorites.clear();
    }
  }

  void _save() {
    final map = _favorites.map((k, v) => MapEntry(k, v.toList()));
    _prefs.setString(_key, jsonEncode(map));
  }
}
