# flutter_comscore


### Android 
Add Publisher id in AndroidManifest.xml under application tag:-

'''xml
<meta-data
        android:name="com.flutterComscore.PUBLISHER_ID"
        android:value="YourStringValue" />
'''

Add following to your pro-guard file:
'''
-keep class com.comscore.** { *; }
-dontwarn com.comscore.**
'''

### iOS

Add the following key to info.plist
'''
<key>FLUTTER_COMSCORE_PUBLISHER_ID</key>
<string>8549097</string>
'''

### Flutter

Call startComscore method.

FlutterComscore.startComscore()

set debug to true to test your implementation

FlutterComscore.startComscore(debug: true)