import 'package:flutter/material.dart';

class AppColors {
  // 🔵 Primary Colors
  static const Color deepBlue = Color(0xFF0F172A);
  static const Color deepBlueAccent = Color(0xFF1E3A8A);

  // ⚫ Neutral / Backgrounds
  static const Color charcoal = Color(0xFF111827);
  static const Color gunmetal = Color(0xFF1F2937);
  static const Color softWhite = Color(0xFFF3F4F6);

  // 🟢 Status Colors
  static const Color neonGreen = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color crimson = Color(0xFFEF4444);

  // 🌑 NEW COLORS (Tambahkan ini)
  // Midnight: Warna dasar navigasi (Lebih gelap dari DeepBlue)
  static const Color midnight = Color(0xFF0B1120);
  // Glass Border: Warna garis tepi tipis untuk efek kaca
  static const Color glassBorder = Color(0xFF2A3241);

  static const LinearGradient blueGradient = LinearGradient(
    colors: [deepBlue, deepBlueAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
