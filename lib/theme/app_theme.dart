
import 'package:flutter/material.dart';

class CoverColors {
  static const background = Color(0xFF29202D);
  static const aubergine = Color(0xFF50384F);
  static const silver = Color(0xFFE0DDE4);
  static const silverMuted = Color(0xFFB9B4C0);
  static const gold = Color(0xFFD6B574);
}

class GameColors {
  static const background = Color(0xFFF4EFE5);
  static const surface = Color(0xFFFFFCF6);
  static const beige = Color(0xFFECE5D9);
  static const sage = Color(0xFF829487);
  static const sageLight = Color(0xFFE1E9E1);
  static const burgundy = Color(0xFF713B4A);
  static const lavender = Color(0xFFA99ACB);
  static const ink = Color(0xFF3D3B38);
  static const muted = Color(0xFF85837D);
  static const border = Color(0xFFE4DCCE);
  static const gold = Color(0xFFC5A66A);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: GameColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: GameColors.sage,
      brightness: Brightness.light,
      surface: GameColors.surface,
    ),
  );
}
