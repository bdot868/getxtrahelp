package com.app.xtrahelpuser.Ui

import android.content.Intent
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.transition.Fade
import android.view.View
import androidx.fragment.app.Fragment
import com.app.xtrahelpuser.CustomView.SharedFragTransition
import com.app.xtrahelpuser.R
import kotlinx.android.synthetic.main.activity_create_job.*

class CreateJobActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_create_job)
        init()
    }

    private fun init() {
        closeImg.setOnClickListener(this)
        txtGetStarted.setOnClickListener(this)
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.closeImg -> onBackPressed()
            R.id.txtGetStarted -> {
                startActivity(Intent(activity, AddJobActivity::class.java))
                finish()
            }

        }
    }

}