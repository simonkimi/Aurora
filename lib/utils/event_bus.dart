import 'package:event_bus/event_bus.dart';

class Bus {
  factory Bus() {
    return _instance;
  }

  Bus._();

  static final Bus _instance = Bus._();
  final _eventBus = EventBus();

  Stream<T> on<T>() => _eventBus.on<T>();

  void fire(dynamic event) => _eventBus.fire(event);
}

class EventBleSpeed {
  EventBleSpeed(List<int> msg)
      : c = msg[0],
        m = msg[1],
        y = msg[2],
        k = msg[3],
        w = msg[4],
        r = msg[5],
        g = msg[6],
        b = msg[7],
        assert(msg.length == 8);
  final int c;
  final int m;
  final int y;
  final int k;
  final int w;
  final int r;
  final int g;
  final int b;
}
