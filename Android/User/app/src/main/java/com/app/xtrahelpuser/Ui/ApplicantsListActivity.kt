package com.app.xtrahelpuser.Ui

import android.R.attr
import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.ApplicantListAdapter
import com.app.xtrahelpuser.Adapter.QuestionAnswerAdapter
import com.app.xtrahelpuser.Interface.AcceptDeclineRequestClick
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.AcceptDeclineRequest
import com.app.xtrahelpuser.Request.CaregiverProfileRequest
import com.app.xtrahelpuser.Request.PostedJobDetailRequest
import com.app.xtrahelpuser.Request.QuestionAnswerRequest
import com.app.xtrahelpuser.Response.CaregiverProfileResponse
import com.app.xtrahelpuser.Response.PostedJobAplicantResponse
import com.app.xtrahelpuser.Response.QuestionAnswerResponse
import com.bumptech.glide.Glide
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.android.synthetic.main.activity_applicants_list.*
import kotlinx.android.synthetic.main.activity_applicants_list.recyclerApplicants
import kotlinx.android.synthetic.main.activity_applicants_list.relative
import kotlinx.android.synthetic.main.header.arrowBack
import kotlinx.android.synthetic.main.header.txtTitle
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


class ApplicantsListActivity : BaseActivity(), AcceptDeclineRequestClick {
    companion object {
        var JOBID = "jobId";
    }

    var jobId = ""
    var applicantId = ""
    lateinit var applicantListAdapter: ApplicantListAdapter
    var applicantList: ArrayList<PostedJobAplicantResponse.Data> = ArrayList()
    lateinit var dialog: BottomSheetDialog
    lateinit var questionAnswerResponse: QuestionAnswerResponse

    lateinit var questionAnswerAdapter: QuestionAnswerAdapter

    var questionAnsList: ArrayList<QuestionAnswerResponse.Data> = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_applicants_list)
        txtTitle.text = "Applicants"
        jobId = intent.getStringExtra(JOBID).toString()
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)

        getMyPostedJobApplicants()

        applicantListAdapter = ApplicantListAdapter(activity, applicantList)
        recyclerApplicants.layoutManager = LinearLayoutManager(activity)
        recyclerApplicants.isNestedScrollingEnabled = false
        recyclerApplicants.adapter = applicantListAdapter
        applicantListAdapter.acceptDeclineRequestClick(this)
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }

    private fun getMyPostedJobApplicants() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = PostedJobDetailRequest(
                PostedJobDetailRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId
                )
            )

            val signUp: Call<PostedJobAplicantResponse?> =
                RetrofitClient.getClient.getMyPostedJobApplicants(langTokenRequest)
            signUp.enqueue(object : Callback<PostedJobAplicantResponse?> {
                override fun onResponse(
                    call: Call<PostedJobAplicantResponse?>,
                    response: Response<PostedJobAplicantResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: PostedJobAplicantResponse = response.body()!!
                        when (response.status) {
                            "1" -> {

                                txtDataNotFound.visibility = View.GONE
                                recyclerApplicants.visibility = View.VISIBLE
                                applicantList.clear()
                                applicantList.addAll(response.data)
                                applicantListAdapter.notifyDataSetChanged()

                            }
                            "6" -> {
                                txtDataNotFound.visibility = View.VISIBLE
                                recyclerApplicants.visibility = View.GONE
                                txtDataNotFound.text = response.message
//                                utils.showCustomToast(response.message)
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<PostedJobAplicantResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun declinePraposalApi(applicantId: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = AcceptDeclineRequest(
                AcceptDeclineRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId,
                    applicantId,
                    ""
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.rejectCaregiverJobRequest(langTokenRequest)
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
                                getMyPostedJobApplicants()
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

    private fun acceptPraposalApi(cardId: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = AcceptDeclineRequest(
                AcceptDeclineRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId,
                    applicantId,
                    cardId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.acceptCaregiverJobRequest(langTokenRequest)
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
                                getMyPostedJobApplicants()
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

    private fun questionAnswerApi(jobId: String, userId: String, name: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = QuestionAnswerRequest(
                QuestionAnswerRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId, userId
                )
            )

            val getProfileCall: Call<QuestionAnswerResponse?> =
                RetrofitClient.getClient.applicantApplyJobQueAnsList(langTokenRequest)
            getProfileCall.enqueue(object : Callback<QuestionAnswerResponse?> {
                override fun onResponse(
                    call: Call<QuestionAnswerResponse?>,
                    response: Response<QuestionAnswerResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        questionAnswerResponse = response.body()!!
                        when (questionAnswerResponse.status) {
                            "1" -> {
                                questionAnsList.clear()
                                questionAnsList.addAll(questionAnswerResponse.data)
                                openAnswerPopup(jobId, userId, name)
                            }
                            "6" -> {
//                                utils.showCustomToast(getCertificationsLicensesResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    questionAnswerResponse.status,
                                    questionAnswerResponse.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<QuestionAnswerResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun openAnswerPopup(jobId: String, userId: String, name: String) {
        val dialogView = layoutInflater.inflate(R.layout.question_answer_popup, null)
        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)

        val recyclerQuestionAnswer: RecyclerView? = dialog.findViewById(R.id.recyclerQuestionAnswer)
        val closeImg: ImageView? = dialog.findViewById(R.id.closeImg)
        val title: TextView? = dialog.findViewById(R.id.title)
        title?.setText(name)

        questionAnswerAdapter = QuestionAnswerAdapter(activity, questionAnsList)
        recyclerQuestionAnswer?.layoutManager = LinearLayoutManager(activity)
        recyclerQuestionAnswer?.isNestedScrollingEnabled = false
        recyclerQuestionAnswer?.adapter = questionAnswerAdapter


        closeImg?.setOnClickListener {
            dialog.dismiss()
        }
        dialog.show()

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 1234) {
            if (resultCode == RESULT_OK) {
                val cardId: String = data?.getStringExtra("result")!!
                acceptPraposalApi(cardId)
            }
            if (resultCode == RESULT_CANCELED) {
                // Write your code if there's no result
            }
        }
    }

    private fun acceptDeclinePopup(type: String, applicantId: String) {
        var message: String = if (type == "accept") {
            "Are you sure want to hire this applicant?"
        } else {
            "Are you sure want to reject this applicant?"
        }

        MaterialAlertDialogBuilder(this)
            .setCancelable(false)
            .setMessage(message)
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int ->
                if (type == "accept") {
                    this.applicantId = applicantId
                    startActivityForResult(
                        Intent(activity, PaymentBillingActivity::class.java)
                            .putExtra(PaymentBillingActivity.FROMJOB, "job"), 1234
                    )
                } else {
                    declinePraposalApi(applicantId)
                }
            }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }

    override fun onAcceptDeclineClick(id: String, type: String) {
        acceptDeclinePopup(type, id)
    }

    override fun onAnswerClick(jobId: String, userId: String, name: String) {
        questionAnswerApi(jobId, userId, name)
    }
}