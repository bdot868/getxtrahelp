package com.app.xtrahelpuser.Ui

import android.os.Bundle
import android.view.View
import com.app.xtrahelpcaregiver.Request.ChangePasswordData
import com.app.xtrahelpcaregiver.Request.ChangePasswordRequest
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.R
import kotlinx.android.synthetic.main.activity_change_password.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class ChangePasswordActivity : BaseActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_change_password)
        txtTitle.text = "Change Password"
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)

        arrowBack.setOnClickListener(this)
        txtUpdate.setOnClickListener(this)

        etOldPassword.setOnFocusChangeListener { _, hasFocus ->
            if (etOldPassword.text.toString() != "") {
                oldPasswordImg.setImageResource(R.drawable.password_select);
            } else {
                if (hasFocus) {
                    oldPasswordImg.setImageResource(R.drawable.password_select);
                } else {
                    oldPasswordImg.setImageResource(R.drawable.password_unselect);
                }
            }
        }

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
            R.id.txtUpdate -> if (isValid()) {
                changePasswordApi()
            }
        }
    }

    private fun changePasswordApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val resetPasswordRequest = ChangePasswordRequest(
                ChangePasswordData(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    etOldPassword.text.toString().trim(),
                    etNewPassword.text.toString().trim()
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.changePassword(resetPasswordRequest)
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
        if (etOldPassword.text.toString().isEmpty()) {
            message = getString(R.string.enterOldPwd)
            etOldPassword.requestFocus()
        } else if (etOldPassword.text.length < 8 || etOldPassword.text.toString().length > 15) {
            message = getString(R.string.password_length)
            etOldPassword.requestFocus()
        } else if (etNewPassword.text.toString().isEmpty()) {
            message = getString(R.string.enterNewPassword)
            etNewPassword.requestFocus()
        } else if (etNewPassword.text.length < 8 || etNewPassword.text.toString().length > 15) {
            message = getString(R.string.password_length)
            etNewPassword.requestFocus()
        } else if (etOldPassword.text.toString() == etNewPassword.text.toString()) {
            message = getString(R.string.newAndOldPWd)
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