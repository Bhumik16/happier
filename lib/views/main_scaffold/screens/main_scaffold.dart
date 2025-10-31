import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../home_view/screens/home_view.dart';
import '../../courses_view/screens/courses_view.dart';
import '../../singles_view/screens/singles_view.dart';
import '../../sleeps_view/screens/sleeps_view.dart';
import '../../shorts_view/screens/shorts_view.dart';
import '../../../common_widgets/bottom_nav_bar.dart';
import '../../../controllers/courses_controller/courses_bindings.dart';
import '../../../controllers/singles_controller/singles_bindings.dart';
import '../../../controllers/sleeps_controller/sleeps_bindings.dart';
import '../../../controllers/shorts_controller/shorts_bindings.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';

/// ====================
/// MAIN SCAFFOLD
/// ====================
/// 
/// Wrapper that holds bottom navigation and switches between screens
/// This ensures the bottom nav is persistent across all tabs
class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final AppTheme _theme = AppTheme();
  
  @override
  void initState() {
    super.initState();
    // Initialize bindings for all tabs
    CoursesBindings().dependencies();
    SinglesBindings().dependencies();
    SleepsBindings().dependencies();
    ShortsBindings().dependencies();
    
    // Ensure AppearanceController is initialized
    if (!Get.isRegistered<AppearanceController>()) {
      Get.put(AppearanceController());
    }
  }
  
  // ====================
  // ALL SCREENS
  // ====================
  
  final List<Widget> _screens = [
    const HomeView(),                            // Tab 0: Home
    const CoursesView(),                         // Tab 1: Courses (Leaf icon)
    const SinglesView(),                         // Tab 2: Singles (Grid icon)
    const SleepsView(),                          // Tab 3: Sleep (Moon icon)
    const ShortsView(),                          // Tab 4: Shorts (Lightbulb icon)
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        return Scaffold(
          backgroundColor: _theme.scaffoldBackgroundColor,
          
          // ====================
          // APP BAR - NO TITLE, JUST ICONS
          // ====================
          appBar: AppBar(
            backgroundColor: _theme.appBarColor,
            elevation: 0,
            title: null, // ✅ NO TITLE
            actions: [
              // Profile Icon (LEFT)
              IconButton(
                icon: Icon(Icons.person, color: _theme.iconPrimary, size: 28),
                onPressed: () {
                  Get.toNamed(AppRoutes.profile);
                },
              ),
              // Search Icon (RIGHT)
              IconButton(
                icon: Icon(Icons.search, color: _theme.iconPrimary, size: 28),
                onPressed: () {
                  Get.toNamed(AppRoutes.search);
                },
              ),
            ],
          ),
          
          // ====================
          // BODY - TAB CONTENT
          // ====================
          body: _screens[_currentIndex], // Switch between screens
          
          // ====================
          // BOTTOM NAVIGATION BAR
          // ====================
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          
          // ====================
          // FLOATING CHATBOT BUTTON
          // ====================
          floatingActionButton: Container(
            margin: const EdgeInsets.only(bottom: 16), // Closer to navbar
            child: FloatingActionButton(
              onPressed: () => Get.toNamed(AppRoutes.chatbot),
              backgroundColor: const Color(0xFFFDB813),
              elevation: 8,
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }
}