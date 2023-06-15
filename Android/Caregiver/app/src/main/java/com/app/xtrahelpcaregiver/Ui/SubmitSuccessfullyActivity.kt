package com.app.xtrahelpcaregiver.Ui

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import androidx.core.app.ShareCompat
import com.app.xtrahelpcaregiver.R
import kotlinx.android.synthetic.main.activity_submit_successfully.*


class SubmitSuccessfullyActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_submit_successfully)
        init()
    }


    private fun init() {
        txtOk.setOnClickListener(this)
        twitterImg.setOnClickListener(this)
        fbImg.setOnClickListener(this)
        instaImg.setOnClickListener(this)
        shareImg.setOnClickListener(this)
    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.txtOk -> onBackPressed()

            R.id.shareImg -> {
                val i = Intent(Intent.ACTION_SEND)
                i.putExtra(Intent.EXTRA_SUBJECT, "Sharing URL")
                i.putExtra(Intent.EXTRA_TEXT, "https://play.google.com/store/apps/details?id=com.app.xtrahelpcaregiver")
                startActivity(Intent.createChooser(i, "Share URL"))
            }
            R.id.fbImg -> {
                val i = Intent(Intent.ACTION_SEND)
                i.putExtra(Intent.EXTRA_SUBJECT, "Sharing URL")
                i.putExtra(Intent.EXTRA_TEXT, "https://play.google.com/store/apps/details?id=com.app.xtrahelpcaregiver")
                startActivity(Intent.createChooser(i, "Share URL"))
            }
            R.id.instaImg -> {
                ShareCompat.IntentBuilder.from(activity)
                    .setChooserTitle("title")
                    .setText("https://play.google.com/store/apps/details?id=com.app.xtrahelpcaregiver")
                    .setType("text/plain")
                    .startChooser();
            }
            R.id.twitterImg -> {
                val tweetUrl =
                    ("https://twitter.com/intent/tweet?text=WRITE Hey Please check this app &url="
                            + "https://play.google.com/store/apps/details?id=com.app.xtrahelpcaregiver")
                val uri = Uri.parse(tweetUrl)
                startActivity(Intent(Intent.ACTION_VIEW, uri))
            }
        }
    }


    override fun onBackPressed() {
        super.onBackPressed()
        loginActivity()
    }
}