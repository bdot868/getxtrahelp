package com.app.xtrahelpuser.Ui

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
import kotlinx.android.synthetic.main.activity_terms_privacy.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class TermsPrivacyActivity : BaseActivity() {
    var pageId: String = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_terms_privacy)

        txtTitle.text = "Privacy Policy"
        pageId = intent.getStringExtra("pageId").toString()
        if (pageId == "termscondition") {
            txtTitle.text = "Terms and Conditions"
        } else {
            txtTitle.text = "Privacy Policy"
        }
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        getCMSApi()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }

    private fun getCMSApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CMSRequest(
                CMSData(
                    Const.langType,
                    pageId,
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
                                webView.setBackgroundColor(resources.getColor(R.color.black))
                                webView.setBackgroundColor(Color.TRANSPARENT)
                                webView.loadDataWithBaseURL(null, utils.getStyledFont(response.data.description), "text/html", "utf-8", null)
//                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
//                                    txtDesc.text = Html.fromHtml(
//                                        "<p>" + response.data.description + "</p>",
//                                        Html.FROM_HTML_MODE_COMPACT
//                                    )
//                                } else {
//                                    txtDesc.text = Html.fromHtml(
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