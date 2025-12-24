import 'package:flutter/material.dart';

/// App Colors
/// Definisi warna untuk aplikasi dengan dark theme

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4B44B3);

  // Background Colors
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF2D2D2D);
  static const Color surfaceDark = Color(0xFF0A0A0A);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textHint = Color(0xFF4A4A4A);

  // Status Colors
  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFB74D);
  static const Color info = Color(0xFF29B6F6);

  // Accent Colors (for avatars, tags, etc)
  static const List<Color> accentColors = [
    Color(0xFF6C63FF),
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFE66D),
    Color(0xFF95E1D3),
    Color(0xFFF38181),
    Color(0xFFAA96DA),
    Color(0xFFFCBF49),
  ];

  // Border Colors
  static const Color border = Color(0xFF2D2D2D);
  static const Color borderLight = Color(0xFF3D3D3D);

  // Gradient Presets
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surface, Color(0xFF181818)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Get accent color by index
  static Color getAccentColor(int index) {
    return accentColors[index % accentColors.length];
  }
}
