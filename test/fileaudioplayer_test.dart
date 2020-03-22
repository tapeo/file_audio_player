import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fileaudioplayer/fileaudioplayer.dart';

void main() {
  const MethodChannel channel = MethodChannel('fileaudioplayer');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Fileaudioplayer.platformVersion, '42');
  });
}
