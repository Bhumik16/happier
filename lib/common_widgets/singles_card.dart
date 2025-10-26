import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_theme.dart';
import '../controllers/appearance_controller/appearance_controller.dart';
import '../data/models/single_model.dart';

/// ====================
/// SINGLE CARD
/// ====================
/// 
/// Reusable gradient card for singles

class SingleCard extends StatelessWidget {
  final SingleModel single;
  final VoidCallback onTap;
  final double height;
  final double? width;
  final AppTheme _theme = AppTheme();
  
  SingleCard({
    Key? key,
    required this.single,
    required this.onTap,
    this.height = 200,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppearanceController>(
      builder: (controller) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            margin: const EdgeInsets.only(right: 12, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: _buildGradient(),
              boxShadow: [
                _theme.cardShadow,
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  single.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  // ====================
  // BUILD GRADIENT
  // ====================
  
  LinearGradient _buildGradient() {
    final colors = single.gradientColors
        .map((hex) => Color(int.parse(hex)))
        .toList();
    
    if (colors.isEmpty) {
      // Fallback gradient using theme colors
      return LinearGradient(
        colors: [_theme.cardColor, _theme.cardColor.withOpacity(0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    
    // Use the defined gradient colors (same in both themes)
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}