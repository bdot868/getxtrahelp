package com.app.xtrahelpcaregiver.Ui

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.CategoryProfileAdapter
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.CaregiverProfileRequest
import com.app.xtrahelpcaregiver.Response.CaregiverProfileResponse
import com.app.xtrahelpcaregiver.Response.GetCaregiverMyProfileResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.bumptech.glide.Glide
import com.google.gson.Gson
import kotlinx.android.synthetic.main.activity_caregiver_profile.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class CaregiverProfileActivity : BaseActivity() {
    companion object {
        val CAREGIVERID = "caregiverId"
    }

    lateinit var categoryProfileAdapter: CategoryProfileAdapter
    var categoryList: ArrayList<GetCaregiverMyProfileResponse.Data.CategoryData> = ArrayList()
    var caregiverId = "";
    lateinit var getCaregiverMyProfileResponse: CaregiverProfileResponse

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_caregiver_profile)
        caregiverId = intent.getStringExtra(CAREGIVERID)!!
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        relativeComplete.setOnClickListener(this)
        relativeAvailability.setOnClickListener(this)

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
                                for (i in data.categoryData.indices) {
                                    val d = data.categoryData[i]
                                    val categoryData = GetCaregiverMyProfileResponse.Data.CategoryData(d.jobCategoryId,d.userId,d.userWorkJobCategoryId,d.name)
                                    categoryList.add(categoryData)
                                }
//                                categoryList.addAll(data.categoryData)
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
}