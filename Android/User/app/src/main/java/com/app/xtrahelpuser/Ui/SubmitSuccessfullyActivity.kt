package com.app.xtrahelpuser.Ui

import android.content.Intent
import android.os.Bundle
import android.view.View
import com.app.xtrahelpuser.R
import kotlinx.android.synthetic.main.activity_submit_successfully.*

class SubmitSuccessfullyActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_submit_successfully)
        init()
    }

    private fun init(){
        txtStarted.setOnClickListener(this)
    }
    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.txtStarted -> startActivity(Intent(activity, DashboardActivity::class.java))

        }

    }
}