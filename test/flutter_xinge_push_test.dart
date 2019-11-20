import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_xinge_push/flutter_xinge_push.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_xinge_push');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterXingePush.platformVersion, '42');
  });
}
