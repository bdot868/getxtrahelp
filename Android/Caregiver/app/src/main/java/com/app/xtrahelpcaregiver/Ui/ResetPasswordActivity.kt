package com.app.xtrahelpcaregiver.Ui

import android.os.Bundle
import android.view.View
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.ResetPasswordData
import com.app.xtrahelpcaregiver.Request.ResetPasswordRequest
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import kotlinx.android.synthetic.main.activity_reset_password.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class ResetPasswordActivity : BaseActivity() {
    companion object {
        const val EXTRA_EMAIL = "extra_email"
    }

    private var email = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_reset_password)
        email = intent.getStringExtra(EXTRA_EMAIL)!!
        txtTitle.text = "Reset Password"

        txtSubmit.setOnClickListener(this)
        arrowBack.setOnClickListener(this)

        etConfirmPassword.setOnFocusChangeListener { _, hasFocus ->
            if (etConfirmPassword.text.toString() != "") {
                confirmPasswordImg.setImageResource(R.drawable.password_select);
            } else {
                if (hasFocus) {
                    confirmPasswordImg.setImageResource(R.drawable.password_select);
                } else {
                    confirmPasswordImg.setImageResource(R.drawable.password_unselect);
                }
            }
        }

        etNewPassword.setOnFocusChangeListener { _, hasFocus ->
            if (etNewPassword.text.toString() != "") {
                newPasswordImg.setImageResource(R.drawable.password_select);
            } else {
                if (hasFocus) {
                    newPasswordImg.setImageResource(R.drawable.password_select);
                } else {
                    newPasswordImg.setImageResource(R.drawable.password_unselect);
                }
            }
        }
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtSubmit -> if (isValid()) {
                resetPasswordAPITaskCall()
            }
        }
    }

    private fun resetPasswordAPITaskCall() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val resetPasswordRequest = ResetPasswordRequest(
                ResetPasswordData(
                    Const.langType,
                    email,
                    etNewPassword.text.toString().trim(),
                    Const.userRole
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.resetPassword(resetPasswordRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>, response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: CommonResponse = response.body()!!
                        when (loginResponse.status) {
                            "0" -> {
                                utils.showSnackBar(
                                    relative,
                                    activity,
                                    loginResponse.message,
                                    Const.alert,
                                    Const.successDuration
                                )
                            }
                            "1" -> {
                                utils.customToast(activity, loginResponse.message)
                                finish()
                            }
                            "2" -> {
                                utils.logOut(activity, loginResponse.message)
                            }
                            "6" -> {
                                utils.showCustomToast(loginResponse.message)
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
        if (etNewPassword.text.toString().isEmpty()) {
            message = getString(R.string.enterPassword)
            etNewPassword.requestFocus()
        } else if (!etNewPassword.text!!.matches(".*[A-Z].*".toRegex()) || !etNewPassword.text!!.matches(
                ".*[a-z].*".toRegex()
            ) || !etNewPassword.text!!.matches(".*[!@#$%^&*+=/?].*".toRegex())
        ) {
            message = getString(R.string.strongPassword)
            etNewPassword.requestFocus()
        } else if (etNewPassword.text.length < 8 || etNewPassword.text.toString().length > 15) {
            message = getString(R.string.password_length)
            etNewPassword.requestFocus()
        } else if (etConfirmPassword.text.toString().isEmpty()) {
            message = getString(R.string.enterConfirmPwds)
            etConfirmPassword.requestFocus()
        } else if (etNewPassword.text.toString() != etConfirmPassword.text.toString()) {
            message = getString(R.string.passwordNotMatch)
            etConfirmPassword.requestFocus()
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }

}