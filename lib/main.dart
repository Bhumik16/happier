import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'get_it.dart'; // ✅ ADDED - GetIt setup
import 'core/services/cloudinary_service.dart';
import 'core/services/downloads_service.dart';
import 'core/services/history_service.dart';
import 'core/config/cloudinary_config.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';

/// ====================
/// MAIN ENTRY POINT
/// ====================

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ ADDED - Setup dependency injection first
  await setupDependencyInjection();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('🔥 Firebase initialized successfully\n');
  } catch (e) {
    print('❌ Firebase initialization error: $e\n');
  }

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
    print('✅ .env file loaded successfully\n');
    CloudinaryConfig.printConfig();
  } catch (e) {
    print('❌ Error loading .env file: $e');
    print('⚠️ Make sure .env file exists in project root\n');
  }

  // Initialize Cloudinary service
  try {
    if (CloudinaryConfig.isConfigured) {
      CloudinaryService.initialize();
      print('✅ Cloudinary initialized successfully\n');
    } else {
      print('⚠️ Cloudinary not configured. Check .env file.\n');
    }
  } catch (e) {
    print('❌ Error initializing Cloudinary: $e\n');
  }

  // Initialize Downloads and History Services
  try {
    Get.put(DownloadsService());
    Get.put(HistoryService());
    print('✅ Downloads and History services initialized\n');
  } catch (e) {
    print('❌ Error initializing services: $e\n');
  }

  print('✅ App initialization complete!\n');

  runApp(const MyApp());
}

/// ====================
/// MY APP
/// ====================

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Happier Meditation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        primaryColor: const Color(0xFF4A90E2),
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      // ✅ REMOVED: initialBinding: AuthBindings() - Let splash handle initialization
    );
  }
}
