import 'dart:async';

import 'package:flutter/services.dart';

class Fileaudioplayer {
  static const MethodChannel _channel = const MethodChannel('fileaudioplayer');

  Fileaudioplayer();

  Future<void> start(String path) async {
    try {
      await _channel.invokeMethod("start", path);
    } on PlatformException catch (e) {
      print("Stream start error : $e");
    }
  }

  Future<void> stop() async {
    try {
      await _channel.invokeMethod("stop");
    } on PlatformException catch (e) {
      print("Stream stop error : $e");
    }
  }

  Future<void> pause() async {
    try {
      await _channel.invokeMethod("pause");
    } on PlatformException catch (e) {
      print("Stream pause error : $e");
    }
  }

  Future<void> resume() async {
    try {
      await _channel.invokeMethod("resume");
    } on PlatformException catch (e) {
      print("Stream resume error : $e");
    }
  }
}
