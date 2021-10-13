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
