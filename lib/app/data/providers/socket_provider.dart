import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/shared/constants/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider extends GetxService {
  late IO.Socket socket;

  @override
  void onInit() {
    super.onInit();
    // نقوم بإنشاء كائن الـ socket ولكن لا نتصل به تلقائياً
    socket = IO.io(ApiConstants.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, // مهم جداً: لا تتصل تلقائياً
    });

    socket.onConnect((_) {
      print('Socket connected: ${socket.id}');
    });
    socket.onDisconnect((_) => print('Socket disconnected'));
    socket.onConnectError((data) => print('Connection Error: $data'));
    socket.onError((data) => print('Socket Error: $data'));
  }

  /// دالة عامة لبدء الاتصال بالخادم
  void connect() {
    if (!socket.connected) {
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

