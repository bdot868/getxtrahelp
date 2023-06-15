package com.app.xtrahelpcaregiver.Ui

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.webkit.JavascriptInterface
import android.webkit.WebView
import android.webkit.WebViewClient
import com.app.xtrahelpcaregiver.R
import kotlinx.android.synthetic.main.activity_strip_connect.*
import org.json.JSONException
import org.json.JSONObject

class StripConnectActivity : BaseActivity() {

    companion object {
        val URLS: String = "urls"
    }

    var url: String? = null
    
    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_strip_connect)
        url = intent.getStringExtra(URLS)

        webView.webViewClient = WebViewClient()
        webView.webViewClient = WebViewClient()
        webView.settings.javaScriptEnabled = true
        val yourWebClient: WebViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView, url: String): Boolean {
                return false
            }

            override fun onPageFinished(view: WebView, url: String) {
                view.loadUrl(
                    "javascript:HtmlViewer.showHTML" +
                            "('<html>'+document.getElementsByTagName('html')[0].innerHTML+'</html>');"
                )

//                view.loadUrl("javascript:console.log(document.body.getElementsByTagName('pre')[0].innerHTML);");
            }
        }
        webView.settings.javaScriptEnabled = true
        webView.settings.setSupportZoom(true)
        webView.settings.builtInZoomControls = true
        webView.webViewClient = yourWebClient
        webView.loadUrl(url!!)
        webView.addJavascriptInterface(
          MyJavaScriptInterface(this), "HtmlViewer"
        )
    }

    internal class MyJavaScriptInterface(private val ctx: Context) {
        @JavascriptInterface
        @Throws(JSONException::class)
        fun showHTML(html: String?) {
            try {
                var output: String? = null
                output = html
                output = output!!.substring(output.indexOf("{"), output.lastIndexOf("}") + 1)
                val jsonObject = JSONObject(output)
                Log.e("skjdhfaskjdhk", "showHTML: $output")
                if (jsonObject.getBoolean("close")) {
                    (ctx as StripConnectActivity).startNewActivity()
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    fun startNewActivity() {
        startActivity(Intent(activity, BankDetailActivity::class.java))
        finish()
    }
}