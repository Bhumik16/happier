import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchViewController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  
  final RxString searchQuery = ''.obs;
  
  // Teachers data
  final List<Map<String, String>> teachers = [
    {'name': 'Joseph Goldstein', 'image': ''},
    {'name': 'Sharon Salzberg', 'image': ''},
    {'name': 'Sebene Selassie', 'image': ''},
    {'name': 'Jeff Warren', 'image': ''},
    {'name': 'Alexis Santos', 'image': ''},
    {'name': 'Diana Winston', 'image': ''},
  ];
  
  // Suggested topics
  final List<String> suggestedTopics = [
    'Self-Compassion',
    'Anxiety',
    'Loving-Kindness',
    'Lightly Guided',
    'Pain',
    'Body Scan',
    'Parenting',
    'Focus',
    'Sleep',
    'Stress',
    'Gratitude',
    'Relationships',
  ];
  
  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }
  
  void onSearchChanged(String query) {
    searchQuery.value = query;
    // Implement search logic here
    if (query.isNotEmpty) {
      print('🔍 Searching for: $query');
      // In future, filter courses, teachers, topics based on query
      // You can call a search API or filter local data
    }
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}