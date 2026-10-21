import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

/// Akun demo + status login. Tidak ada registrasi / autentikasi daring.
class AuthProvider extends ChangeNotifier {
  static const List<UserModel> demoUsers = [
    UserModel(
      id: 'u1',
      username: 'demo1',
      password: 'butuhkopi',
      name: 'Budi Karburator',
    ),
    UserModel(
      id: 'u2',
      username: 'demo2',
      password: 'naspadseporsi',
      name: 'Ujang Tambal Ban',
    ),
  ];

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  UserModel? userById(String id) {
    for (final u in demoUsers) {
      if (u.id == id) return u;
    }
    return null;
  }

  /// Mengembalikan true jika username & password cocok dengan akun demo.
  bool login(String username, String password) {
    for (final u in demoUsers) {
      if (u.username == username.trim() && u.password == password) {
        _currentUser = u;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
