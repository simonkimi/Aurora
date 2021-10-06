import 'dart:async';
import 'dart:io';


class UdpClient {
  factory UdpClient() {
    return _instance;
  }

  UdpClient._();

  static final UdpClient _instance = UdpClient._();

  Future<String> findPi() async {
    RawDatagramSocket? socket;
    StreamSubscription? listener;
    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 9999);
    final completer = Completer<String>();
    listener = socket.listen((event) {
      final message = socket!.receive();
      if (message != null &&
          String.fromCharCodes(message.data) == 'pi_im_here') {
        if (!completer.isCompleted) {
          completer.complete(message.address.address);
        }
      }
    });

    Timer.periodic(const Duration(seconds: 10), (timer) {
      listener?.cancel();
      socket?.close();
    });
    return completer.future;
  }
}
