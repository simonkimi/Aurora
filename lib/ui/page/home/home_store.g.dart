// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on HomeStoreBase, Store {
  final _$selectColorAtom = Atom(name: 'HomeStoreBase.selectColor');

  @override
  Color get selectColor {
    _$selectColorAtom.reportRead();
    return super.selectColor;
  }

  @override
  set selectColor(Color value) {
    _$selectColorAtom.reportWrite(value, super.selectColor, () {
      super.selectColor = value;
    });
  }

  final _$isConnectAtom = Atom(name: 'HomeStoreBase.isConnect');

  @override
  bool get isConnect {
    _$isConnectAtom.reportRead();
    return super.isConnect;
  }

  @override
  set isConnect(bool value) {
    _$isConnectAtom.reportWrite(value, super.isConnect, () {
      super.isConnect = value;
    });
  }

  final _$isScanningAtom = Atom(name: 'HomeStoreBase.isScanning');

  @override
  bool get isScanning {
    _$isScanningAtom.reportRead();
    return super.isScanning;
  }

  @override
  set isScanning(bool value) {
    _$isScanningAtom.reportWrite(value, super.isScanning, () {
      super.isScanning = value;
    });
  }

  final _$initAsyncAction = AsyncAction('HomeStoreBase.init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$setColorAsyncAction = AsyncAction('HomeStoreBase.setColor');

  @override
  Future<void> setColor(Color color) {
    return _$setColorAsyncAction.run(() => super.setColor(color));
  }

  final _$connectDeviceAsyncAction = AsyncAction('HomeStoreBase.connectDevice');

  @override
  Future<bool> connectDevice() {
    return _$connectDeviceAsyncAction.run(() => super.connectDevice());
  }

  @override
  String toString() {
    return '''
selectColor: ${selectColor},
isConnect: ${isConnect},
isScanning: ${isScanning}
    ''';
  }
}
