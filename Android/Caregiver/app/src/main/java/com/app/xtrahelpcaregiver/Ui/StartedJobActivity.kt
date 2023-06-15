package com.app.xtrahelpcaregiver.Ui

import android.content.DialogInterface
import android.os.Bundle
import android.os.CountDownTimer
import android.view.View
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.EndUserJobRequest
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.android.synthetic.main.activity_job_detail.*
import kotlinx.android.synthetic.main.activity_started_job.*
import kotlinx.android.synthetic.main.activity_started_job.arrowBack
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.concurrent.TimeUnit


class StartedJobActivity : BaseActivity() {
    companion object {
        val JOBID = "jobId"
        val JOBDETAILID = "jobDetailId"
        val TOTALSEC = "totalSec"
        val TOTALMIN = "totalMin"
        val TOTALHR = "totalHr"
    }

    var jobId = ""
    var jobDetailId = ""
    var totalSec = ""
    var totalMin = ""
    var totalHr = ""
    lateinit var countDownTimer: CountDownTimer

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_started_job)
        jobId = intent.getStringExtra(JOBID).toString()
        jobDetailId = intent.getStringExtra(JOBDETAILID).toString()
        totalSec = intent.getStringExtra(TOTALSEC).toString()
        totalMin = intent.getStringExtra(TOTALMIN).toString()
        init()
        startTimer()
    }

    fun startTimer() {
        
        object : CountDownTimer(TimeUnit.SECONDS.toMillis(totalSec.toLong()), 1000) {
            override fun onTick(millisUntilFinished: Long) {
                txtCountDown.text = String.format(
                    "%02d:%02d:%02d", TimeUnit.MILLISECONDS.toHours(millisUntilFinished),
                    TimeUnit.MILLISECONDS.toMinutes(millisUntilFinished) - TimeUnit.HOURS.toMinutes(
                        TimeUnit.MILLISECONDS.toHours(millisUntilFinished)
                    ),
                    TimeUnit.MILLISECONDS.toSeconds(millisUntilFinished) - TimeUnit.MINUTES.toSeconds(
                        TimeUnit.MILLISECONDS.toMinutes(millisUntilFinished)
                    )
                ) + " mins"
            }

            override fun onFinish() {

            }
        }.start()

    }

    override fun onDestroy() {
        super.onDestroy()

    }

    override fun onPause() {
        super.onPause()

    }

    fun init() {
        arrowBack.setOnClickListener(this)
        txtEndJob.setOnClickListener(this)
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> {
                onBackPressed()
            }

            R.id.txtEndJob -> {
                endJobPopup()
            }
        }
    }

    private fun endJobPopup() {
        MaterialAlertDialogBuilder(this)
            .setCancelable(false)
            .setMessage("Are you sure want to end this job?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int -> endJobApi()}
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()

    }

    private fun endJobApi(){
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = EndUserJobRequest(
                EndUserJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId,
                    jobDetailId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.endUserJob(langTokenRequest)
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
//                                caregiverAdapter.notifyDataSetChanged()
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
}