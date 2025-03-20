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
    await FlutterComscorePlatform.instance.startComscore(
      userConsent: userConsent,
      isChildDirected: isChildDirected,
      debug: debug,
    );
  }
}
