package com.app.xtrahelpuser.Ui

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.RatingBar
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.SetJobReviewRequest
import com.bumptech.glide.Glide
import kotlinx.android.synthetic.main.activity_give_review.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class GiveReviewActivity : BaseActivity() {
    
    companion object {
        val JOBID = "jobId"
        val NAME = "name"
        val PROFILEIMG = "profileImg"
        val AVGRATING = "avgRating"
        val RATING = "rating"
        val FEEDBACK = "feedBack"
    }

    var jobId = ""
    var name = ""
    var profileImg = ""
    var avgRating = ""
    var rating = ""
    var feedBack = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_give_review)

        txtTitle.text = "Give Review"
        
        jobId = intent.getStringExtra(JOBID)!!
        name = intent.getStringExtra(NAME)!!
        profileImg = intent.getStringExtra(PROFILEIMG)!!
        rating = intent.getStringExtra(RATING)!!
        feedBack = intent.getStringExtra(FEEDBACK)!!

        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtSubmit.setOnClickListener(this)

        Glide.with(activity)
            .load(profileImg)
            .placeholder(R.drawable.placeholder)
            .centerCrop()
            .into(userImg)

        ratingBar.rating = rating.toFloat()
        txtUserName.text = name
        etFeedBack.setText(feedBack)

        ratingBar.onRatingBarChangeListener =
            RatingBar.OnRatingBarChangeListener { ratingBar, rating, fromUser ->
                if (rating < 1.0f) ratingBar.rating = 1.0f
            }
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtSubmit -> {
                if (isValid()) {
                    setRatingApi()
                }
            }
        }
    }

    private fun setRatingApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = SetJobReviewRequest(
                SetJobReviewRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId,
                    rating,
                    etFeedBack.text.toString()
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.setJobReview(langTokenRequest)
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
                                utils.showCustomToast(response.message)
                                finish()
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

    private fun isValid(): Boolean {
        var message: String
        message = ""
        rating = ratingBar.rating.toString()
        if (ratingBar.rating <= 0) {
            message = getString(R.string.enterRating)
        } else if (etFeedBack.text.toString().isEmpty()) {
            message = getString(R.string.enterFeedBack)
            etFeedBack.requestFocus()
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }
}