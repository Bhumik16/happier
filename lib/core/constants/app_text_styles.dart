import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ====================
/// APP TEXT STYLES
/// ====================
/// 
/// Consistent typography throughout the app
class AppTextStyles {
  // ====================
  // HEADINGS
  // ====================
  
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  // ====================
  // BODY TEXT
  // ====================
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
  );
  
  // ====================
  // MEDITATION CARD STYLES
  // ====================
  
  static const TextStyle cardTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle cardInstructor = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle cardLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );
  
  static const TextStyle cardDuration = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  
  // ====================
  // BUTTON STYLES
  // ====================
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}