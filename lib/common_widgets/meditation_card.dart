import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_theme.dart';
import '../controllers/appearance_controller/appearance_controller.dart';
import '../data/models/meditation_model.dart';

/// ====================
/// MEDITATION CARD
/// ====================

class MeditationCard extends StatelessWidget {
  final MeditationModel meditation;
  final bool isFirstCard;
  final VoidCallback? onTap;
  final VoidCallback? onStartCourseTap;
  final VoidCallback? onMoreTap;
  final AppTheme _theme = AppTheme();

  MeditationCard({
    Key? key,
    required this.meditation,
    this.isFirstCard = false,
    this.onTap,
    this.onStartCourseTap,
    this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppearanceController>(
      builder: (controller) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: isFirstCard ? 500 : 380,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                _theme.cardShadow,
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildBackground(),
                  _buildGradientOverlay(),
                  _buildContent(),
                  if (meditation.isLocked) _buildLockIcon(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  // ====================
  // BACKGROUND (IMAGE OR GRADIENT)
  // ====================
  
  Widget _buildBackground() {
    if (meditation.hasImage && meditation.imageUrl != null) {
      return Image.asset(
        meditation.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: _theme.cardColor,
          );
        },
      );
    } else {
      final colors = meditation.gradientColors
          .map((hex) => Color(int.parse(hex)))
          .toList();
      
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors.isNotEmpty ? colors : [_theme.cardColor, _theme.cardColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
    }
  }
  
  // ====================
  // GRADIENT OVERLAY
  // ====================
  
  Widget _buildGradientOverlay() {
    final colors = meditation.gradientColors
        .map((hex) => Color(int.parse(hex)))
        .toList();
    
    if (isFirstCard) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              colors.isNotEmpty ? colors[0].withOpacity(0.75) : Colors.transparent,
              colors.length > 1 ? colors[1].withOpacity(0.9) : Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.5, 0.7, 1.0],
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors.isNotEmpty 
                ? colors.map((c) => c.withOpacity(0.6)).toList()
                : [Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
    }
  }
  
  // ====================
  // CONTENT (TEXT + BUTTONS)
  // ====================
  
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meditation.sessionText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              meditation.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: isFirstCard ? 48 : 28,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
              maxLines: isFirstCard ? 4 : 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          
          // ✅ Play button positioned ABOVE teacher name (non-first cards only)
          if (!isFirstCard) ...[
            _buildPlayButtonInline(),
            const SizedBox(height: 12),
          ],
          
          Text(
            meditation.instructor,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isFirstCard) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onStartCourseTap ?? onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Start Course',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: onMoreTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'More',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  // ====================
  // PLAY BUTTON WITH DURATION (INLINE - ABOVE TEACHER NAME)
  // ✅ ONLY SHOWN ON NON-FIRST CARDS
  // ====================
  
  Widget _buildPlayButtonInline() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            '${meditation.durationMinutes} min',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  // ====================
  // LOCK ICON
  // ====================
  
  Widget _buildLockIcon() {
    return Positioned(
      top: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.lock_outline,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}