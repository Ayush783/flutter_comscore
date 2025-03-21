import 'dart:math';

import 'flutter_comscore_platform_interface.dart';

class FlutterComscore {
  /// Run when app is launches, Should be called typically in main.dart
  /// Ask for user consent as per GDPR compliance.
  /// Possible values for [userConsent] :-
  /// 0 - Not given consent
  /// 1 - Given consent
  /// null - if no action taken by user
  ///
  /// If app is made for childrens then [isChildDirected] should be true, otherwise leave null
  static Future<void> startComscore(
      {int? userConsent,
      bool isChildDirected = false,
      bool debug = false}) async {
    FlutterComscorePlatform.instance.startComscore(
      userConsent: userConsent,
      isChildDirected: isChildDirected,
      debug: debug,
    );
  }

  static Future<void> notifyViewEvent(
      {required String category, Map<String, String>? eventData}) async {
    FlutterComscorePlatform.instance.notifyViewEvent(
      category: category,
      eventData: eventData,
    );
  }

  static Future<void> notifyBackgroundUxStart() async {
    FlutterComscorePlatform.instance.notifyBackgroundUxStart();
  }

  static Future<void> notifyBackgroundUxStop() async {
    FlutterComscorePlatform.instance.notifyBackgroundUxStop();
  }

  static Future<void> setUserConsent({required int userConsent}) async {
    FlutterComscorePlatform.instance.setUserConsent(userConsent: userConsent);
  }
}
