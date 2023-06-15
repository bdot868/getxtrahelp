package com.app.xtrahelpcaregiver.Ui

import android.os.Bundle
import android.view.View
import android.webkit.WebView
import android.webkit.WebViewClient
import com.app.xtrahelpcaregiver.R
import kotlinx.android.synthetic.main.activity_file_open.*
import kotlinx.android.synthetic.main.header.*

class FileOpenActivity : BaseActivity() {
    private var url = ""
    private var name = ""
    private var fullurl = ""

    companion object {
        val EXTRA_FILE_URL = "EXTRA_FILE_URL"
        val EXTRA_FILE_NAME = "EXTRA_FILE_NAME"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_file_open)
        init()
        url = intent.getStringExtra(EXTRA_FILE_URL)!!
        name = intent.getStringExtra(EXTRA_FILE_NAME)!!
        txtTitle.setText(name)
        webView.webViewClient = AppWebViewClients()
        webView.getSettings().setJavaScriptEnabled(true)
        fullurl = "http://docs.google.com/gview?embedded=true&url=$url"
        webView.loadUrl("http://docs.google.com/gview?embedded=true&url=$url")
    }

    class AppWebViewClients : WebViewClient() {
        override fun shouldOverrideUrlLoading(view: WebView, fullurl: String): Boolean {
            view.loadUrl(fullurl)
            return true
        }

        override fun onPageFinished(view: WebView, fullurl: String) {
            super.onPageFinished(view, fullurl)
        }
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }
}