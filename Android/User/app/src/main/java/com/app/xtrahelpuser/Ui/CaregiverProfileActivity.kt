package com.app.xtrahelpuser.Ui

import android.content.DialogInterface
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Request.LangToken
import com.app.xtrahelpcaregiver.Request.LangTokenRequest
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.CategoryProfileAdapter
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.AcceptDeclineRequest
import com.app.xtrahelpuser.Request.CaregiverProfileRequest
import com.app.xtrahelpuser.Response.CaregiverProfileResponse
import com.bumptech.glide.Glide
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.gson.Gson
import kotlinx.android.synthetic.main.activity_applicants_list.*
import kotlinx.android.synthetic.main.activity_caregiver_profile.*
import kotlinx.android.synthetic.main.activity_caregiver_profile.relative
import kotlinx.android.synthetic.main.activity_faqs.view.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class CaregiverProfileActivity : BaseActivity() {
    companion object {
        val CAREGIVERID = "caregiverId"
        val FROMHIRE = "fromHire"
        val HIREENABLE = "hireEnable"
        val JOBID = "jobId"
        val HIREHIDE = "isHired"
    }

    var fromHire = false
    var hireEnable = false
    var hireHide = false
    var jobId = ""

    lateinit var categoryProfileAdapter: CategoryProfileAdapter
    var categoryList: ArrayList<CaregiverProfileResponse.Data.CategoryData> = ArrayList()
    var caregiverId = "";
    lateinit var getCaregiverMyProfileResponse: CaregiverProfileResponse

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_caregiver_profile)
        caregiverId = intent.getStringExtra(CAREGIVERID)!!
        jobId = intent.getStringExtra(JOBID).toString()
        fromHire = intent.getBooleanExtra(FROMHIRE, false)
        hireEnable = intent.getBooleanExtra(HIREENABLE, false)
        hireHide = intent.getBooleanExtra(HIREHIDE, false)
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        relativeComplete.setOnClickListener(this)
        relativeAvailability.setOnClickListener(this)
        txtHire.setOnClickListener(this)

        if (fromHire) {
            txtHire.visibility = View.VISIBLE
            if (hireHide) {
                txtHire.visibility = View.GONE
            }
            if (hireEnable) {
                txtHire.text = "Hire"
            } else {
                txtHire.text = "Hired"
            }
        } else {
            txtHire.visibility = View.GONE
        }


        categoryProfileAdapter = CategoryProfileAdapter(activity, categoryList)
        recyclerCategory.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerCategory.isNestedScrollingEnabled = false
        recyclerCategory.adapter = categoryProfileAdapter

        caregiverProfileApi()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtHire -> {
                if (hireEnable) {
                    acceptDeclinePopup()
                }
            }

            R.id.relativeComplete -> {
                val data = Gson().toJson(getCaregiverMyProfileResponse)
                startActivity(
                    Intent(activity, CompleteProfileActivity::class.java)
                        .putExtra(CompleteProfileActivity.DATA, data)
                )
            }
            R.id.relativeAvailability -> startActivity(
                Intent(activity, AvailabilityActivity::class.java)
                    .putExtra(
                        AvailabilityActivity.CAREGIVRID,
                        getCaregiverMyProfileResponse.data.id
                    )
            )
        }
    }

    private fun acceptDeclinePopup() {
        MaterialAlertDialogBuilder(this)
            .setCancelable(false)
            .setMessage("Are you sure want to hire this applicant?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int ->
                startActivityForResult(
                    Intent(activity, PaymentBillingActivity::class.java)
                        .putExtra(PaymentBillingActivity.FROMJOB, "job"), 1234
                )
            }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }

    private fun caregiverProfileApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CaregiverProfileRequest(
                CaregiverProfileRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    caregiverId
                )
            )

            val getProfileCall: Call<CaregiverProfileResponse?> =
                RetrofitClient.getClient.getCaregiverProfile(langTokenRequest)
            getProfileCall.enqueue(object : Callback<CaregiverProfileResponse?> {
                override fun onResponse(
                    call: Call<CaregiverProfileResponse?>,
                    response: Response<CaregiverProfileResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        getCaregiverMyProfileResponse = response.body()!!
                        when (getCaregiverMyProfileResponse.status) {
                            "1" -> {
                                val data = getCaregiverMyProfileResponse.data

                                Glide.with(activity)
                                    .load(data.profileImageThumbUrl)
                                    .centerCrop()
                                    .placeholder(R.drawable.placeholder)
                                    .into(userImg)

                                ratingBar.rating = data.ratingAverage.toFloat()
                                txtUserName.text = data.fullName
                                txtSuccess.text = data.successPercentage
                                txtJobs.text = data.totalJobCompleted
                                txtHours.text = data.totalJobsHours

                                categoryList.clear()
                                categoryList.addAll(data.categoryData)
                                categoryProfileAdapter.notifyDataSetChanged()

                                if (data.familyVaccinated == "1") {
                                    vaccineImg.visibility = View.VISIBLE
                                } else {
                                    vaccineImg.visibility = View.GONE
                                }
                            }
                            "6" -> {
//                                utils.showCustomToast(getCertificationsLicensesResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    getCaregiverMyProfileResponse.status,
                                    getCaregiverMyProfileResponse.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<CaregiverProfileResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
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

    private fun acceptPraposalApi(cardId: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = AcceptDeclineRequest(
                AcceptDeclineRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId,
                    caregiverId,
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
                                txtHire.text = "Hired"
                                hireEnable = false
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