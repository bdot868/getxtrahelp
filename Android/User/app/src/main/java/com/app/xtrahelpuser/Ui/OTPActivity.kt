package com.app.xtrahelpuser.Ui

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.View
import com.app.xtrahelpcaregiver.Request.*
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.R
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.messaging.FirebaseMessaging
import com.google.gson.Gson
import kotlinx.android.synthetic.main.activity_otp.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class OTPActivity : BaseActivity() {
    companion object {
        const val EXTRA_EMAIL = "extra_email"
        const val EXTRA_FLAG = "is_forgot"
    }

    private var isForgot = false
    private var email = ""
    var currentCode = StringBuilder()
    var deviceToken: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_otp)
        isForgot = intent.getBooleanExtra(EXTRA_FLAG, false)
        email = intent.getStringExtra(EXTRA_EMAIL)!!
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this);
        txtContinue.setOnClickListener(this);
        txtResend.setOnClickListener(this);

        deviceToken = pref.getString(Const.deviceToken)
        Log.e("FCMToken", "onComplete: $deviceToken")

        if (deviceToken!!.isEmpty()) {
            FirebaseMessaging.getInstance().token
                .addOnCompleteListener(OnCompleteListener<String?> { task ->
                    if (!task.isSuccessful) {
                        Log.w("shdg", "Fetching FCM registration token failed", task.exception)
                        return@OnCompleteListener
                    }
                    deviceToken = task.result
                    Log.e("FCMToken", "onComplete: $deviceToken")
                    pref.setString(Const.deviceToken, deviceToken)
                })
        }
    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtContinue -> if (isValid()) {
                if (isForgot) {
                    checkForgotCodeAPITaskCall()
                } else {
                    verifyAPITaskCall()
                }
            }
            R.id.txtResend -> {
                view_verification.clear()
                if (isForgot) {
                    forgotPasswordAPITask()
                } else {
                    resendVerificationAPITaskCall()
                }
            }
        }
    }

    private fun verifyAPITaskCall() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val code = view_verification.content
            val timeZone: String = pref.getString(Const.TIME_ZONE).toString()

            val verificationRequest = VerificationRequest(
                VerifyData(
                    Const.langType,
                    email,
                    Const.userRole,
                    code,
                    "",
                    timeZone,
                    Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID),
                    Const.deviceType,
                    pref.getString(Const.deviceToken).toString()
                )
            )

            val signUp: Call<LoginResponse?> = RetrofitClient.getClient.verify(verificationRequest)
            signUp.enqueue(object : Callback<LoginResponse?> {
                override fun onResponse(
                    call: Call<LoginResponse?>, response: Response<LoginResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: LoginResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                pref.setString(Const.userData, Gson().toJson(response.body()))
                                pref.setString(Const.token, loginResponse.data.token)
                                pref.setString(Const.id, loginResponse.data.id)
                                pref.setString(
                                    Const.profileStatus,
                                    loginResponse.data.profileStatus
                                )
                                loginActivity()
                            }
                            "6" -> {
                                utils.showSnackBar(
                                    relative,
                                    activity,
                                    loginResponse.message,
                                    Const.success,
                                    Const.successDuration
                                )
                            }
                            else -> {
                                checkStatus(relative, loginResponse.status, loginResponse.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<LoginResponse?>, t: Throwable) {
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun checkForgotCodeAPITaskCall() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val code = view_verification.content
            val checkForgotCodeRequest = CheckForgotCodeRequest(
                CheckForgotCodeData(
                    Const.langType,
                    email,
                    code,
                    Const.userRole
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.checkForgotCode(checkForgotCodeRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>, response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: CommonResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                utils.customToast(activity, loginResponse.message)
                                startActivity(Intent(activity, ResetPasswordActivity::class.java).putExtra(ResetPasswordActivity.EXTRA_EMAIL, email))
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

    private fun resendVerificationAPITaskCall() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val resendCodeVerifyRequest = ResendCodeVerifyRequest(
                ResendData(
                    email,
                    Const.langType,
                    Const.userRole
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.resendVerification(resendCodeVerifyRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>, response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: CommonResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                utils.customToast(activity, loginResponse.message)
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

    private fun forgotPasswordAPITask() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val resendCodeVerifyRequest = ResendCodeVerifyRequest(
                ResendData(
                    email,
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
                                utils.customToast(activity, loginResponse.message)
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
        val message = ""
        if (!view_verification.isFinish) {
            utils.showSnackBar(
                relative, activity, "Enter otp", Const.alert, Const.successDuration
            )
        }
        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView(activity)
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.isEmpty()
    }
}