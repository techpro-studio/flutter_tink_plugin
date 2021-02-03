package studio.techpro.tink_plugin

import android.app.Activity
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import android.content.Intent
import android.webkit.URLUtil

class TinkPlugin: FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener {
    private lateinit var channel : MethodChannel
    private lateinit var activityPluginBinding: ActivityPluginBinding
    private lateinit var result: MethodChannel.Result

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "studio.techpro.tink_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        if (call.method == "authenticate") {
            val errCode = "studio.techpro.tink_plugin.error.invalid_input"
            val urlString = call.argument("url") as? String
            if (urlString == null) {
                result.error(errCode, "String `url` not exists", null)
                return
            }
            if (!URLUtil.isValidUrl(urlString)){
                result.error(errCode, "URL should be valid", null)
                return
            }
            if (!URLUtil.isHttpUrl(urlString) && !URLUtil.isHttpsUrl(urlString)){
                result.error(errCode, "URL should be http or https", null)
                return
            }
            this.result = result
            runAuthActivity(urlString)
        } else {
            result.notImplemented()
        }
    }

    private fun runAuthActivity(authURL: String){
        val intent = Intent(activityPluginBinding.activity, TinkAuthActivity::class.java)
        intent.putExtra("url", authURL)
        activityPluginBinding.activity.startActivityForResult(intent, TinkAuthConst.intentCode)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == TinkAuthConst.intentCode && data != null) {
                result.success(data.getStringExtra(TinkAuthConst.resultKey))
                return true
            }
        }
        return false
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activityPluginBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.activityPluginBinding.removeActivityResultListener(this)
        this.activityPluginBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activityPluginBinding.removeActivityResultListener(this)
    }


}