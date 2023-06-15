package com.app.xtrahelpcaregiver.Ui

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.viewpager.widget.ViewPager.OnPageChangeListener
import com.app.xtrahelpcaregiver.Adapter.WelcomeAdapter
import com.app.xtrahelpcaregiver.R
import kotlinx.android.synthetic.main.activity_tutorial.*

class TutorialActivity : BaseActivity() {
       var currentPage = 0
    val NUM_PAGES = 0

    var pos = 0

    var images = intArrayOf(R.drawable.tutorial_1, R.drawable.tutorial_2, R.drawable.tutorial_3)

    lateinit var welcomeAdapter: WelcomeAdapter

    var title = arrayOf(
        "Your Xtra Help can change somebody’s world.",
        "Apply for jobs that suit you best!",
        "Earn a little Xtra in the care industry"
    )

    var detail = arrayOf(
        "If you are qualified to be a caregiver, be a part of a family that might need your special care.",
        "Read through the job description and apply according to your preferences.",
        "If you have some Xtra hours in your schedule, join Xtra Help to earn some extra money."
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_tutorial)
        init()

        welcomeAdapter = WelcomeAdapter(activity, images)
        viewPager.setAdapter(welcomeAdapter)


        viewPager.addOnPageChangeListener(object : OnPageChangeListener {
            override fun onPageScrolled(
                position: Int,
                positionOffset: Float,
                positionOffsetPixels: Int
            ) {
            }

            override fun onPageSelected(position: Int) {
                currentPage = position
                pos = position
                when (pos) {
                    0 -> {
                        txtTitle.text = title[0]
                        txtDesc.text = detail[0]
                        txtSkip.visibility = View.VISIBLE
                        progressBar.progress = 1
                    }
                    1 -> {
                        txtTitle.text = title[1]
                        txtDesc.text = detail[1]
                        txtSkip.visibility = View.VISIBLE
                        progressBar.progress = 2
                    }
                    2 -> {
                        txtTitle.text = title[2]
                        txtDesc.text = detail[2]
                        txtSkip.visibility = View.INVISIBLE
                        progressBar.setProgress(3)
                    }
                }
            }

            override fun onPageScrollStateChanged(state: Int) {}
        })
    }

    private fun init() {
        txtSkip.setOnClickListener(this)
        arrowNext.setOnClickListener(this)
    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.txtSkip -> {
                startActivity(Intent(activity, LoginActivity::class.java))
                finish()
            }

            R.id.arrowNext -> when (pos) {
                0 -> {
                    viewPager.currentItem = pos + 1
                }
                1 -> {
                    viewPager.currentItem = pos + 1
                }
                2 -> {
                    startActivity(Intent(this, LoginActivity::class.java))
                    finish()
                }
            }
        }
    }
}