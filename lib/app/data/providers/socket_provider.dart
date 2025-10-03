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
    // نقوم بإنشاء كائن الـ socket ولكن لا نتصل به تلقائياً
    // ✨ تم تحديث الإعدادات لتشمل المصادقة والمسار الصحيح
    socket = IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setPath('/socket.io') // المسار الافتراضي لـ socket.io
          .setAuth({'token': _storage.read('token')}) // إرسال التوكن للمصادقة
          .disableAutoConnect() // مهم جداً: لا تتصل تلقائياً
          .build(),
    );

    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    socket.onConnect((_) => print('Socket connected: ${socket.id}'));
    socket.onDisconnect((_) => print('Socket disconnected'));
    socket.onConnectError((data) => print('Connection Error: $data'));
    socket.onError((data) => print('Socket Error: $data'));
  }

  /// دالة عامة لبدء الاتصال بالخادم
  void connect() {
    if (!socket.connected) {
      // التأكد من أن التوكن محدّث قبل كل محاولة اتصال
      socket.auth = {'token': _storage.read('token')};
      socket.connect();
    }
  }

  /// دالة عامة لإنهاء الاتصال بالخادم
  void disconnect() {
    if (socket.connected) {
      socket.disconnect();
    }
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
