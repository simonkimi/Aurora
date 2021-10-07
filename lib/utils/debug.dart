import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension DebugWidget on Widget {
  Widget colored([Color? color]) => kReleaseMode
      ? this
      : Container(
          color: color ?? Colors.red,
          child: this,
        );
}
