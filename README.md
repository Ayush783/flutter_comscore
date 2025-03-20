# flutter_comscore

Add Publisher id in AndroidManifest.xml under application tag:-

<meta-data
        android:name="com.flutterComscore.PUBLISHER_ID"
        android:value="YourStringValue" />

Add following to your pro-guard file:

-keep class com.comscore.** { *; }
-dontwarn com.comscore.**