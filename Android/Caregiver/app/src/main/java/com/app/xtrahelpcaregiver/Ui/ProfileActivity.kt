package com.app.xtrahelpcaregiver.Ui

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.CategoryProfileAdapter
import com.app.xtrahelpcaregiver.Adapter.SpecialitiesAdapter
import com.app.xtrahelpcaregiver.Adapter.WorkPlaceAdapter
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.CancelUpcomingJobRequest
import com.app.xtrahelpcaregiver.Request.LangToken
import com.app.xtrahelpcaregiver.Request.LangTokenRequest
import com.app.xtrahelpcaregiver.Response.CategoryDatas
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Response.GetCaregiverMyProfileResponse
import com.app.xtrahelpcaregiver.Response.WorkExperienceData
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.bumptech.glide.Glide
import kotlinx.android.synthetic.main.activity_profile.*
import kotlinx.android.synthetic.main.activity_profile.arrowBack
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class ProfileActivity : BaseActivity() {

    lateinit var specialitiesAdapter: SpecialitiesAdapter
    lateinit var categoryProfileAdapter: CategoryProfileAdapter
    lateinit var workPlaceAdapter: WorkPlaceAdapter

    var categoryList: ArrayList<GetCaregiverMyProfileResponse.Data.CategoryData> = ArrayList()
    var workExperienceList: ArrayList<WorkExperienceData> = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_profile)
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtEditProfile.setOnClickListener(this)

        specialitiesAdapter = SpecialitiesAdapter(activity)
        recyclerSpecialities.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerSpecialities.isNestedScrollingEnabled = false
        recyclerSpecialities.adapter = specialitiesAdapter

        categoryProfileAdapter = CategoryProfileAdapter(activity, categoryList)
        recyclerCategory.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerCategory.isNestedScrollingEnabled = false
        recyclerCategory.adapter = categoryProfileAdapter

        workPlaceAdapter = WorkPlaceAdapter(activity, workExperienceList)
        recyclerWorkExperience.layoutManager =
            LinearLayoutManager(activity, RecyclerView.VERTICAL, false)
        recyclerWorkExperience.isNestedScrollingEnabled = false
        recyclerWorkExperience.adapter = workPlaceAdapter


    }

    override fun onResume() {
        super.onResume()
        getProfileApi()
    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtEditProfile -> startActivity(
                Intent(activity, PersonalDetailActivity::class.java)
                    .putExtra(PersonalDetailActivity.FROMEDIT, true)

//                        Intent(activity, EditProfileActivity::class.java)
//                    .putExtra(EditProfileActivity.FROMEDIT, true)
            )
        }
    }

    private fun getProfileApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType, pref.getString(Const.token).toString(),
                )
            )

            val getProfileCall: Call<GetCaregiverMyProfileResponse?> =
                RetrofitClient.getClient.getCaregiverMyProfile(langTokenRequest)
            getProfileCall.enqueue(object : Callback<GetCaregiverMyProfileResponse?> {
                override fun onResponse(
                    call: Call<GetCaregiverMyProfileResponse?>,
                    response: Response<GetCaregiverMyProfileResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val getCaregiverMyProfileResponse: GetCaregiverMyProfileResponse =
                            response.body()!!
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
                                txtBio.text = data.caregiverBio
                                txtExperience.text = data.totalYearWorkExperience
                                txtTransportationMethod.text = data.workMethodOfTransportationName
                                txtDistanceWilling.text = data.workDistancewillingTravel
                                txtSpeciality.text = data.workSpecialityName

                                categoryList.clear()
                                categoryList.addAll(data.categoryData)
                                categoryProfileAdapter.notifyDataSetChanged()

                                if (data.workExperienceData.isEmpty()) {
                                    linearBottom.visibility = View.GONE
                                } else {
                                    linearBottom.visibility = View.VISIBLE
                                    workExperienceList.clear()
                                    workExperienceList.addAll(data.workExperienceData)
                                    workPlaceAdapter.notifyDataSetChanged()
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
                    call: Call<GetCaregiverMyProfileResponse?>,
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
