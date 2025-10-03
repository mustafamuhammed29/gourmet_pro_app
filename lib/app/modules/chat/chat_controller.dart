import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/data/providers/socket_provider.dart';

// ✨ نموذج بيانات حقيقي يطابق بيانات الخادم
class ChatMessage {
  final String id;
  final String content;
  final int senderId;
  final DateTime createdAt;
  final bool isSentByMe;

  ChatMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.createdAt,
    required this.isSentByMe,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, int currentUserId) {
    final senderId = json['sender']['id'];
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      senderId: senderId,
      createdAt: DateTime.parse(json['createdAt']),
      isSentByMe: senderId == currentUserId,
    );
  }
}

class ChatController extends GetxController {
  final SocketProvider _socketProvider = Get.find<SocketProvider>();
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  var messages = <ChatMessage>[].obs;
  final messageController = TextEditingController();

  final isLoading = true.obs;
  int? _threadId;
  int? _currentUserId;

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      isLoading.value = true;
      // ١. جلب سجل المحادثة ومعرف المستخدم أولاً
      final response = await _apiProvider.getMyChatThread();

      if (response.isOk) {
        final data = response.body;
        _threadId = data['thread']['id'];
        _currentUserId = data['userId'];

        final List previousMessages = data['messages'];
        messages.assignAll(previousMessages
            .map((msg) => ChatMessage.fromJson(msg, _currentUserId!))
            .toList());

        // ٢. الاتصال بالـ Socket بعد الحصول على البيانات
        _socketProvider.connect();

        // ٣. الاستماع للرسائل الجديدة
        _socketProvider.socket.on('chat', (data) {
          if (data is Map<String, dynamic>) {
            final receivedMessage = ChatMessage.fromJson(data, _currentUserId!);
            // التأكد من عدم إضافة الرسالة مرتين (إذا تمت إضافتها بشكل متفائل)
            if (!messages.any((m) => m.id == receivedMessage.id)) {
              messages.insert(0, receivedMessage);
            }
          }
        });
      } else {
        throw Exception('Failed to fetch chat thread.');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تهيئة الدردشة. حاول مرة أخرى.');
    } finally {
      isLoading.value = false;
    }
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty && _threadId != null) {
      // إضافة الرسالة للواجهة فوراً لتحسين تجربة المستخدم (Optimistic UI)
      final optimisticMessage = ChatMessage(
        id: DateTime.now().toIso8601String(), // معرف مؤقت
        content: text,
        senderId: _currentUserId!,
        createdAt: DateTime.now(),
        isSentByMe: true,
      );
      messages.insert(0, optimisticMessage);

      // ٤. إرسال الرسالة إلى الخادم مع معرّف المحادثة الحقيقي
      _socketProvider.socket.emit('chat', {
        'content': text,
        'threadId': _threadId,
      });

      messageController.clear();
    }
  }

  @override
  void onClose() {
    _socketProvider.disconnect();
    messageController.dispose();
    super.onClose();
  }
}
