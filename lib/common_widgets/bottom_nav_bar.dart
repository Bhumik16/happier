import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_theme.dart';
import '../controllers/appearance_controller/appearance_controller.dart';

/// ====================
/// BOTTOM NAVIGATION BAR
/// ====================
/// 
/// Custom bottom navigation with 5 tabs
/// Label only shows for selected tab
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final AppTheme _theme = AppTheme();
  
  CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppearanceController>(
      builder: (controller) {
        return Container(
          height: 75,
          decoration: BoxDecoration(
            color: _theme.bottomNavBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, 'Home'),
              _buildNavItem(1, Icons.eco, 'Courses'),
              _buildNavItem(2, Icons.grid_view, 'Singles'),
              _buildNavItem(3, Icons.nightlight, 'Sleep'),
              _buildNavItem(4, Icons.lightbulb_outline, 'Shorts'),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with background
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? _theme.bottomNavSelected 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected 
                      ? _theme.bottomNavUnselected 
                      : _theme.bottomNavUnselected,
                  size: 24,
                ),
              ),
              
              // Label (ONLY shows when selected)
              if (isSelected) ...[
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: _theme.textPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}