package com.app.xtrahelpcaregiver.Ui

import android.content.Intent
import android.os.Bundle
import android.view.View
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.ResendCodeVerifyRequest
import com.app.xtrahelpcaregiver.Request.ResendData
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import kotlinx.android.synthetic.main.activity_forgot_password.*
import kotlinx.android.synthetic.main.activity_forgot_password.arrowBack
import kotlinx.android.synthetic.main.activity_forgot_password.relative
import kotlinx.android.synthetic.main.activity_otp.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class ForgotPasswordActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_forgot_password)
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtReset.setOnClickListener(this)

        etEmail.setOnFocusChangeListener { _, hasFocus ->
            if (etEmail.text.toString() != "") {
                emailImg.setImageResource(R.drawable.email_select);
            } else {
                if (hasFocus) {
                    emailImg.setImageResource(R.drawable.email_select);
                } else {
                    emailImg.setImageResource(R.drawable.email_unselect);
                }
            }
        }

    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtReset -> if (isValid()) {
                forgotPasswordAPITask()
            }
        }
    }

    private fun forgotPasswordAPITask() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val resendCodeVerifyRequest = ResendCodeVerifyRequest(
                ResendData(
                    etEmail.text.toString(),
                    Const.langType,
                    Const.userRole
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.forgotPassword(resendCodeVerifyRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>, response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: CommonResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                utils.showCustomToast(loginResponse.message)
                                startActivity(
                                    Intent(
                                        activity,
                                        OTPActivity::class.java
                                    )
                                        .putExtra(
                                            OTPActivity.EXTRA_EMAIL,
                                            etEmail.text.toString().trim()
                                        )
                                        .putExtra(OTPActivity.EXTRA_FLAG, true)
                                )
                                finish()
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

                override fun onFailure(call: Call<CommonResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun isValid(): Boolean {
        var message: String
        message = ""
        if (etEmail.text.toString().isEmpty()) {
            message = getString(R.string.enterEmail)
            etEmail.requestFocus()
        } else if (!utils.isValidEmail(etEmail.text.toString())) {
            message = getString(R.string.enterValidEmail)
            etEmail.requestFocus()
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }
}