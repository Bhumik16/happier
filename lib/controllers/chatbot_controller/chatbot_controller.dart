import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import '../auth_controller/auth_controller.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'text': text,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
  };

  // Create from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    text: json['text'],
    isUser: json['isUser'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class ChatbotController extends GetxController {
  final Logger _logger = Logger();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;
  final RxBool isInitialized = false.obs;
  final TextEditingController messageController = TextEditingController();

  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void onInit() {
    super.onInit();
    _initializeAI();
    _loadChatHistory();
  }

  // ✅ Load chat history from SharedPreferences (USER-SPECIFIC)
  Future<void> _loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // ✅ Get current user ID from AuthController
      String userId = 'guest';
      try {
        final authController = Get.find<AuthController>();
        userId = authController.user?.uid ?? 'guest';
      } catch (e) {
        _logger.w('⚠️ AuthController not found, using guest mode');
      }

      // ✅ Use user-specific key: chat_history_USER_ID
      final String chatKey = 'chat_history_$userId';
      final String? chatHistoryJson = prefs.getString(chatKey);

      if (chatHistoryJson != null && chatHistoryJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(chatHistoryJson);
        messages.value = decoded
            .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
            .toList();
        _logger.i('✅ Loaded ${messages.length} messages for user: $userId');
      } else {
        _logger.i('ℹ️ No chat history found for user: $userId');
        _sendWelcomeMessage();
      }
    } catch (e) {
      _logger.w('⚠️ Error loading chat history: $e');
      _sendWelcomeMessage();
    }
  }

  // ✅ Save chat history to SharedPreferences (USER-SPECIFIC)
  Future<void> _saveChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // ✅ Get current user ID from AuthController
      String userId = 'guest';
      try {
        final authController = Get.find<AuthController>();
        userId = authController.user?.uid ?? 'guest';
      } catch (e) {
        print('⚠️ AuthController not found, using guest mode');
      }

      // ✅ Use user-specific key: chat_history_USER_ID
      final String chatKey = 'chat_history_$userId';
      final String chatHistoryJson = json.encode(
        messages.map((msg) => msg.toJson()).toList(),
      );
      await prefs.setString(chatKey, chatHistoryJson);
      _logger.i('✅ Chat saved for user: $userId (${messages.length} messages)');
    } catch (e) {
      _logger.e('❌ Error saving chat history: $e');
    }
  }

  // Initialize Gemini AI with .env API key
  void _initializeAI() {
    try {
      // Load API key from .env file
      final apiKey = dotenv.env['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        _logger.e('❌ ERROR: GEMINI_API_KEY not found in .env file!');
        Get.snackbar(
          'Configuration Error',
          'Chatbot API key is missing. Please add GEMINI_API_KEY to your .env file.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      _logger.i('✅ Gemini API key loaded successfully');

      // ✅ Try multiple model options in order of preference
      final modelOptions = [
        'gemini-2.0-flash-exp',
        'gemini-1.5-flash-latest',
        'gemini-1.5-flash',
        'gemini-1.5-pro-latest',
        'gemini-pro',
      ];

      String? workingModel;

      // Try to initialize with the first available model
      for (final modelName in modelOptions) {
        try {
          _logger.d('🔄 Trying model: $modelName');

          _model = GenerativeModel(
            model: modelName,
            apiKey: apiKey,
            generationConfig: GenerationConfig(
              temperature: 0.7,
              topK: 40,
              topP: 0.95,
              maxOutputTokens: 2048,
            ),
            safetySettings: [
              SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
              SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
              SafetySetting(
                HarmCategory.dangerousContent,
                HarmBlockThreshold.medium,
              ),
              SafetySetting(
                HarmCategory.sexuallyExplicit,
                HarmBlockThreshold.medium,
              ),
            ],
          );

          workingModel = modelName;
          _logger.i('✅ Successfully initialized with model: $modelName');
          break;
        } catch (e) {
          _logger.w('⚠️ Model $modelName failed: $e');
          continue;
        }
      }

      if (workingModel == null) {
        throw Exception('No compatible model found');
      }

      // Start chat with context
      _chat = _model.startChat(
        history: [
          Content.text(
            'You are a helpful meditation and wellness coach for the Happier Meditation app. '
            'Your role is to answer questions about:\n'
            '- Meditation techniques and practices\n'
            '- Mindfulness exercises\n'
            '- Diet and nutrition for mental wellness\n'
            '- Stress management and relaxation\n'
            '- Sleep improvement tips\n'
            '- Building meditation habits\n'
            '- Breathing exercises and mindfulness\n\n'
            'Keep responses concise (2-3 paragraphs max), friendly, and encouraging. '
            'Always promote a calm and positive mindset. Use emojis occasionally to keep it warm and friendly.',
          ),
        ],
      );

      isInitialized.value = true;
      print('✅ Gemini chatbot initialized successfully with $workingModel');

      Get.snackbar(
        'Chatbot Ready! 🤖',
        'Using model: $workingModel',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFDB813),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _logger.e('❌ Error initializing Gemini AI: $e');
      Get.snackbar(
        'Initialization Error',
        'Failed to initialize chatbot. Please check your API key and internet connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  // Send welcome message
  void _sendWelcomeMessage() {
    messages.add(
      ChatMessage(
        text:
            "Hi! 👋 I'm your Happier meditation assistant.\n\n"
            "I can help you with:\n"
            "• Meditation techniques\n"
            "• Mindfulness practices\n"
            "• Diet & wellness tips\n"
            "• Stress management\n"
            "• Sleep improvement\n\n"
            "What would you like to know?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  // Send user message
  Future<void> sendMessage() async {
    _logger.d('🔵 sendMessage() called');
    _logger.d('🔵 isInitialized: ${isInitialized.value}');

    if (!isInitialized.value) {
      _logger.w('❌ Chatbot not initialized');
      Get.snackbar(
        'Chatbot Not Ready',
        'Please wait for the chatbot to initialize...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final text = messageController.text.trim();
    _logger.d('🔵 Message text: "$text"');

    if (text.isEmpty) {
      _logger.w('❌ Message is empty');
      return;
    }

    _logger.i('✅ Adding user message to chat');

    // Add user message
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);
    _logger.i('✅ User message added, total messages: ${messages.length}');

    messageController.clear();
    isTyping.value = true;

    // ✅ Save after user message
    await _saveChatHistory();

    try {
      _logger.d('🔄 Sending to Gemini AI...');
      // Send to Gemini AI
      final response = await _chat.sendMessage(Content.text(text));
      final aiText = response.text ?? 'Sorry, I couldn\'t generate a response.';

      _logger.i(
        '✅ Got AI response: ${aiText.length > 50 ? aiText.substring(0, 50) + "..." : aiText}',
      );

      // Add AI response
      final aiMessage = ChatMessage(
        text: aiText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(aiMessage);
      _logger.i('✅ AI message added, total messages: ${messages.length}');

      // ✅ Save after AI response
      await _saveChatHistory();
    } catch (e) {
      _logger.e('❌ Error in sendMessage: $e');
      // Error handling
      final errorMessage = ChatMessage(
        text:
            'Sorry, I encountered an error. Please try again or rephrase your question.\n\nError: ${e.toString().contains('not found') ? 'Model compatibility issue' : 'Connection error'}',
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(errorMessage);
      await _saveChatHistory();
      _logger.e('❌ Chatbot error: $e');
    } finally {
      isTyping.value = false;
      _logger.d('✅ sendMessage() completed');
    }
  }

  // Clear chat history
  Future<void> clearChat() async {
    messages.clear();
    _sendWelcomeMessage();
    await _saveChatHistory();
    Get.snackbar(
      'Chat Cleared',
      'Conversation history has been reset',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
