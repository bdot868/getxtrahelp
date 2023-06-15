package com.app.xtrahelpuser.Ui

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.app.xtrahelpcaregiver.Adapter.SubscriptionAdapter
import com.app.xtrahelpcaregiver.Request.UpdateProfileStatus
import com.app.xtrahelpcaregiver.Request.UpdateProfileStatusRequest
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.R
import kotlinx.android.synthetic.main.activity_subscription.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class SubscriptionActivity : BaseActivity() {

    lateinit var subscriptionAdapter: SubscriptionAdapter

    private var fromLogin: Boolean = false
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_subscription)
        fromLogin = intent.getBooleanExtra("fromLogin", false)
        setAdapter()
    }

    private fun setAdapter() {
        arrowBack.setOnClickListener(this)
        txtSubscribe.setOnClickListener(this)
        txtContinueForFree.setOnClickListener(this)

        subscriptionAdapter = SubscriptionAdapter(activity)
        viewPager.adapter = subscriptionAdapter
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtSubscribe -> updateProfile()
            R.id.txtContinueForFree -> updateProfile()
        }
    }

    private fun updateProfile() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val updateProfileStatusRequest = UpdateProfileStatusRequest(
                UpdateProfileStatus(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    "1"
                )
            )

            val signUp: Call<LoginResponse?> =
                RetrofitClient.getClient.updateProfileStatus(updateProfileStatusRequest)
            signUp.enqueue(object : Callback<LoginResponse?> {
                override fun onResponse(
                    call: Call<LoginResponse?>, response: Response<LoginResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: LoginResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                pref.setString(
                                    Const.profileStatus,
                                    loginResponse.data.profileStatus
                                )
                                loginActivity()
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