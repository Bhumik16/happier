import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';
import 'dart:convert';

class DownloadsService extends GetxService {
  final Dio _dio = Dio();
  final Logger _logger = Logger();
  final RxMap<String, double> downloadProgress = <String, double>{}.obs;

  // ✅ Cache the user ID to survive logout/login cycles
  String? _cachedUserId;

  /// Get current user ID safely with caching
  String _getCurrentUserId() {
    try {
      // Try to get from AuthController
      if (Get.isRegistered<dynamic>(tag: 'AuthController')) {
        final authController = Get.find(tag: 'AuthController');
        final userId = authController.currentUser?.value?.uid;

        if (userId != null && userId.isNotEmpty) {
          _cachedUserId = userId; // ✅ Cache it
          return userId;
        }
      }

      // If AuthController not available but we have cached ID, use it
      if (_cachedUserId != null && _cachedUserId!.isNotEmpty) {
        return _cachedUserId!;
      }
    } catch (e) {
      _logger.w('Error getting user ID: $e');

      // Return cached if available
      if (_cachedUserId != null && _cachedUserId!.isNotEmpty) {
        return _cachedUserId!;
      }
    }

    // Last resort: use 'guest' (for users who never logged in)
    return 'guest';
  }

  /// Get user-specific downloads key
  String _getDownloadsKey() {
    final userId = _getCurrentUserId();
    return 'downloads_$userId';
  }

  /// Request storage permission (NOT NEEDED for internal storage but keeping for compatibility)
  Future<bool> requestStoragePermission() async {
    // For internal app storage, we don't need permissions!
    return true;
  }

  /// Get downloads directory (APP-ONLY INTERNAL STORAGE)
  Future<Directory> getDownloadsDirectory() async {
    // ✅ USE INTERNAL APP STORAGE - NOT ACCESSIBLE FROM FILE MANAGER
    final directory = await getApplicationDocumentsDirectory();
    final customDir = Directory('${directory.path}/HappierDownloads');

    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }

    _logger.d('📂 Downloads directory: ${customDir.path}');
    return customDir;
  }

  /// Download a file (video or audio)
  Future<String?> downloadFile({
    required String url,
    required String fileName,
    required String itemId,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      // Get download directory (no permission needed for internal storage)
      final directory = await getDownloadsDirectory();
      final filePath = '${directory.path}/$fileName';

      _logger.d('📥 Downloading to: $filePath');

      // Check if already exists
      if (await File(filePath).exists()) {
        _logger.i('✅ File already exists: $filePath');
        // Still save metadata if not already saved
        await _saveDownloadMetadata(itemId, filePath, metadata);
        return filePath;
      }

      // Download with progress tracking (NO SPAM LOGGING)
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total);
            downloadProgress[itemId] = progress;
            // Progress tracked silently - UI shows it
          }
        },
      );

      // Verify file was downloaded
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not created after download');
      }

      _logger.i('✅ File downloaded successfully: ${await file.length()} bytes');

      // Save download metadata
      await _saveDownloadMetadata(itemId, filePath, metadata);

      // Clear progress
      downloadProgress.remove(itemId);

      _logger.i('✅ Download complete: $fileName');
      return filePath;
    } catch (e) {
      downloadProgress.remove(itemId);
      _logger.e('❌ Download failed: $e');
      return null;
    }
  }

  /// Save download metadata to SharedPreferences
  Future<void> _saveDownloadMetadata(
    String itemId,
    String filePath,
    Map<String, dynamic> metadata,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadsKey = _getDownloadsKey();

      final downloadsJson = prefs.getString(downloadsKey);
      final downloads = downloadsJson != null
          ? Map<String, dynamic>.from(json.decode(downloadsJson))
          : <String, dynamic>{};

      final file = File(filePath);
      final fileSize = await file.length();

      downloads[itemId] = {
        ...metadata,
        'filePath': filePath,
        'fileSize': fileSize,
        'downloadedAt': DateTime.now().toIso8601String(),
      };

      await prefs.setString(downloadsKey, json.encode(downloads));
      _logger.d(
        '💾 Metadata saved for: $itemId (user: ${_getCurrentUserId()})',
      );
    } catch (e) {
      _logger.w('Error saving download metadata: $e');
    }
  }

  /// Get all downloaded items
  Future<Map<String, dynamic>> getDownloadedItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadsKey = _getDownloadsKey();
      final data = prefs.getString(downloadsKey);

      if (data == null) return {};

      final downloads = Map<String, dynamic>.from(json.decode(data));
      _logger.i(
        '📦 Loaded ${downloads.length} downloads for user: ${_getCurrentUserId()}',
      );
      return downloads;
    } catch (e) {
      _logger.w('Error getting downloads: $e');
      return {};
    }
  }

  /// Check if item is downloaded
  Future<bool> isDownloaded(String itemId) async {
    try {
      final downloads = await getDownloadedItems();
      if (!downloads.containsKey(itemId)) return false;

      // Check if file still exists
      final filePath = downloads[itemId]['filePath'];
      if (filePath == null) return false;

      return await File(filePath).exists();
    } catch (e) {
      return false;
    }
  }

  /// Get downloaded file path
  Future<String?> getDownloadedFilePath(String itemId) async {
    try {
      final downloads = await getDownloadedItems();
      if (!downloads.containsKey(itemId)) return null;

      final filePath = downloads[itemId]['filePath'];
      if (filePath != null && await File(filePath).exists()) {
        return filePath;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Delete downloaded file
  Future<bool> deleteDownload(String itemId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadsKey = _getDownloadsKey();
      final downloads = await getDownloadedItems();

      if (!downloads.containsKey(itemId)) return false;

      final filePath = downloads[itemId]['filePath'];
      if (filePath != null) {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          _logger.i('🗑️ File deleted: $filePath');
        }
      }

      downloads.remove(itemId);
      await prefs.setString(downloadsKey, json.encode(downloads));

      return true;
    } catch (e) {
      _logger.w('Error deleting download: $e');
      return false;
    }
  }

  /// Get total storage used (in bytes)
  Future<int> getTotalStorageUsed() async {
    try {
      final downloads = await getDownloadedItems();
      int total = 0;

      for (var item in downloads.values) {
        total += (item['fileSize'] as int? ?? 0);
      }

      return total;
    } catch (e) {
      return 0;
    }
  }

  /// Format bytes to readable string
  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Clear all downloads for current user
  Future<void> clearAllDownloads() async {
    try {
      final downloads = await getDownloadedItems();

      for (var item in downloads.values) {
        final filePath = item['filePath'];
        if (filePath != null) {
          final file = File(filePath);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }

      final prefs = await SharedPreferences.getInstance();
      final downloadsKey = _getDownloadsKey();
      await prefs.remove(downloadsKey);

      _logger.i('🗑️ All downloads cleared for user: ${_getCurrentUserId()}');
    } catch (e) {
      _logger.w('Error clearing downloads: $e');
    }
  }
}
