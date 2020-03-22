import 'dart:async';

import 'package:flutter/services.dart';

class Fileaudioplayer {
  static const MethodChannel _channel =
      const MethodChannel('fileaudioplayer');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
