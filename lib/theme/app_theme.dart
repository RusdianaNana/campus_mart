import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0A8CFF); // biru cerah (utama)
  static const Color primaryLight = Color(0xFF4FC3FF); // biru muda (gradien)
  static const Color primaryDark = Color(0xFF0B2E4F); // biru tua untuk teks
  static const Color accent = Color(0xFFFFB703); // kuning aksen
  static const Color beige = Color(0xFFF1F7FE); // latar halaman
  static const Color ivory = Color(0xFFFFFFFF); // permukaan kartu
  static const Color grey = Color(0xFF7C8B9A); // teks sekunder
  static const Color divider = Color(0xFFDDE8F3);

  // Warna status permintaan pembelian
  static const Color waiting = Color(0xFFE09B00);
  static const Color accepted = Color(0xFF2E7D32);
  static const Color rejected = Color(0xFFC62828);

  // Gradien utama (header, tombol Jual)
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );
}

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      surface: AppColors.ivory,
    );

    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.beige,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.beige,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.primaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.ivory,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: border(AppColors.divider),
        enabledBorder: border(AppColors.divider),
        focusedBorder: border(AppColors.primary, 1.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.ivory,
        indicatorColor: Color(0xFFD6ECFF),
        elevation: 10,
      ),
    );
  }
}