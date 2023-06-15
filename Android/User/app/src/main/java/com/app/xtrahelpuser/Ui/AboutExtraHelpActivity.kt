package com.app.xtrahelpuser.Ui

import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.text.Html
import android.view.View
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.CMSData
import com.app.xtrahelpuser.Request.CMSRequest
import com.app.xtrahelpuser.Response.CMSResponse
import com.app.xtrahelpuser.databinding.ActivityAboutExtraHelpBinding
import kotlinx.android.synthetic.main.activity_about_extra_help.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class AboutExtraHelpActivity : BaseActivity() {
    lateinit var b: ActivityAboutExtraHelpBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        b = ActivityAboutExtraHelpBinding.inflate(layoutInflater)
        setContentView(b.root)
        init()
    }

    private fun init(){
        arrowBack.setOnClickListener(this)
        b.txtPrivacyPolicy.setOnClickListener(this)
        b.txtTermsOfUse.setOnClickListener(this)

        getCMSApi()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when(v?.id){
          R.id.arrowBack->onBackPressed()
            R.id.txtPrivacyPolicy -> startActivity(
                Intent(activity, TermsPrivacyActivity::class.java)
                    .putExtra("pageId", "privacypolicy")
            )
            R.id.txtTermsOfUse -> startActivity(
                Intent(activity, TermsPrivacyActivity::class.java)
                    .putExtra("pageId", "termscondition")
            )
        }
    }

    private fun getCMSApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CMSRequest(
                CMSData(
                    Const.langType,
                    "aboutus",
                )
            )

            val signUp: Call<CMSResponse?> =
                RetrofitClient.getClient.getCMS(langTokenRequest)
            signUp.enqueue(object : Callback<CMSResponse?> {
                override fun onResponse(
                    call: Call<CMSResponse?>,
                    response: Response<CMSResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CMSResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                                b.webView.setBackgroundColor(resources.getColor(R.color.black))
                                b.webView.setBackgroundColor(Color.TRANSPARENT)
                                b.webView.loadDataWithBaseURL(null, utils.getStyledFont(response.data.description), "text/html", "utf-8", null)
//                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
//                                    b.txtDesc.text = Html.fromHtml(
//                                        "<p>" + response.data.description + "</p>",
//                                        Html.FROM_HTML_MODE_COMPACT
//                                    )
//                                } else {
//                                    b.txtDesc.text = Html.fromHtml(
//                                        "<p>" + response.data.description + "</p>"
//                                    )
//                                }
                            }
                            "6" -> {
//                                utils.showCustomToast(getCertificationsLicensesResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    response.status,
                                    response.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<CMSResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }
}