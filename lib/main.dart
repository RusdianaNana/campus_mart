import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/auth/login_page.dart';
import 'pages/main_page.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/product_provider.dart';
import 'providers/purchase_provider.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(CampusMartApp(prefs: prefs));
}

class CampusMartApp extends StatelessWidget {
  final SharedPreferences prefs;

  const CampusMartApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider(prefs)),
        ChangeNotifierProvider(create: (_) => FavoriteProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ChatProvider(prefs)),
        ChangeNotifierProvider(create: (_) => PurchaseProvider(prefs)),
      ],
      child: MaterialApp(
        title: 'Campus Mart',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AuthGate(),
      ),
    );
  }
}

/// Jika sudah login tampilkan aplikasi utama, jika belum tampilkan Login.
/// Karena memakai Consumer, Logout otomatis mengembalikan ke halaman Login.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) =>
          auth.isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}
