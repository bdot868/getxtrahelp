package com.app.xtrahelpuser.Ui

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import android.util.Patterns
import android.view.View
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.SocialLoginRequest
import com.google.gson.Gson
import kotlinx.android.synthetic.main.activity_email.*
import kotlinx.android.synthetic.main.activity_email.emailImg
import kotlinx.android.synthetic.main.activity_email.etEmail
import kotlinx.android.synthetic.main.activity_email.relative
import kotlinx.android.synthetic.main.activity_login.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class EmailActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_email)
        txtSubmit.setOnClickListener(this)

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
            R.id.txtSubmit -> {
                if (isValid()) {
                    socialLoginAPI()
                }
            }
        }
    }

    override fun onBackPressed() {
        super.onBackPressed()
        finish()
    }

    private fun socialLoginAPI() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity);
//            utils.showProgress(activity)
            utils.showProgress(activity)
            val loginRequest = SocialLoginRequest(
                SocialLoginRequest.Data(
                    Const.langType,
                    pref.getString(Const.authId).toString(),
                    pref.getString(Const.socialAuthProvider).toString(),
                    pref.getString(Const.deviceToken).toString(),
                    "",
                    Const.deviceType,
                    Settings.Secure.getString(this.contentResolver, Settings.Secure.ANDROID_ID),
                    pref.getString(Const.TIME_ZONE).toString(),
                    Const.userRole,
                    etEmail.text.toString(),
                    if (etEmail.text.toString().isEmpty()) "1" else "0",
                    pref.getString(Const.socialName)
                        .toString()
                )
            )

            val signUp: Call<LoginResponse?> = RetrofitClient.getClient.socialLogin(loginRequest)
            signUp.enqueue(object : Callback<LoginResponse?> {
                override fun onResponse(
                    call: Call<LoginResponse?>, response: Response<LoginResponse?>
                ) {
//                    utils.dismissProgress()
                    utils.dismissProgress()
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: LoginResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
//                                utils.showCustomToast(loginResponse.message)
                                pref.setString(Const.userData, Gson().toJson(response.body()))
                                pref.setString(Const.token, loginResponse.data.token)
                                pref.setString(Const.id, loginResponse.data.id)
                                pref.setString(
                                    Const.profileStatus,
                                    loginResponse.data.profileStatus
                                )
                                loginActivity()
//                                checkTokenAndNavigateUser()
                            }
                            "3" -> {
                                startActivity(
                                    Intent(
                                        activity,
                                        OTPActivity::class.java
                                    ).putExtra(
                                        OTPActivity.EXTRA_EMAIL,
                                        etEmail.text.toString().trim()
                                    ).putExtra(OTPActivity.EXTRA_FLAG, false)
                                )
                            }
                            "4" -> {
                                startActivity(Intent(activity, EmailActivity::class.java))
                            }
                            else -> {
                                checkStatus(relative, loginResponse.status, loginResponse.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<LoginResponse?>, t: Throwable) {
//                    utils.dismissProgress()
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun isValid(): Boolean {
        var message = ""
        if (etEmail.text.toString().isEmpty()) {
            message = resources.getString(R.string.enterEmail)
            etEmail.requestFocus()
        } else if (!Patterns.EMAIL_ADDRESS.matcher(etEmail.text.toString()).matches()) {
            message = resources.getString(R.string.enterValidEmail)
            etEmail.requestFocus()
        }
        if (!message.isEmpty()) {
            utils.showSnackBar(relative, this, message, Const.alert, Const.successDuration)
        }
        return message.isEmpty()
    }

}