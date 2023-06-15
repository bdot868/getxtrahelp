package com.app.xtrahelpcaregiver.Ui

import android.os.Build
import android.os.Bundle
import android.text.Html
import android.view.View
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.FaqDetailData
import com.app.xtrahelpcaregiver.Request.FaqDetailRequest
import com.app.xtrahelpcaregiver.Response.FaqDetailResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import kotlinx.android.synthetic.main.activity_faqs_details.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class FAQsDetailsActivity : BaseActivity() {

    var faqId: String = ""
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_faqs_details)
        txtTitle.text = "FAQs"
        faqId = intent.getStringExtra("id").toString()

        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)

        faqDetailApi()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }

    private fun faqDetailApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = FaqDetailRequest(
                FaqDetailData(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    faqId
                )
            )

            val signUp: Call<FaqDetailResponse?> =
                RetrofitClient.getClient.faqDetails(langTokenRequest)
            signUp.enqueue(object : Callback<FaqDetailResponse?> {
                override fun onResponse(
                    call: Call<FaqDetailResponse?>,
                    response: Response<FaqDetailResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: FaqDetailResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                                    txtDesc.text = Html.fromHtml(
                                        "<p>" + response.data.description + "</p>",
                                        Html.FROM_HTML_MODE_COMPACT
                                    )
                                } else {
                                    txtDesc.text = Html.fromHtml(
                                        "<p>" + response.data.description + "</p>"
                                    )
                                }
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
                    call: Call<FaqDetailResponse?>,
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