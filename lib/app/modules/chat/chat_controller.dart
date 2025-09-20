import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/socket_provider.dart';

// نموذج بيانات بسيط لتمثيل الرسالة داخل واجهة المستخدم
class ChatMessage {
  final String content;
  final bool isSentByMe; // لتحديد ما إذا كانت الرسالة مرسلة من المستخدم الحالي أم مستلمة

  ChatMessage({required this.content, required this.isSentByMe});
}

class ChatController extends GetxController {
  // حقن SocketProvider للعثور على النسخة النشطة منه
  final SocketProvider _socketProvider = Get.find<SocketProvider>();

  // قائمة الرسائل، ستكون تفاعلية (reactive) بفضل .obs
  var messages = <ChatMessage>[].obs;

  // متحكم في حقل إدخال النص
  final messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  void _initializeChat() {
    // بدء الاتصال بالخادم عند فتح شاشة الدردشة
    _socketProvider.connect();

    // إضافة رسالة ترحيبية أولية
    messages.add(ChatMessage(
      content: 'أهلاً بك في Gourmet Pro! كيف يمكننا مساعدتك اليوم؟',
      isSentByMe: false,
    ));

    // الاستماع لحدث "receiveMessage" القادم من الخادم
    _socketProvider.socket.on('receiveMessage', (data) {
      if (data is Map<String, dynamic> && data.containsKey('content')) {
        // إنشاء كائن رسالة جديد وإضافته إلى القائمة
        // نفترض أن أي رسالة قادمة من الخادم هي من فريق الدعم
        final receivedMessage = ChatMessage(
          content: data['content'],
          isSentByMe: false,
        );
        messages.add(receivedMessage);
      }
    });
  }

  // دالة لإرسال رسالة جديدة
  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      final message = ChatMessage(content: text, isSentByMe: true);
      messages.add(message); // إضافة الرسالة إلى الواجهة فوراً

      // إرسال الرسالة إلى الخادم عبر حدث "sendMessage"
      // ملاحظة: في تطبيق حقيقي، يجب أن يكون threadId ديناميكياً
      _socketProvider.socket.emit('sendMessage', {
        'content': text,
        'threadId': 'mock_thread_id_for_now',
      });

      messageController.clear(); // مسح حقل الإدخال بعد الإرسال
    }
  }

  @override
  void onClose() {
    // قطع الاتصال بالخادم عند إغلاق الشاشة لتوفير الموارد
    _socketProvider.disconnect();
    messageController.dispose();
    super.onClose();
  }
}

