package com.app.xtrahelpuser.Ui

import android.content.Intent
import android.os.Bundle
import android.text.method.PasswordTransformationMethod
import android.view.View
import com.app.xtrahelpcaregiver.Request.SignUpData
import com.app.xtrahelpcaregiver.Request.SignUpRequest
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.R
import kotlinx.android.synthetic.main.activity_signup.*
import kotlinx.android.synthetic.main.activity_signup.checkbox
import kotlinx.android.synthetic.main.activity_signup.emailImg
import kotlinx.android.synthetic.main.activity_signup.etEmail
import kotlinx.android.synthetic.main.activity_signup.etPassword
import kotlinx.android.synthetic.main.activity_signup.passwordImg
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class SignupActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_signup)
        init();
    }

    private fun init() {
        arrowBack.setOnClickListener(this);
        txtAlreadyAccount.setOnClickListener(this);
        txtSignUp.setOnClickListener(this);
        checkbox.setOnClickListener(this);
        checkboxConfirmPass.setOnClickListener(this);

        etName.setOnFocusChangeListener { _, hasFocus ->
            if (etName.text.toString() != "") {
                userImg.setImageResource(R.drawable.user_select);
            } else {
                if (hasFocus) {
                    userImg.setImageResource(R.drawable.user_select);
                } else {
                    userImg.setImageResource(R.drawable.user_unselect);
                }
            }
        }

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

        etPassword.setOnFocusChangeListener { _, hasFocus ->
            if (etPassword.text.toString() != "") {
                passwordImg.setImageResource(R.drawable.password_select);
            } else {
                if (hasFocus) {
                    passwordImg.setImageResource(R.drawable.password_select);
                } else {
                    passwordImg.setImageResource(R.drawable.password_unselect);
                }
            }
        }
    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.arrowBack, R.id.txtAlreadyAccount -> onBackPressed()
            R.id.txtSignUp -> if (isValid()) {
                signUpAPITaskCall()
            }

            R.id.checkbox -> if (!checkbox.isChecked) etPassword.transformationMethod =
                PasswordTransformationMethod()
            else etPassword.transformationMethod = null

            R.id.checkboxConfirmPass -> if (!checkboxConfirmPass.isChecked) etConfirmPassword.transformationMethod =
                PasswordTransformationMethod()
            else etConfirmPassword.transformationMethod = null

        }
    }

    private fun signUpAPITaskCall() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)

            val signUpRequest = SignUpRequest(
                SignUpData(
                    Const.langType,
                    etEmail.text.toString(),
                    etPassword.text.toString(),
                    Const.userRole,
                    etName.text.toString()
                )
            )

            val signUp: Call<CommonResponse?> = RetrofitClient.getClient.signup(signUpRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>, response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val commonResponse: CommonResponse = response.body()!!
                        when (commonResponse.status) {
                            "1" -> {

                            }
                            "3" -> {
                                startActivity(
                                    Intent(activity, OTPActivity::class.java).putExtra(
                                        OTPActivity.EXTRA_EMAIL,
                                        etEmail.text.toString()
                                    ).putExtra(OTPActivity.EXTRA_FLAG, false)
                                )
                                finish()
                            }
                            "6" -> {
                                utils.showSnackBar(
                                    relative,
                                    activity,
                                    commonResponse.message,
                                    Const.success,
                                    Const.successDuration
                                )
                            }
                            else -> {
                                checkStatus(relative, commonResponse.status, commonResponse.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<CommonResponse?>, t: Throwable) {
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
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
        if (etName.text.toString().isEmpty()) {
            message = getString(R.string.enterName)
            etName.requestFocus()
        } else if (etEmail.text.toString().isEmpty()) {
            message = getString(R.string.enterEmail)
            etEmail.requestFocus()
        } else if (!utils.isValidEmail(etEmail.text.toString())) {
            message = getString(R.string.enterValidEmail)
            etEmail.requestFocus()
        } else if (etPassword.text.toString().isEmpty()) {
            message = getString(R.string.enterPassword)
            etPassword.requestFocus()
        } else if (etPassword.text.length < 8 || etPassword.text.toString().length > 15) {
            message = getString(R.string.password_length)
            etPassword.requestFocus()
        } else if (etConfirmPassword.text.isEmpty()) {
            message = getString(R.string.enterConfirmPwd)
            etConfirmPassword.requestFocus()
        } else if (etPassword.text.toString() != etConfirmPassword.text.toString()) {
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