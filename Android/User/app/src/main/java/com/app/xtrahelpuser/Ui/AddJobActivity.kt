package com.app.xtrahelpuser.Ui

import android.app.Activity
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.transition.Fade
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatDelegate
import androidx.fragment.app.Fragment
import com.app.xtrahelpuser.CustomView.SharedFragTransition
import com.app.xtrahelpuser.Fragment.*
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.SaveUserJobRequest
import kotlinx.android.synthetic.main.activity_add_job.*
import java.util.ArrayList

class AddJobActivity : BaseActivity() {

    var finishActivity: Handler? = null
    val ac: Activity = this

    companion object {
        var categoryId: String = ""
        var jobName: String = ""
        var jobPrice: String = ""
        var jobLocation: String = ""
        var jobLatitude: String = ""
        var jobLongitude: String = ""
        var jobdescription: String = ""
        var isJob: String = "1"
        var ownTransportation: String = "0"
        var nonSmoker: String = "0"
        var currentEmployment: String = "0"
        var minExperience: String = "0"
        var yearExperience: String = ""
        var subCategoryIds: ArrayList<String> = ArrayList()
        var additionalQuestions: ArrayList<SaveUserJobRequest.AdditionalQuestion> = ArrayList()
        var media: ArrayList<SaveUserJobRequest.Media> = ArrayList()
        var jobTiming: SaveUserJobRequest.JobTiming =
            SaveUserJobRequest.JobTiming(ArrayList(), "", "")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add_job)
        init()
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
//        activity.setContentView(R.layout.activity_add_job)
        clearAllValue()
    }

    fun init() {
//        relativeNext.setOnClickListener(this)
//        relativeBack.setOnClickListener(this)

        finishActivity = object : Handler() {
            override fun handleMessage(message: Message) {
                super.handleMessage(message)
                when (message.what) {
                    0 -> finish()
                }
            }
        }

        replaceFragment(LookingForFragment())
//        replaceFragment(TimeScheduleFragment())
    }


    fun clearAllValue(){
        categoryId = ""
        jobName = ""
        jobPrice = ""
        jobLocation = ""
        jobLatitude = ""
        jobLongitude = ""
        jobdescription = ""
        isJob = "1"
        ownTransportation = "0"
        nonSmoker = "0"
        currentEmployment = "0"
        minExperience = "0"
        yearExperience = ""
        subCategoryIds = ArrayList()
        additionalQuestions = ArrayList()
        media = ArrayList()
        jobTiming = SaveUserJobRequest.JobTiming(ArrayList(), "", "")
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
//            R.id.relativeNext -> nextFragment()
//            R.id.relativeBack -> backFragment()

        }
    }

    override fun onBackPressed() {
        super.onBackPressed()
        backFragment()
    }

    fun nextFragment() {
        when (supportFragmentManager.findFragmentById(R.id.relativeAddJob)) {
            null -> {
                finish()
            }
            is LookingForFragment -> {
                replaceFragment(PreferencesFragment())
            }
            is PreferencesFragment -> {
                replaceFragment(JobDetailsFragment())
            }
            is JobDetailsFragment -> {
                replaceFragment(PhotoVideosFragment())
            }
            is PhotoVideosFragment -> {
                replaceFragment(TimeScheduleFragment())
            }
        }
    }


    fun backFragment() {
        when (supportFragmentManager.findFragmentById(R.id.relativeAddJob)) {
            null -> {
                finish()
            }
            is TimeScheduleFragment -> {
                replaceFragment(PhotoVideosFragment())
            }
            is PhotoVideosFragment -> {
                replaceFragment(JobDetailsFragment())
            }
            is JobDetailsFragment -> {
                replaceFragment(PreferencesFragment())
            }
            is PreferencesFragment -> {
                replaceFragment(LookingForFragment())
            }
            is LookingForFragment -> {
                finish()
            }
        }
    }

    fun replaceFragment(fragment: Fragment) {
        val transaction = supportFragmentManager.beginTransaction()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            fragment.sharedElementEnterTransition = SharedFragTransition()
            fragment.enterTransition = Fade()
            fragment.exitTransition = Fade()
            fragment.sharedElementReturnTransition = SharedFragTransition()
        }
        transaction.add(R.id.relativeAddJob, fragment)
        transaction.replace(R.id.relativeAddJob, fragment)
        transaction.commit()
    }
}