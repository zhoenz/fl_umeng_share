
import 'dart:async';

import 'package:flutter/services.dart';

class FlUmengShare {
  static const MethodChannel _channel =
      const MethodChannel('fl_umeng_share');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
