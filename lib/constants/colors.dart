import 'package:flutter/material.dart';

class LeWayColors {
  // Couleurs principales — fidèles à Bolt (primary-900 = bleu marine)
  static const Color primary900 = Color(0xFF1E3A8A);
  static const Color primary800 = Color(0xFF1E40AF);
  static const Color primary700 = Color(0xFF1D4ED8);
  static const Color primary600 = Color(0xFF2563EB);
  static const Color primary100 = Color(0xFFDBEAFE);
  static const Color primary50  = Color(0xFFEFF6FF);

  // Accent (orange/ambre — comme Bolt)
  static const Color accent600 = Color(0xFFD97706);
  static const Color accent500 = Color(0xFFF59E0B);
  static const Color accent50  = Color(0xFFFFFBEB);

  // Neutres
  static const Color white      = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color slate100   = Color(0xFFF1F5F9);
  static const Color slate200   = Color(0xFFE2E8F0);
  static const Color slate400   = Color(0xFF94A3B8);
  static const Color slate500   = Color(0xFF64748B);
  static const Color slate600   = Color(0xFF475569);
  static const Color slate700   = Color(0xFF334155);
  static const Color slate800   = Color(0xFF1E293B);
  static const Color slate900   = Color(0xFF0F172A);

  // Statuts
  static const Color green600   = Color(0xFF16A34A);
  static const Color green50    = Color(0xFFF0FDF4);
  static const Color red600     = Color(0xFFDC2626);
  static const Color red50      = Color(0xFFFEF2F2);
  static const Color amber600   = Color(0xFFD97706);
  static const Color amber50    = Color(0xFFFFFBEB);

  // Dégradé header — comme Bolt
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
  );

  // Alias pratiques
  static const Color primary     = primary900;
  static const Color primaryLight = primary50;
  static const Color primaryDark  = Color(0xFF172554);
  static const Color textPrimary  = slate900;
  static const Color textSecondary = slate500;
  static const Color error        = red600;
  static const Color success      = green600;
}