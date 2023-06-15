package com.app.xtrahelpcaregiver.Ui

import android.content.ActivityNotFoundException
import android.content.DialogInterface
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.core.app.ShareCompat
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.LangToken
import com.app.xtrahelpcaregiver.Request.LangTokenRequest
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.android.synthetic.main.activity_under_review.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


class UnderReviewActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_under_review)
        init()
    }

    private fun init() {
        txtContactUs.setOnClickListener(this)
        txtLogOut.setOnClickListener(this)

        twitterImg.setOnClickListener(this)
        fbImg.setOnClickListener(this)
        instaImg.setOnClickListener(this)
        shareImg.setOnClickListener(this)


    }

    override fun onResume() {
        super.onResume()
        getUserDetailsApi()
    }
    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.txtLogOut -> {
                logOutPopup()
            }

            R.id.shareImg -> {
                ShareCompat.IntentBuilder.from(activity)
                    .setChooserTitle("title")
                    .setText("https://play.google.com/store/apps/details?id=com.app.xtrahelpcaregiver")
                    .setType("text/plain")
                    .startChooser();
            }
            R.id.fbImg -> {
                ShareCompat.IntentBuilder.from(activity)
                    .setChooserTitle("title")
                    .setText("https://play.google.com/store/apps/details?id=com.app.xtrahelpcaregiver")
                    .setType("text/plain")
                    .startChooser();
            }
            R.id.instaImg -> {
                ShareCompat.IntentBuilder.from(activity)
                    .setChooserTitle("title")
                    .setText("https://play.google.com/store/apps/details?id=com.app.xtrahelpcaregiver")
                    .setType("text/plain")
                    .startChooser();
            }
            R.id.twitterImg -> {
                val tweetUrl =
                    ("https://twitter.com/intent/tweet?text=WRITE Hey Please check this app &url="
                            + "https://play.google.com/store/apps/details?id=com.app.xtrahelpcaregiver")
                val uri = Uri.parse(tweetUrl)
                startActivity(Intent(Intent.ACTION_VIEW, uri))
            }

            R.id.txtContactUs -> {
                try {
                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse("mailto:" + "info@getxtrahelp.com"))
                    intent.putExtra(Intent.EXTRA_SUBJECT, "About my account activation")
                    intent.putExtra(Intent.EXTRA_TEXT, "")
                    startActivity(intent)
                } catch (e: ActivityNotFoundException) {
                    Toast.makeText(activity, "Email app not detected", Toast.LENGTH_SHORT).show()
                }

//                val i = Intent(Intent.ACTION_SEND)
//                i.type = "message/rfc822"
//                i.putExtra(Intent.EXTRA_EMAIL, arrayOf("info@getxtrahelp.com"))
//                i.putExtra(Intent.EXTRA_SUBJECT, "About my account activation")
//                i.putExtra(Intent.EXTRA_TEXT, "")
//                try {
//                    startActivity(Intent.createChooser(i, "Send mail..."))
//                } catch (ex: ActivityNotFoundException) {
//                    Toast.makeText(
//                        activity,
//                        "There are no email clients installed.",
//                        Toast.LENGTH_SHORT
//                    ).show()
//                }
            }
        }
    }

    private fun logOutPopup() {
        MaterialAlertDialogBuilder(this)
            .setIcon(R.mipmap.ic_launcher)
            .setTitle(getString(R.string.app_name))
            .setCancelable(false)
            .setMessage("Are you sure want to logout?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int -> logoutAPITask() }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }

    private fun logoutAPITask() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.logout(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>, response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: CommonResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                utils.logOut(activity, loginResponse.message)
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
                                pref.setString(
                                    Const.profileStatus,
                                    loginResponse.data.profileStatus
                                )
                                if (pref.getString(Const.profileStatus) == "8") {
                                    startActivity(Intent(activity, DashboardActivity::class.java))
                                    finish()
                                }
//                                loginActivity()
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