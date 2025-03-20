import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_comscore_platform_interface.dart';

/// An implementation of [FlutterComscorePlatform] that uses method channels.
class MethodChannelFlutterComscore extends FlutterComscorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_comscore');

  @override
  Future<void> startComscore(
      {int? userConsent,
      bool isChildDirected = false,
      bool debug = false}) async {
    await methodChannel.invokeMethod<String>(
        'setup',
        jsonEncode({
          'userConsent': userConsent,
          'isChildDirected': isChildDirected,
          'debug': debug
        }));
  }
}
