package studio.techpro.tink_plugin

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import java.net.URL
import java.net.URLDecoder


object TinkAuthConst {
    const val resultKey = "result"
    const val intentCode = 23
}

fun URL.extractQueryParam(name: String): String? {
    if (!this.query.contains(name)){
        return null
    }
    val parameters = this.query.split("&");
    for (param in parameters){
        val keyValue = param.split("=")
        if (keyValue[0] == name){
            return URLDecoder.decode(keyValue[1], "UTF-8")
        }
    }
    return null
}

class TinkAuthActivity : AppCompatActivity() {

    fun setResult(result: TinkAuthResult) {
        val intent = Intent()
        intent.putExtra(TinkAuthConst.resultKey, result.asJSONString())
        setResult(Activity.RESULT_OK, intent)
    }

    override fun onBackPressed() {
        setResult(TinkAuthResult(TinkAuthResultState.userCancelled))
        super.onBackPressed()
    }

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val url = intent.getStringExtra("url")
        this.title = "Tink authentication"
        val webView = WebView(this)
        setContentView(webView)
        webView.clearCache(true)
        webView.settings.useWideViewPort = true
        webView.settings.loadWithOverviewMode = true
        webView.settings.javaScriptEnabled = true
        webView.webViewClient = object : WebViewClient() {

            override fun onPageStarted(view: WebView?, urlString: String?, favicon: Bitmap?) {
                val redirects =  mutableListOf(URL(url).extractQueryParam("redirect_uri")!!);
                val appURL = URL(url).extractQueryParam("app_uri");
                if (appURL != null){
                    redirects.add(appURL)
                }
                val extracted = TinkAuthDataExtractor.extractDataFrom(Uri.parse(urlString), redirects)
                 if (extracted != null) {
                    setResult(extracted)
                    finish()
                }
            }
        }
        webView.loadUrl(url)
    }

}