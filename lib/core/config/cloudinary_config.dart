import 'package:flutter_dotenv/flutter_dotenv.dart';

/// ====================
/// CLOUDINARY CONFIGURATION
/// ====================

class CloudinaryConfig {
  
  static String get cloudName => dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static String get apiKey => dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  static String get apiSecret => dotenv.env['CLOUDINARY_API_SECRET'] ?? '';
  
  static bool get isConfigured {
    return cloudName.isNotEmpty && 
           apiKey.isNotEmpty && 
           apiSecret.isNotEmpty;
  }
  
  static String get configStatus {
    if (!isConfigured) {
      return '⚠️ Cloudinary credentials not found in .env file';
    }
    return '✅ Cloudinary configured successfully';
  }
  
  static void printConfig() {
    print('==================== CLOUDINARY CONFIG ====================');
    print('Cloud Name: ${cloudName.isNotEmpty ? "✅ $cloudName" : "❌ Missing"}');
    print('API Key: ${apiKey.isNotEmpty ? "✅ ${apiKey.substring(0, 5)}..." : "❌ Missing"}');
    print('API Secret: ${apiSecret.isNotEmpty ? "✅ ${apiSecret.substring(0, 5)}..." : "❌ Missing"}');
    print('Status: $configStatus');
    print('===========================================================');
  }
}