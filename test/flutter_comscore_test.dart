import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_comscore/flutter_comscore.dart';
import 'package:flutter_comscore/flutter_comscore_platform_interface.dart';
import 'package:flutter_comscore/flutter_comscore_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterComscorePlatform
    with MockPlatformInterfaceMixin
    implements FlutterComscorePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterComscorePlatform initialPlatform = FlutterComscorePlatform.instance;

  test('$MethodChannelFlutterComscore is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterComscore>());
  });

  test('getPlatformVersion', () async {
    FlutterComscore flutterComscorePlugin = FlutterComscore();
    MockFlutterComscorePlatform fakePlatform = MockFlutterComscorePlatform();
    FlutterComscorePlatform.instance = fakePlatform;

    expect(await flutterComscorePlugin.getPlatformVersion(), '42');
  });
}
