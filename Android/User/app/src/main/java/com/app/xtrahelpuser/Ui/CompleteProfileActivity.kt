package com.app.xtrahelpuser.Ui

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.TextUtils
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpuser.Adapter.ReviewAdapter
import com.app.xtrahelpuser.Adapter.WorkPlaceAdapter
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.CaregiverProfileResponse
import com.bumptech.glide.Glide
import com.google.gson.Gson
import kotlinx.android.synthetic.main.activity_complete_profile.*
import kotlinx.android.synthetic.main.header.*

class CompleteProfileActivity : BaseActivity() {

    companion object {
        val DATA = "data"
    }

    lateinit var reviewAdapter: ReviewAdapter
    var caregiverData = ""
    var caregiverProfileResponse: CaregiverProfileResponse? = null
    lateinit var workPlaceAdapter: WorkPlaceAdapter
    var workExperienceList: ArrayList<CaregiverProfileResponse.Data.WorkExperienceData> =
        ArrayList()

    var reviewList: ArrayList<CaregiverProfileResponse.Data.ReviewData> = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_complete_profile)
        txtTitle.text = "Complete Profile"
        caregiverData = intent.getStringExtra(DATA)!!

        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)

        reviewAdapter = ReviewAdapter(activity, reviewList)
        recyclerReview.layoutManager = LinearLayoutManager(activity)
        recyclerReview.isNestedScrollingEnabled = false
        recyclerReview.adapter = reviewAdapter

        workPlaceAdapter = WorkPlaceAdapter(activity, workExperienceList)
        recyclerWorkExperience.layoutManager =
            LinearLayoutManager(activity, RecyclerView.VERTICAL, false)
        recyclerWorkExperience.isNestedScrollingEnabled = false
        recyclerWorkExperience.adapter = workPlaceAdapter

        if (!TextUtils.isEmpty(caregiverData)) {
            caregiverProfileResponse =
                Gson().fromJson(caregiverData, CaregiverProfileResponse::class.java)
            val data = caregiverProfileResponse!!.data

            Glide.with(activity)
                .load(data.profileImageThumbUrl)
                .centerCrop()
                .placeholder(R.drawable.placeholder)
                .into(userImg)

            ratingBar.rating = data.ratingAverage.toFloat()
            txtUserName.text = data.fullName
            txtBio.text = data.caregiverBio
            txtSpeciality.text = data.workSpecialityName
            txtExperience.text = data.totalYearWorkExperience
            txtTransportationMethod.text = data.workMethodOfTransportationName
            txtDistanceWilling.text = data.workDisabilitiesWillingTypeName

            if (data.workExperienceData.isEmpty()) {
                linearWorkEx.visibility = View.GONE
            } else {
                linearWorkEx.visibility = View.VISIBLE
                workExperienceList.clear()
                workExperienceList.addAll(data.workExperienceData)
                workPlaceAdapter.notifyDataSetChanged()
            }

            if (data.reviewData.isEmpty()) {
                linearReview.visibility = View.GONE
            } else {
                linearReview.visibility = View.VISIBLE
                reviewList.clear()
                reviewList.addAll(data.reviewData)
                reviewAdapter.notifyDataSetChanged()
            }

            if (data.reviewData.isEmpty() && data.workExperienceData.isEmpty()) {
                linearBottom.visibility = View.GONE
            }
        }
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }
}