// import 'package:flutter/material.dart';
//
// class AppColors {
//   static const Color primary = Color(0xFF960FFF);
//   static const Color secondary = Color(0xFFF5E7FF);
//   static const Color accentDark = Color(0xFF348AC7);
//   static const Color accent = Color(0xFF79D0FF);
//
//   static const Color textPrimary = Color(0xFF6C5CE7);
//   static const Color textSecondary = Color(0xFF4F5B67);
//   static const Color textSecondaryDark = Color(0xFFBFD1E5);
//   static const Color hintTextGrey = Color(0xFFDDDADA);
//   static const Color textGrey = Color(0xFF858585);
//   static const Color textGrey1 = Color(0xFF9A9A9A);
//   static const Color textGrey2 = Color(0xFF696F8C);
//
//   static const Color cardBg = Color(0xFFF0F0F0);
//   static const Color borderColor = Color(0xFFA8A8A8);
//
//
//   static const Color surfaceDark = Color(0xFF15223A);
//   static const Color fieldColor = Color(0xFF192A52);
//
//   static const Color white = Colors.white;
//   static const Color black = Colors.black;
//
//   static const Color error = Colors.redAccent;
//   static const Color emergencyColor = Color(0xFFFFB7B8);
//   static const Color success = Colors.green;
//
//   final gradient = LinearGradient(
//     begin: Alignment.centerLeft,
//     end: Alignment.centerRight,
//     colors: [
//       Color(0xFF7ED6D3),
//       Color(0xFFB77CF5),
//       Color(0xFF9A9CF6),
//     ],
//   );
// }

import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color primary = Color(0xFF6366F1); // Royal Indigo
  static const Color secondary = Color(0xFF312E81); // Deep Indigo
  static const Color accentDark = Color(0xFF0891B2); // Deep Cyan
  static const Color accent = Color(0xFF06B6D4); // Glowing Cyan

  // Typography - Dark
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textSecondaryDark = Color(0xFF64748B);
  static const Color hintTextGrey = Color(0xFF475569);
  static const Color textGrey = Color(0xFF94A3B8);
  static const Color textGrey1 = Color(0xFF475569);
  static const Color textGrey2 = Color(0xFF64748B);

  // Typography - Light (mapped to dark to keep UI cohesive)
  static const Color textPrimaryLight = Color(0xFFF8FAFC);
  static const Color textSecondaryLight = Color(0xFF94A3B8);
  static const Color hintTextGreyLight = Color(0xFF475569);

  // Layered surfaces - Dark
  static const Color surface0 = Color(0xFF080B11); // Deep slate-midnight
  static const Color surface1 = Color(0xFF0F131E); // Slate Card BG
  static const Color surface2 = Color(0xFF181D2B); // Slate Inner Card/Field BG
  static const Color cardBg = surface1;
  static const Color borderColor = Color(0xFF222B3D); // Slate borders
  static const Color surfaceDark = surface0;
  static const Color fieldColor = surface2;
  // Overlays
  static const Color overlayLight = Color(0x1A6366F1);
  static const Color overlayStrong = Color(0x336366F1);

  // Layered surfaces - Light (mapped to dark to keep UI cohesive)
  static const Color surfaceLight0 = Color(0xFF080B11);
  static const Color surfaceLight1 = Color(0xFF0F131E);
  static const Color surfaceLight2 = Color(0xFF181D2B);
  static const Color cardBgLight = surfaceLight1;
  static const Color borderColorLight = Color(0xFF222B3D);
  static const Color fieldColorLight = surfaceLight2;

  // Basic
  static const Color white = Colors.white;
  static const Color black = Color(0xFF000000);
  static const Color darkGrey = Color(0xFF1E293B);

  // Status
  static const Color error = Color(0xFFFF5A76);
  static const Color emergencyColor = Color(0xFF4A1F2A);
  static const Color success = Color(0xFF34D399);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF818CF8), Color(0xFFC084FC), Color(0xFFF472B6)], // Indigo to Purple to Pink
  );

  static const LinearGradient ctaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1), // Royal Indigo
      Color(0xFFEC4899), // Sunset Pink/Magenta
    ],
  );

  final LinearGradient gradient = ctaGradient;
}
