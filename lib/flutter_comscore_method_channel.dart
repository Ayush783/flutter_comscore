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
    methodChannel.invokeMethod<String>(
        'setup',
        jsonEncode({
          'userConsent': userConsent,
          'isChildDirected': isChildDirected,
          'debug': debug
        }));
  }

  @override
  Future<void> notifyViewEvent(
      {required String category, Map<String, String>? eventData}) async {
    methodChannel.invokeMethod<String>(
      'notifyViewEvent',
      jsonEncode({
        if (eventData != null) 'eventData': eventData,
        'category': category
      }),
    );
  }

  @override
  Future<void> notifyBackgroundUxStart() async {
    methodChannel.invokeMethod<String>('notifyBackgroundUXStart');
  }

  @override
  Future<void> notifyBackgroundUxStop() async {
    methodChannel.invokeMethod<String>('notifyBackgroundUXStop');
  }

  @override
  Future<void> setUserConsent({required int userConsent}) async {
    methodChannel.invokeMethod<String>(
        'setUserConsent', userConsent.toString());
  }
}
