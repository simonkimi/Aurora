///
//  Generated code. Do not modify.
//  source: ble.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use printerColorDescriptor instead')
const PrinterColor$json = const {
  '1': 'PrinterColor',
  '2': const [
    const {'1': 'c', '3': 1, '4': 1, '5': 5, '10': 'c'},
    const {'1': 'm', '3': 2, '4': 1, '5': 5, '10': 'm'},
    const {'1': 'y', '3': 3, '4': 1, '5': 5, '10': 'y'},
    const {'1': 'k', '3': 4, '4': 1, '5': 5, '10': 'k'},
    const {'1': 'w', '3': 5, '4': 1, '5': 5, '10': 'w'},
  ],
};

/// Descriptor for `PrinterColor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List printerColorDescriptor = $convert.base64Decode('CgxQcmludGVyQ29sb3ISDAoBYxgBIAEoBVIBYxIMCgFtGAIgASgFUgFtEgwKAXkYAyABKAVSAXkSDAoBaxgEIAEoBVIBaxIMCgF3GAUgASgFUgF3');
@$core.Deprecated('Use taskLoopDescriptor instead')
const TaskLoop$json = const {
  '1': 'TaskLoop',
  '2': const [
    const {'1': 'colorIndex', '3': 1, '4': 3, '5': 5, '10': 'colorIndex'},
    const {'1': 'loopTime', '3': 2, '4': 1, '5': 5, '10': 'loopTime'},
  ],
};

/// Descriptor for `TaskLoop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskLoopDescriptor = $convert.base64Decode('CghUYXNrTG9vcBIeCgpjb2xvckluZGV4GAEgAygFUgpjb2xvckluZGV4EhoKCGxvb3BUaW1lGAIgASgFUghsb29wVGltZQ==');
@$core.Deprecated('Use taskMessageDescriptor instead')
const TaskMessage$json = const {
  '1': 'TaskMessage',
  '2': const [
    const {'1': 'palette', '3': 1, '4': 3, '5': 11, '6': '.PrinterColor', '10': 'palette'},
    const {'1': 'taskLoop', '3': 2, '4': 3, '5': 11, '6': '.TaskLoop', '10': 'taskLoop'},
  ],
};

/// Descriptor for `TaskMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskMessageDescriptor = $convert.base64Decode('CgtUYXNrTWVzc2FnZRInCgdwYWxldHRlGAEgAygLMg0uUHJpbnRlckNvbG9yUgdwYWxldHRlEiUKCHRhc2tMb29wGAIgAygLMgkuVGFza0xvb3BSCHRhc2tMb29w');
