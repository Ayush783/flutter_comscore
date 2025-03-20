package aayushsharma.me.flutter_comscore

import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.NonNull
import com.comscore.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.serialization.json.Json

/** FlutterComscorePlugin */
class FlutterComscorePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  lateinit var applicationContext: Context
  private val PUBLISHER_ID_KEY = "com.flutterComscore.PUBLISHER_ID"
  private val LOGNAME = "FlutterComscorePlugin"
  lateinit var publisherId: String

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
    getPublisherId(applicationContext)
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_comscore")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "setup") {
      val args = call.arguments as String?
      Log.e(LOGNAME, "starting comscore: $args")
      val startComscoreArgs = Json.decodeFromString<StartComscoreArgs>(args?:"")

      startComscore(applicationContext, startComscoreArgs)
      
      result.success(null)
    } else if(call.method == "notifyViewEvent") {
      try {
        val data = call.arguments as HashMap<String, Any>
        notifyViewEvent(data["category"] as String, data["eventData"] as HashMap<String, String>?)
      } catch(e: Exception) {
        Log.e(LOGNAME, "notifyViewEvent error: $e")
        return result.error(LOGNAME, e.toString(), null)
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getPublisherId(context: Context) {
    try {
      val applicationInfo = context.packageManager.getApplicationInfo(context.packageName, PackageManager.GET_META_DATA)
      val metaData = applicationInfo.metaData
      publisherId = metaData.getInt(PUBLISHER_ID_KEY)!!.toString()

    } catch(e: Exception) {
      Log.e(LOGNAME, "Error fetching publisher id: $e")
    }
  }

  private fun startComscore(context: Context, startComscoreArgs: StartComscoreArgs) {
    // Get the publisher id from manifest
    try {
      var labels = HashMap<String,String>()
      labels["cs_ucfr"] = startComscoreArgs.userConsent?.toString() ?: ""

      val publisherConfig = PublisherConfiguration.Builder()
        .publisherId(publisherId)
        .persistentLabels(labels)
        .build()
      Analytics.getConfiguration().addClient(publisherConfig)

      Analytics.getConfiguration().setUsagePropertiesAutoUpdateMode(UsagePropertiesAutoUpdateMode.FOREGROUND_AND_BACKGROUND)

      if(startComscoreArgs.isChildDirected) {
        Analytics.getConfiguration().enableChildDirectedApplicationMode()
      }

      if(startComscoreArgs.debug) {
        Analytics.getConfiguration().enableImplementationValidationMode()
      }

      Analytics.start(context)
    } catch (e: Exception) {
      Log.e(LOGNAME, "Error starting comscore: $e")
    }
  }

  private fun notifyUxActive() {
    try {
      Analytics.notifyUxActive()
    } catch (e: Exception) {
      Log.e(LOGNAME, "Error starting comscore: $e")
    }
  }

  private fun notifyUxInactive() {
    try {
      Analytics.notifyUxInactive()
    } catch (e: Exception) {
      Log.e(LOGNAME, "Error starting comscore: $e")
    }
  }

  private fun notifyViewEvent(category: String,eventData: HashMap<String,String>?) {
    try {
      var labels = HashMap<String,String>()
      labels.putAll(eventData?: emptyMap())
      labels["ns_category"] = category
      Analytics.notifyViewEvent(labels)
    } catch (e: Exception) {
      Log.e(LOGNAME, "Error starting comscore: $e")
    }
  }

  private fun setUserConsent(userConsent: Int) {
    // Get the publisher id from manifest
    try {
      Analytics.getConfiguration().getPublisherConfiguration(publisherId).setPersistentLabel("cs_ucfr", userConsent.toString())
      Analytics.notifyHiddenEvent()
    } catch (e: Exception) {
      Log.e(LOGNAME, "Error starting comscore: $e")
    }
  }
}
