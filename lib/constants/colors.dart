import 'package:flutter/material.dart';

class LeWayColors {
  // Couleurs principales
  static const Color primary = Color(0xFF2D4EC8);
  static const Color primaryLight = Color(0xFFEEF1FF);
  static const Color primaryDark = Color(0xFF1A2F9C);

  // Couleurs neutres
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F9FF);
  static const Color surface = Color(0xFFEEF1FF);

  // Textes
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFC5D3FF);

  // Statuts
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Dégradé header
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D4EC8), Color(0xFF1A2F9C)],
  );
}