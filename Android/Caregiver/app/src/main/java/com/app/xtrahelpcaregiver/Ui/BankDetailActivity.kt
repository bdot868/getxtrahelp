package com.app.xtrahelpcaregiver.Ui

import android.os.Bundle
import android.view.View
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.BankDetailRequest
import com.app.xtrahelpcaregiver.Request.LangToken
import com.app.xtrahelpcaregiver.Request.LangTokenRequest
import com.app.xtrahelpcaregiver.Response.BankDetailResponse
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import kotlinx.android.synthetic.main.activity_bank_detail.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class BankDetailActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_bank_detail)
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtFinish.setOnClickListener(this)

        getBankDetailApi()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtFinish -> {
                if (isValid()) {
                    saveBankDetailApi()
                }
            }
        }
    }

    private fun saveBankDetailApi() {
        val accountType: String = if (radioCompany.isChecked) {
            "company"
        } else {
            "individual"
        }
        val accountHolderName = etHolderName.text.toString()
        val routingNumber = etRoutingNumber.text.toString()
        val accountNumber = etAccountNumber.text.toString()

        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = BankDetailRequest(
                BankDetailRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    accountHolderName,
                    routingNumber,
                    accountNumber,
                    accountType
                )
            )
            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.saveBankDetailInStripe(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                utils.customToast(activity,response.message)
                                finish()
                            }
                            else -> {
//                                checkStatus(relative, response.status, response.message)
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

    private fun getBankDetailApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString()
                )
            )
            val signUp: Call<BankDetailResponse?> =
                RetrofitClient.getClient.getBankDetail(langTokenRequest)
            signUp.enqueue(object : Callback<BankDetailResponse?> {
                override fun onResponse(
                    call: Call<BankDetailResponse?>,
                    response: Response<BankDetailResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: BankDetailResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                etHolderName.setText(response.data.account_holder_name)
                                etRoutingNumber.setText(response.data.routing_number)
                                etAccountNumber.setText(response.data.account_number)
                                etReAccountNumber.setText(response.data.account_number)

                                if (response.data.account_holder_type == "individual") {
                                    radioIndividual.isChecked = true
                                } else {
                                    radioCompany.isChecked = true
                                }

                            }
                            else -> {
//                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<BankDetailResponse?>, t: Throwable) {
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
        if (etHolderName.text.toString().isEmpty()) {
            message = resources.getString(R.string.enter_holder_name)
            etHolderName.requestFocus()
        } else if (etRoutingNumber.text.toString().isEmpty()) {
            message = resources.getString(R.string.enter_routing)
            etRoutingNumber.requestFocus()
        } else if (etAccountNumber.text.toString().isEmpty()) {
            message = resources.getString(R.string.enter_account)
            etAccountNumber.requestFocus()
        } else if (etReAccountNumber.text.toString().isEmpty()) {
            message = resources.getString(R.string.enter_confirm)
            etReAccountNumber.requestFocus()
        } else if (etReAccountNumber.text.toString() != etAccountNumber.text.toString()) {
            message = resources.getString(R.string.numbrer_not_match)
            etReAccountNumber.requestFocus()
        }
        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView(activity)
            utils.showSnackBar(relative, this, message, Const.alert, Const.successDuration)
        }
        return message.isEmpty()
    }

}