import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/chatbot_controller/chatbot_controller.dart';
import '../../../controllers/appearance_controller/appearance_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';

class ChatbotView extends StatefulWidget {
  const ChatbotView({Key? key}) : super(key: key);

  @override
  State<ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<ChatbotView> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatbotController>();
    
    return GetBuilder<AppearanceController>(
      builder: (appearanceController) {
        final theme = appearanceController.theme;
        
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.textPrimary),
              onPressed: () {
                try {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else if (Get.previousRoute.isNotEmpty && Get.previousRoute != AppRoutes.chatbot) {
                    Get.back();
                  } else {
                    Get.offAllNamed(AppRoutes.main);
                  }
                } catch (e) {
                  print('⚠️ Back navigation error: $e');
                  Get.offAllNamed(AppRoutes.main);
                }
              },
              tooltip: 'Back',
            ),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDB813),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFDB813).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Happier Assistant',
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Obx(() => Text(
                        controller.isTyping.value ? 'Typing...' : 'Online',
                        style: TextStyle(
                          color: controller.isTyping.value 
                              ? const Color(0xFFFDB813) 
                              : theme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.delete_outline, color: theme.textSecondary),
                tooltip: 'Clear chat',
                onPressed: () => _showClearConfirmation(controller, theme),
              ),
            ],
          ),
          body: Column(
            children: [
              // Chat messages
              Expanded(
                child: Obx(() {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                  
                  if (controller.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDB813).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Icon(
                              Icons.smart_toy_rounded,
                              size: 40,
                              color: Color(0xFFFDB813),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Start a conversation...',
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: controller.messages.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      return _buildMessageBubble(message, theme, index);
                    },
                  );
                }),
              ),
              
              // Typing indicator
              Obx(() {
                if (!controller.isTyping.value) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTypingDot(theme, 0),
                            const SizedBox(width: 4),
                            _buildTypingDot(theme, 1),
                            const SizedBox(width: 4),
                            _buildTypingDot(theme, 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              
              // Input field
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(
                            maxHeight: 120,
                          ),
                          child: TextField(
                            controller: controller.messageController,
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ask about meditation, diet, wellness...',
                              hintStyle: TextStyle(
                                color: theme.textSecondary,
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: theme.scaffoldBackgroundColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) {
                              print('🟢 TextField onSubmitted');
                              controller.sendMessage();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          print('🟡 BUTTON TAPPED!');
                          controller.sendMessage();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDB813),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFDB813).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMessageBubble(ChatMessage message, AppTheme theme, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFDB813),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFDB813).withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.black,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? const Color(0xFFFDB813)
                        : theme.cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.black : theme.textPrimary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    DateFormat('h:mm a').format(message.timestamp),
                    style: TextStyle(
                      color: theme.textSecondary.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.textSecondary.withOpacity(0.2),
                    theme.textSecondary.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person,
                color: theme.textPrimary,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildTypingDot(AppTheme theme, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -4 * (0.5 - (value - 0.5).abs())),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: theme.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }
  
  void _showClearConfirmation(ChatbotController controller, AppTheme theme) {
    Get.dialog(
      AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.delete_outline, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text(
              'Clear Chat History?',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'This will delete all messages in this conversation. This action cannot be undone.',
          style: TextStyle(
            color: theme.textSecondary,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearChat();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Clear',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}