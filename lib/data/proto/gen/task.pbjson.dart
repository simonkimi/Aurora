///
//  Generated code. Do not modify.
//  source: task.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use colorPbDescriptor instead')
const ColorPb$json = const {
  '1': 'ColorPb',
  '2': const [
    const {'1': 'red', '3': 1, '4': 1, '5': 5, '10': 'red'},
    const {'1': 'green', '3': 2, '4': 1, '5': 5, '10': 'green'},
    const {'1': 'blue', '3': 3, '4': 1, '5': 5, '10': 'blue'},
  ],
};

/// Descriptor for `ColorPb`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List colorPbDescriptor = $convert.base64Decode('CgdDb2xvclBiEhAKA3JlZBgBIAEoBVIDcmVkEhQKBWdyZWVuGAIgASgFUgVncmVlbhISCgRibHVlGAMgASgFUgRibHVl');
@$core.Deprecated('Use looperPbDescriptor instead')
const LooperPb$json = const {
  '1': 'LooperPb',
  '2': const [
    const {'1': 'colorList', '3': 1, '4': 3, '5': 11, '6': '.ColorPb', '10': 'colorList'},
    const {'1': 'loopTime', '3': 2, '4': 1, '5': 5, '10': 'loopTime'},
  ],
};

/// Descriptor for `LooperPb`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List looperPbDescriptor = $convert.base64Decode('CghMb29wZXJQYhImCgljb2xvckxpc3QYASADKAsyCC5Db2xvclBiUgljb2xvckxpc3QSGgoIbG9vcFRpbWUYAiABKAVSCGxvb3BUaW1l');
@$core.Deprecated('Use taskPbDescriptor instead')
const TaskPb$json = const {
  '1': 'TaskPb',
  '2': const [
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'loop', '3': 1, '4': 3, '5': 11, '6': '.LooperPb', '10': 'loop'},
    const {'1': 'colorList', '3': 2, '4': 3, '5': 11, '6': '.ColorPb', '10': 'colorList'},
  ],
};

/// Descriptor for `TaskPb`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskPbDescriptor = $convert.base64Decode('CgZUYXNrUGISEgoEbmFtZRgDIAEoCVIEbmFtZRIdCgRsb29wGAEgAygLMgkuTG9vcGVyUGJSBGxvb3ASJgoJY29sb3JMaXN0GAIgAygLMgguQ29sb3JQYlIJY29sb3JMaXN0');
