import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/utils/navigation_helper.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final PageController _pageController = PageController();
  final AppTheme _theme = AppTheme();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Ensure AppearanceController is initialized
    if (!Get.isRegistered<AppearanceController>()) {
      Get.put(AppearanceController());
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: _theme.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Top Bar
                  _buildTopBar(),
                  
                  const SizedBox(height: 20),
                  
                  // Gradient Stats Card
                  _buildGradientStatsCard(),
                  
                  const SizedBox(height: 20),
                  
                  // Favorites Button
                  _buildFavoritesButton(),
                  
                  const SizedBox(height: 20),
                  
                  // Unlock Button
                  _buildUnlockButton(),
                  
                  const SizedBox(height: 20),
                  
                  // Calendar Widget with PageView
                  _buildCalendarWidget(),
                  
                  const SizedBox(height: 20),
                  
                  // Menu Items
                  _buildMenuItems(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: _theme.iconPrimary, size: 28),
            onPressed: () => NavigationHelper.goBackSimple(),
          ),
          Text(
            'Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: _theme.textPrimary,
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: _theme.iconPrimary, size: 28),
            onPressed: () {
              Get.toNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGradientStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE066D7), // Pink
              Color(0xFFFF6B6B), // Orange-Red
              Color(0xFFFF8E53), // Orange
            ],
          ),
        ),
        child: Column(
          children: [
            // Top circular text with days
            SizedBox(
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular text "Mindful Days"
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: CircularTextPainter(
                      text: "Mindful Days Mindful Days",
                      radius: 100,
                    ),
                  ),
                  // Center number (days count)
                  const Text(
                    '0',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom stats section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _theme.cardColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('0', 'Total\nSessions'),
                  _buildStatItem('0', 'Total\nMinutes'),
                  _buildStatItem('0', 'Weekly\nStreak'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _theme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: _theme.textSecondary,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.profileFavorites);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _theme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.favorite,
                  color: _theme.accentColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Favorites',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _theme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnlockButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Unlock Happier for FREE',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // PageView for swipeable calendars
            SizedBox(
              height: 320,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  // Page 1: Last 4 Weeks
                  _buildLast4WeeksCalendar(),
                  
                  // Page 2: Last 30 Days
                  _buildLast30DaysCalendar(),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Page indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPageIndicator(isActive: _currentPage == 0),
                const SizedBox(width: 8),
                _buildPageIndicator(isActive: _currentPage == 1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator({required bool isActive}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? _theme.textPrimary : _theme.textSecondary.withOpacity(0.3),
      ),
    );
  }

  Widget _buildLast4WeeksCalendar() {
    return Column(
      children: [
        Text(
          'Last 4 Weeks',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _theme.textPrimary,
          ),
        ),
        const SizedBox(height: 20),
        
        // Calendar grid with day headers
        _buildWeeklyCalendarGrid(),
      ],
    );
  }

  Widget _buildLast30DaysCalendar() {
    return Column(
      children: [
        Text(
          'Last 30 Days',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _theme.textPrimary,
          ),
        ),
        const SizedBox(height: 20),
        
        // Equally spaced 3 dotted lines filling the space
        Expanded(
          child: _build30DaysHorizontalDots(),
        ),
      ],
    );
  }

  Widget _buildWeeklyCalendarGrid() {
    return Column(
      children: [
        // Day headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDayHeader('M'),
            _buildDayHeader('T'),
            _buildDayHeader('W'),
            _buildDayHeader('T'),
            _buildDayHeader('F'),
            _buildDayHeader('S'),
            _buildDayHeader('S'),
          ],
        ),
        const SizedBox(height: 16),
        
        // 4 weeks of dots
        for (int week = 0; week < 4; week++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int day = 0; day < 7; day++)
                  _buildDayDot(isHighlighted: week == 3 && day == 0),
              ],
            ),
          ),
      ],
    );
  }

  Widget _build30DaysHorizontalDots() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDotRow(count: 30),
        _buildDotRow(count: 30),
        _buildDotRow(count: 30),
      ],
    );
  }

  Widget _buildDotRow({required int count}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _theme.textSecondary.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildDayHeader(String day) {
    return SizedBox(
      width: 40,
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: _theme.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDayDot({bool isHighlighted = false}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isHighlighted 
            ? Colors.transparent 
            : _theme.textSecondary.withOpacity(0.3),
        border: isHighlighted 
            ? Border.all(color: _theme.accentColor, width: 3)
            : null,
      ),
    );
  }

  Widget _buildMenuItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildMenuItem(
              icon: Icons.emoji_events,
              title: 'Milestones',
              onTap: () {
                Get.toNamed(AppRoutes.milestones);
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.history,
              title: 'History',
              onTap: () {
                Get.toNamed(AppRoutes.history);
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.cloud_download,
              title: 'Downloads',
              onTap: () {
                Get.toNamed(AppRoutes.downloads);
              },
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, color: _theme.accentColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _theme.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: _theme.accentColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        color: _theme.dividerColor,
        height: 1,
      ),
    );
  }
}

// Custom painter for circular text - each letter equally spaced
class CircularTextPainter extends CustomPainter {
  final String text;
  final double radius;

  CircularTextPainter({required this.text, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    final displayText = "Mindful Days Mindful Days";
    final angleStep = (2 * math.pi) / displayText.length;

    for (int i = 0; i < displayText.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      
      textPainter.text = TextSpan(
        text: displayText[i],
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
      );
      
      textPainter.layout();
      
      canvas.save();
      canvas.translate(centerX, centerY);
      canvas.rotate(angle + math.pi / 2);
      canvas.translate(-textPainter.width / 2, -radius);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}