import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gourmet_pro_app/app/shared/constants/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider extends GetxService {
  late IO.Socket socket;
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // إنشاء socket للدردشة مع namespace محدد
    socket = IO.io(
      '${ApiConstants.baseUrl}/chat', // إضافة namespace للدردشة
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setPath('/socket.io')
          .setAuth({'token': _storage.read('token')})
          .setExtraHeaders({'Authorization': 'Bearer ${_storage.read('token')}'})
          .enableAutoConnect() // تفعيل الاتصال التلقائي للدردشة
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .build(),
    );

    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    socket.onConnect((_) {
      print('Chat socket connected: ${socket.id}');
    });

    socket.onDisconnect((_) {
      print('Chat socket disconnected');
    });

    socket.onConnectError((data) {
      print('Chat connection error: $data');
    });

    socket.onError((data) {
      print('Chat socket error: $data');
    });

    // استماع لرسالة الترحيب
    socket.on('connected', (data) {
      print('Chat connected successfully: $data');
    });

    // استماع لرسائل الدردشة
    socket.on('chat', (data) {
      print('New chat message received: $data');
      // يمكن إضافة معالجة إضافية هنا
    });
  }

  /// دالة عامة لبدء الاتصال بالخادم
  void connect() {
    if (!socket.connected) {
      // تحديث التوكن قبل الاتصال
      final token = _storage.read('token');
      if (token != null) {
        socket.auth = {'token': token};
        socket.io.options?['extraHeaders'] = {'Authorization': 'Bearer $token'};
        socket.connect();
      } else {
        print('No token found, cannot connect to chat');
      }
    }
  }

  /// دالة عامة لإنهاء الاتصال بالخادم
  void disconnect() {
    if (socket.connected) {
      socket.disconnect();
    }
  }

  /// إرسال رسالة دردشة
  void sendMessage(String content, int threadId) {
    if (socket.connected) {
      socket.emit('chat', {
        'content': content,
        'threadId': threadId,
      });
    } else {
      print('Socket not connected, cannot send message');
    }
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
