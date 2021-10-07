///
//  Generated code. Do not modify.
//  source: ble.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class PrinterColor extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PrinterColor', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'c', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'm', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.O3)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'k', $pb.PbFieldType.O3)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'w', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  PrinterColor._() : super();
  factory PrinterColor({
    $core.int? c,
    $core.int? m,
    $core.int? y,
    $core.int? k,
    $core.int? w,
  }) {
    final _result = create();
    if (c != null) {
      _result.c = c;
    }
    if (m != null) {
      _result.m = m;
    }
    if (y != null) {
      _result.y = y;
    }
    if (k != null) {
      _result.k = k;
    }
    if (w != null) {
      _result.w = w;
    }
    return _result;
  }
  factory PrinterColor.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PrinterColor.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PrinterColor clone() => PrinterColor()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PrinterColor copyWith(void Function(PrinterColor) updates) => super.copyWith((message) => updates(message as PrinterColor)) as PrinterColor; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PrinterColor create() => PrinterColor._();
  PrinterColor createEmptyInstance() => create();
  static $pb.PbList<PrinterColor> createRepeated() => $pb.PbList<PrinterColor>();
  @$core.pragma('dart2js:noInline')
  static PrinterColor getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrinterColor>(create);
  static PrinterColor? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get c => $_getIZ(0);
  @$pb.TagNumber(1)
  set c($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasC() => $_has(0);
  @$pb.TagNumber(1)
  void clearC() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get m => $_getIZ(1);
  @$pb.TagNumber(2)
  set m($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasM() => $_has(1);
  @$pb.TagNumber(2)
  void clearM() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get y => $_getIZ(2);
  @$pb.TagNumber(3)
  set y($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasY() => $_has(2);
  @$pb.TagNumber(3)
  void clearY() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get k => $_getIZ(3);
  @$pb.TagNumber(4)
  set k($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasK() => $_has(3);
  @$pb.TagNumber(4)
  void clearK() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get w => $_getIZ(4);
  @$pb.TagNumber(5)
  set w($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasW() => $_has(4);
  @$pb.TagNumber(5)
  void clearW() => clearField(5);
}

class TaskLoop extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TaskLoop', createEmptyInstance: create)
    ..p<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'colorIndex', $pb.PbFieldType.P3, protoName: 'colorIndex')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loopTime', $pb.PbFieldType.O3, protoName: 'loopTime')
    ..hasRequiredFields = false
  ;

  TaskLoop._() : super();
  factory TaskLoop({
    $core.Iterable<$core.int>? colorIndex,
    $core.int? loopTime,
  }) {
    final _result = create();
    if (colorIndex != null) {
      _result.colorIndex.addAll(colorIndex);
    }
    if (loopTime != null) {
      _result.loopTime = loopTime;
    }
    return _result;
  }
  factory TaskLoop.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TaskLoop.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TaskLoop clone() => TaskLoop()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TaskLoop copyWith(void Function(TaskLoop) updates) => super.copyWith((message) => updates(message as TaskLoop)) as TaskLoop; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TaskLoop create() => TaskLoop._();
  TaskLoop createEmptyInstance() => create();
  static $pb.PbList<TaskLoop> createRepeated() => $pb.PbList<TaskLoop>();
  @$core.pragma('dart2js:noInline')
  static TaskLoop getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TaskLoop>(create);
  static TaskLoop? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get colorIndex => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get loopTime => $_getIZ(1);
  @$pb.TagNumber(2)
  set loopTime($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLoopTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoopTime() => clearField(2);
}

class TaskMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TaskMessage', createEmptyInstance: create)
    ..pc<PrinterColor>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'palette', $pb.PbFieldType.PM, subBuilder: PrinterColor.create)
    ..pc<TaskLoop>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'taskLoop', $pb.PbFieldType.PM, protoName: 'taskLoop', subBuilder: TaskLoop.create)
    ..hasRequiredFields = false
  ;

  TaskMessage._() : super();
  factory TaskMessage({
    $core.Iterable<PrinterColor>? palette,
    $core.Iterable<TaskLoop>? taskLoop,
  }) {
    final _result = create();
    if (palette != null) {
      _result.palette.addAll(palette);
    }
    if (taskLoop != null) {
      _result.taskLoop.addAll(taskLoop);
    }
    return _result;
  }
  factory TaskMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TaskMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TaskMessage clone() => TaskMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TaskMessage copyWith(void Function(TaskMessage) updates) => super.copyWith((message) => updates(message as TaskMessage)) as TaskMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TaskMessage create() => TaskMessage._();
  TaskMessage createEmptyInstance() => create();
  static $pb.PbList<TaskMessage> createRepeated() => $pb.PbList<TaskMessage>();
  @$core.pragma('dart2js:noInline')
  static TaskMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TaskMessage>(create);
  static TaskMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<PrinterColor> get palette => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<TaskLoop> get taskLoop => $_getList(1);
}

