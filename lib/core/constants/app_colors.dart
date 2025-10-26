import 'package:flutter/material.dart';

/// ====================
/// APP COLOR PALETTE
/// ====================
/// 
/// Production-ready color scheme following Material Design principles
class AppColors {
  // ====================
  // PRIMARY COLORS
  // ====================
  
  static const Color primary = Color(0xFF6B4EE6);
  static const Color secondary = Color(0xFFFFB74D);
  static const Color accent = Color(0xFF4A90E2);
  
  // ====================
  // BACKGROUND COLORS
  // ====================
  
  static const Color background = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF2A2A2A);
  static const Color surfaceLight = Color(0xFF3A3A3A);
  
  // ====================
  // TEXT COLORS
  // ====================
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);
  
  // ====================
  // MEDITATION CARD GRADIENTS
  // ====================
  
  // First card (The Basics) - Green to Yellow
  static const List<Color> gradient1 = [
    Color(0xFF86C65A),
    Color(0xFFE8D85C),
  ];
  
  // Second card (Locked) - Orange to Purple to Blue
  static const List<Color> gradient2 = [
    Color(0xFFFF9A56),
    Color(0xFFB97DD4),
    Color(0xFF7BA4E8),
  ];
  
  // Additional gradients for variety
  static const List<Color> gradient3 = [
    Color(0xFFFF6B9D),
    Color(0xFFC46DD5),
  ];
  
  static const List<Color> gradient4 = [
    Color(0xFF56CCF2),
    Color(0xFF2F80ED),
  ];
  
  static const List<Color> gradient5 = [
    Color(0xFFF093FB),
    Color(0xFFF5576C),
  ];
  
  static const List<Color> gradient6 = [
    Color(0xFF4FACFE),
    Color(0xFF00F2FE),
  ];
  
  static const List<Color> gradient7 = [
    Color(0xFFFA709A),
    Color(0xFFFEE140),
  ];
  
  static const List<Color> gradient8 = [
    Color(0xFF30CFD0),
    Color(0xFF330867),
  ];
  
  // ====================
  // STATUS COLORS
  // ====================
  
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // ====================
  // SPECIAL COLORS
  // ====================
  
  static const Color premium = Color(0xFFFFD700);
  static const Color locked = Color(0xFF757575);
  static const Color bottomNavActive = Color(0xFF8B7355);
  static const Color bottomNavInactive = Color(0xFF505050);
}