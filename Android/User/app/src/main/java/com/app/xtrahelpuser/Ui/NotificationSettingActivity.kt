package com.app.xtrahelpuser.Ui

import android.os.Bundle
import android.view.View
import com.app.xtrahelpcaregiver.Request.LangToken
import com.app.xtrahelpcaregiver.Request.LangTokenRequest
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Response.LoginData
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.NotificationSettingRequest
import kotlinx.android.synthetic.main.activity_notification_setting.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class NotificationSettingActivity : BaseActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_notification_setting)
        txtTitle.text = "Notifications"
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtUpdate.setOnClickListener(this)
    }

    override fun onResume() {
        super.onResume()
        getUserDetailsApi()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtUpdate -> {
                setNotificationSettingApi()
            }
        }
    }

    private fun setNotificationSettingApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)

            val inboxMsgText = if (inboxText.isChecked) { "1" } else { "2" }
            val inboxMsgMail = if (inboxEmail.isChecked) { "1" } else { "2" }
            val jobMsgText = if (jobText.isChecked) { "1" } else { "2" }
            val jobMsgMail = if (jobEmail.isChecked) { "1" } else { "2" }
            val caregiverUpdateText = if (caregiverText.isChecked) { "1" } else { "2" }
            val caregiverUpdateMail = if (caregiverEmail.isChecked) { "1" } else { "2" }


            val langTokenRequest = NotificationSettingRequest(
                NotificationSettingRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    inboxMsgText,
                    inboxMsgMail,
                    jobMsgText,
                    jobMsgMail,
                    caregiverUpdateText,
                    caregiverUpdateMail,
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.savePersonalDetails(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>, response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                utils.customToast(activity,response.message)
//                                finish()
                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<CommonResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getUserDetailsApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<LoginResponse?> =
                RetrofitClient.getClient.getUserInfo(langTokenRequest)
            signUp.enqueue(object : Callback<LoginResponse?> {
                override fun onResponse(
                    call: Call<LoginResponse?>, response: Response<LoginResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: LoginResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                val data: LoginData = loginResponse.data

                                inboxText.isChecked = data.inboxMsgText == "1"
                                inboxEmail.isChecked = data.inboxMsgMail == "1"
                                jobText.isChecked = data.jobMsgText == "1"
                                jobEmail.isChecked = data.jobMsgMail == "1"
                                caregiverText.isChecked = data.caregiverUpdateText == "1"
                                caregiverEmail.isChecked = data.caregiverUpdateMail == "1"
                            }
                            "6" -> {
                                utils.showCustomToast(loginResponse.message)
                            }
                            else -> {
                                checkStatus(relative, loginResponse.status, loginResponse.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<LoginResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

}