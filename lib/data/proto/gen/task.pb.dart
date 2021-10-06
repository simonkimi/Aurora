///
//  Generated code. Do not modify.
//  source: task.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ColorPb extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ColorPb', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'red', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'green', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blue', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ColorPb._() : super();
  factory ColorPb({
    $core.int? red,
    $core.int? green,
    $core.int? blue,
  }) {
    final _result = create();
    if (red != null) {
      _result.red = red;
    }
    if (green != null) {
      _result.green = green;
    }
    if (blue != null) {
      _result.blue = blue;
    }
    return _result;
  }
  factory ColorPb.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ColorPb.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ColorPb clone() => ColorPb()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ColorPb copyWith(void Function(ColorPb) updates) => super.copyWith((message) => updates(message as ColorPb)) as ColorPb; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ColorPb create() => ColorPb._();
  ColorPb createEmptyInstance() => create();
  static $pb.PbList<ColorPb> createRepeated() => $pb.PbList<ColorPb>();
  @$core.pragma('dart2js:noInline')
  static ColorPb getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ColorPb>(create);
  static ColorPb? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get red => $_getIZ(0);
  @$pb.TagNumber(1)
  set red($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRed() => $_has(0);
  @$pb.TagNumber(1)
  void clearRed() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get green => $_getIZ(1);
  @$pb.TagNumber(2)
  set green($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGreen() => $_has(1);
  @$pb.TagNumber(2)
  void clearGreen() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get blue => $_getIZ(2);
  @$pb.TagNumber(3)
  set blue($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBlue() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlue() => clearField(3);
}

class LooperPb extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LooperPb', createEmptyInstance: create)
    ..pc<ColorPb>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'colorList', $pb.PbFieldType.PM, protoName: 'colorList', subBuilder: ColorPb.create)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loopTime', $pb.PbFieldType.O3, protoName: 'loopTime')
    ..hasRequiredFields = false
  ;

  LooperPb._() : super();
  factory LooperPb({
    $core.Iterable<ColorPb>? colorList,
    $core.int? loopTime,
  }) {
    final _result = create();
    if (colorList != null) {
      _result.colorList.addAll(colorList);
    }
    if (loopTime != null) {
      _result.loopTime = loopTime;
    }
    return _result;
  }
  factory LooperPb.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LooperPb.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LooperPb clone() => LooperPb()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LooperPb copyWith(void Function(LooperPb) updates) => super.copyWith((message) => updates(message as LooperPb)) as LooperPb; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LooperPb create() => LooperPb._();
  LooperPb createEmptyInstance() => create();
  static $pb.PbList<LooperPb> createRepeated() => $pb.PbList<LooperPb>();
  @$core.pragma('dart2js:noInline')
  static LooperPb getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LooperPb>(create);
  static LooperPb? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ColorPb> get colorList => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get loopTime => $_getIZ(1);
  @$pb.TagNumber(2)
  set loopTime($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLoopTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoopTime() => clearField(2);
}

class TaskPb extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TaskPb', createEmptyInstance: create)
    ..pc<LooperPb>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loop', $pb.PbFieldType.PM, subBuilder: LooperPb.create)
    ..pc<ColorPb>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'colorList', $pb.PbFieldType.PM, protoName: 'colorList', subBuilder: ColorPb.create)
    ..hasRequiredFields = false
  ;

  TaskPb._() : super();
  factory TaskPb({
    $core.Iterable<LooperPb>? loop,
    $core.Iterable<ColorPb>? colorList,
  }) {
    final _result = create();
    if (loop != null) {
      _result.loop.addAll(loop);
    }
    if (colorList != null) {
      _result.colorList.addAll(colorList);
    }
    return _result;
  }
  factory TaskPb.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TaskPb.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TaskPb clone() => TaskPb()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TaskPb copyWith(void Function(TaskPb) updates) => super.copyWith((message) => updates(message as TaskPb)) as TaskPb; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TaskPb create() => TaskPb._();
  TaskPb createEmptyInstance() => create();
  static $pb.PbList<TaskPb> createRepeated() => $pb.PbList<TaskPb>();
  @$core.pragma('dart2js:noInline')
  static TaskPb getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TaskPb>(create);
  static TaskPb? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<LooperPb> get loop => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<ColorPb> get colorList => $_getList(1);
}

