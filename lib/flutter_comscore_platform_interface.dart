import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_comscore_method_channel.dart';

abstract class FlutterComscorePlatform extends PlatformInterface {
  /// Constructs a FlutterComscorePlatform.
  FlutterComscorePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterComscorePlatform _instance = MethodChannelFlutterComscore();

  /// The default instance of [FlutterComscorePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterComscore].
  static FlutterComscorePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterComscorePlatform] when
  /// they register themselves.
  static set instance(FlutterComscorePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> startComscore(
      {int? userConsent, bool isChildDirected = false, bool debug = false}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
