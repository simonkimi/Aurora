///
//  Generated code. Do not modify.
//  source: config.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CMYKWConfigPB extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CMYKWConfigPB', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'GKwM', $pb.PbFieldType.OD, protoName: 'G_kwM')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'GWMax', $pb.PbFieldType.OD, protoName: 'G_W_max')
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'GKMin', $pb.PbFieldType.OD, protoName: 'G_K_min')
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'GKw1', $pb.PbFieldType.OD, protoName: 'G_kw1')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Ka', $pb.PbFieldType.OD, protoName: 'Ka')
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Kb1', $pb.PbFieldType.OD, protoName: 'Kb1')
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Kb2', $pb.PbFieldType.OD, protoName: 'Kb2')
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Kc', $pb.PbFieldType.OD, protoName: 'Kc')
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ts', $pb.PbFieldType.OD)
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'xy11', $pb.PbFieldType.OD)
    ..a<$core.double>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'xy12', $pb.PbFieldType.OD)
    ..a<$core.double>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'xy21', $pb.PbFieldType.OD)
    ..a<$core.double>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'xy22', $pb.PbFieldType.OD)
    ..a<$core.double>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'xy31', $pb.PbFieldType.OD)
    ..a<$core.double>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'xy32', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  CMYKWConfigPB._() : super();
  factory CMYKWConfigPB({
    $core.double? gKwM,
    $core.double? gWMax,
    $core.double? gKMin,
    $core.double? gKw1,
    $core.double? ka,
    $core.double? kb1,
    $core.double? kb2,
    $core.double? kc,
    $core.double? ts,
    $core.double? xy11,
    $core.double? xy12,
    $core.double? xy21,
    $core.double? xy22,
    $core.double? xy31,
    $core.double? xy32,
  }) {
    final _result = create();
    if (gKwM != null) {
      _result.gKwM = gKwM;
    }
    if (gWMax != null) {
      _result.gWMax = gWMax;
    }
    if (gKMin != null) {
      _result.gKMin = gKMin;
    }
    if (gKw1 != null) {
      _result.gKw1 = gKw1;
    }
    if (ka != null) {
      _result.ka = ka;
    }
    if (kb1 != null) {
      _result.kb1 = kb1;
    }
    if (kb2 != null) {
      _result.kb2 = kb2;
    }
    if (kc != null) {
      _result.kc = kc;
    }
    if (ts != null) {
      _result.ts = ts;
    }
    if (xy11 != null) {
      _result.xy11 = xy11;
    }
    if (xy12 != null) {
      _result.xy12 = xy12;
    }
    if (xy21 != null) {
      _result.xy21 = xy21;
    }
    if (xy22 != null) {
      _result.xy22 = xy22;
    }
    if (xy31 != null) {
      _result.xy31 = xy31;
    }
    if (xy32 != null) {
      _result.xy32 = xy32;
    }
    return _result;
  }
  factory CMYKWConfigPB.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CMYKWConfigPB.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CMYKWConfigPB clone() => CMYKWConfigPB()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CMYKWConfigPB copyWith(void Function(CMYKWConfigPB) updates) => super.copyWith((message) => updates(message as CMYKWConfigPB)) as CMYKWConfigPB; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CMYKWConfigPB create() => CMYKWConfigPB._();
  CMYKWConfigPB createEmptyInstance() => create();
  static $pb.PbList<CMYKWConfigPB> createRepeated() => $pb.PbList<CMYKWConfigPB>();
  @$core.pragma('dart2js:noInline')
  static CMYKWConfigPB getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CMYKWConfigPB>(create);
  static CMYKWConfigPB? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get gKwM => $_getN(0);
  @$pb.TagNumber(1)
  set gKwM($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGKwM() => $_has(0);
  @$pb.TagNumber(1)
  void clearGKwM() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get gWMax => $_getN(1);
  @$pb.TagNumber(2)
  set gWMax($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGWMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearGWMax() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get gKMin => $_getN(2);
  @$pb.TagNumber(3)
  set gKMin($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGKMin() => $_has(2);
  @$pb.TagNumber(3)
  void clearGKMin() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get gKw1 => $_getN(3);
  @$pb.TagNumber(4)
  set gKw1($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasGKw1() => $_has(3);
  @$pb.TagNumber(4)
  void clearGKw1() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get ka => $_getN(4);
  @$pb.TagNumber(5)
  set ka($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasKa() => $_has(4);
  @$pb.TagNumber(5)
  void clearKa() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get kb1 => $_getN(5);
  @$pb.TagNumber(6)
  set kb1($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasKb1() => $_has(5);
  @$pb.TagNumber(6)
  void clearKb1() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get kb2 => $_getN(6);
  @$pb.TagNumber(7)
  set kb2($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasKb2() => $_has(6);
  @$pb.TagNumber(7)
  void clearKb2() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get kc => $_getN(7);
  @$pb.TagNumber(8)
  set kc($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasKc() => $_has(7);
  @$pb.TagNumber(8)
  void clearKc() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get ts => $_getN(8);
  @$pb.TagNumber(9)
  set ts($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTs() => $_has(8);
  @$pb.TagNumber(9)
  void clearTs() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get xy11 => $_getN(9);
  @$pb.TagNumber(10)
  set xy11($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasXy11() => $_has(9);
  @$pb.TagNumber(10)
  void clearXy11() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get xy12 => $_getN(10);
  @$pb.TagNumber(11)
  set xy12($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasXy12() => $_has(10);
  @$pb.TagNumber(11)
  void clearXy12() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get xy21 => $_getN(11);
  @$pb.TagNumber(12)
  set xy21($core.double v) { $_setDouble(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasXy21() => $_has(11);
  @$pb.TagNumber(12)
  void clearXy21() => clearField(12);

  @$pb.TagNumber(13)
  $core.double get xy22 => $_getN(12);
  @$pb.TagNumber(13)
  set xy22($core.double v) { $_setDouble(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasXy22() => $_has(12);
  @$pb.TagNumber(13)
  void clearXy22() => clearField(13);

  @$pb.TagNumber(14)
  $core.double get xy31 => $_getN(13);
  @$pb.TagNumber(14)
  set xy31($core.double v) { $_setDouble(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasXy31() => $_has(13);
  @$pb.TagNumber(14)
  void clearXy31() => clearField(14);

  @$pb.TagNumber(15)
  $core.double get xy32 => $_getN(14);
  @$pb.TagNumber(15)
  set xy32($core.double v) { $_setDouble(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasXy32() => $_has(14);
  @$pb.TagNumber(15)
  void clearXy32() => clearField(15);
}

