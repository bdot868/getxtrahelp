package com.app.xtrahelpuser.Ui

import android.os.Bundle
import android.view.View
import com.app.xtrahelpcaregiver.Request.LangToken
import com.app.xtrahelpcaregiver.Request.LangTokenRequest
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.FeedBackData
import com.app.xtrahelpuser.Request.SetFeedBackRequest
import com.app.xtrahelpuser.Response.MyFeedBackResponse
import kotlinx.android.synthetic.main.activity_feedback.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class FeedbackActivity : BaseActivity() {
    
    var rating: String = "5"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_feedback)
        txtTitle.text = "Feedback"
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtSubmit.setOnClickListener(this)
        sedFeed.setOnClickListener(this)
        notHappyFeed.setOnClickListener(this)
        happyFeed.setOnClickListener(this)
        loveFeed.setOnClickListener(this)
        veryHappyFeed.setOnClickListener(this)

        getFeedbackApi()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtSubmit -> {
                if (isValid()) {
                    setFeedBack()
                }
            }
            R.id.sedFeed -> rating = "1"
            R.id.notHappyFeed -> rating = "2"
            R.id.happyFeed -> rating = "3"
            R.id.veryHappyFeed -> rating = "4"
            R.id.loveFeed -> rating = "5"

        }
    }

    private fun setFeedBack() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = SetFeedBackRequest(
                FeedBackData(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    rating,
                    etFeedBack.text.toString()
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.setAppFeedback(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                                utils.customToast(activity, response.message)
                                finish()
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
                    call: Call<CommonResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getFeedbackApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<MyFeedBackResponse?> =
                RetrofitClient.getClient.getMyAppFeedback(langTokenRequest)
            signUp.enqueue(object : Callback<MyFeedBackResponse?> {
                override fun onResponse(
                    call: Call<MyFeedBackResponse?>,
                    response: Response<MyFeedBackResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: MyFeedBackResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                                etFeedBack.setText(response.data.feedback)
                                rating = response.data.rating
                                when (rating) {
                                    "1" -> sedFeed.isChecked = true
                                    "2" -> notHappyFeed.isChecked = true
                                    "3" -> happyFeed.isChecked = true
                                    "4" -> veryHappyFeed.isChecked = true
                                    "5" -> loveFeed.isChecked = true
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
                    call: Call<MyFeedBackResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun isValid(): Boolean {
        var message: String
        message = ""
        if (etFeedBack.text.toString().isEmpty()) {
            message = getString(R.string.enterFeedBack)
            etFeedBack.requestFocus()
        }
        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()

    }
}