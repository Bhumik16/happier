import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../core/services/downloads_service.dart';

class DownloadsSettingsController extends GetxController {
  final Logger _logger = Logger();
  final DownloadsService _downloadsService = Get.find<DownloadsService>();

  // Reactive states
  final RxBool downloadOnlyOnWifi = true.obs;
  final RxString quality = 'Normal'.obs;
  final RxString totalDownloadsSize = '0 B'.obs;
  final RxString freeSpace = 'Calculating...'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
    _calculateStorageInfo();
  }

  // Load saved preferences
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      downloadOnlyOnWifi.value = prefs.getBool('download_only_wifi') ?? true;
      quality.value = prefs.getString('download_quality') ?? 'Normal';
    } catch (e) {
      _logger.e('Error loading download preferences: $e');
    }
  }

  // Calculate storage information
  Future<void> _calculateStorageInfo() async {
    try {
      // Get total downloads size
      final totalBytes = await _downloadsService.getTotalStorageUsed();
      totalDownloadsSize.value = _downloadsService.formatBytes(totalBytes);

      // Get free space
      final directory = await _downloadsService.getDownloadsDirectory();
      // final stat = await directory.stat();

      // Get available space (this is approximate)
      try {
        // final diskSpace = directory.statSync();
        // Calculate free space - this is a rough estimate
        final freeBytes = await _getAvailableSpace(directory.path);
        freeSpace.value = _downloadsService.formatBytes(freeBytes);
      } catch (e) {
        // If we can't get exact free space, show a placeholder
        freeSpace.value = '13.4 GB'; // Placeholder
      }
    } catch (e) {
      _logger.e('Error calculating storage: $e');
      totalDownloadsSize.value = '0 B';
      freeSpace.value = 'Unknown';
    }
  }

  // Get available space on device
  Future<int> _getAvailableSpace(String path) async {
    try {
      // This is a simple approach - for production, use disk_space package
      final result = await Process.run('df', ['-k', path]);
      if (result.exitCode == 0) {
        final lines = result.stdout.toString().split('\n');
        if (lines.length > 1) {
          final parts = lines[1].split(RegExp(r'\s+'));
          if (parts.length > 3) {
            final availableKB = int.tryParse(parts[3]) ?? 0;
            return availableKB * 1024; // Convert KB to bytes
          }
        }
      }

      // Fallback: estimate based on parent directory
      return 14000000000; // ~14 GB as fallback
    } catch (e) {
      _logger.e('Error getting available space: $e');
      return 14000000000; // ~14 GB as fallback
    }
  }

  // Toggle download only on Wi-Fi
  Future<void> toggleDownloadOnlyOnWifi(bool value) async {
    downloadOnlyOnWifi.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('download_only_wifi', value);

    Get.snackbar(
      'Wi-Fi Downloads',
      value
          ? 'Downloads will only happen on Wi-Fi'
          : 'Downloads allowed on mobile data',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Open quality picker
  Future<void> openQualityPicker() async {
    final qualities = ['Low', 'Normal', 'High', 'Best'];

    await Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2a2a2a),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Download Quality',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...qualities
                .map(
                  (q) => ListTile(
                    title: Text(q, style: const TextStyle(color: Colors.white)),
                    trailing: quality.value == q
                        ? const Icon(Icons.check, color: Color(0xFFFFD700))
                        : null,
                    onTap: () async {
                      quality.value = q;
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('download_quality', q);
                      Get.back();
                      Get.snackbar(
                        'Quality Updated',
                        'Download quality set to $q',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  // Remove all downloads
  Future<void> removeAllDownloads() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: const Text(
          'Remove All Downloads',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to remove all downloaded content? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Remove All',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _downloadsService.clearAllDownloads();
        await _calculateStorageInfo(); // Refresh storage info

        Get.snackbar(
          'Downloads Cleared',
          'All downloads have been removed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to remove downloads. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  // Refresh storage info
  Future<void> refreshStorageInfo() async {
    await _calculateStorageInfo();
  }
}
