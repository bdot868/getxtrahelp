package com.app.xtrahelpuser.Ui

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.app.xtrahelpuser.R
import kotlinx.android.synthetic.main.activity_job_success.*

class JobSuccessActivity : BaseActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_job_success)
        init()
    }

    private fun init(){
        txtViewPostedJobs.setOnClickListener(this)
        linearProfile.setOnClickListener(this)
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when(v?.id){
            R.id.txtViewPostedJobs-> onBackPressed()
            R.id.linearProfile-> startActivity(Intent(activity, CaregiverProfileActivity::class.java))
        }
    }

    override fun onBackPressed() {
        super.onBackPressed()
        finish()
    }
}