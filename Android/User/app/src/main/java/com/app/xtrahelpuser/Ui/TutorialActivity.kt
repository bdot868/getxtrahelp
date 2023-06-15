package com.app.xtrahelpuser.Ui

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.viewpager.widget.ViewPager
import com.app.xtrahelpuser.Adapter.WelcomeAdapter
import com.app.xtrahelpuser.R
import kotlinx.android.synthetic.main.activity_tutorial.*

class TutorialActivity : BaseActivity() {
    var currentPage = 0
    val NUM_PAGES = 0

    var pos = 0

    var images = intArrayOf(R.drawable.tutorial_1, R.drawable.tutorial_2, R.drawable.tutorial_3)

    lateinit var welcomeAdapter: WelcomeAdapter

    var title = arrayOf(
        "Every family deserves some Xtra Help",
        "Need some help? Post a job on Xtra Help!",
        "Connecting families through care!"
    )

    var detail = arrayOf(
        "Xtra Help provides unique care services, specifically designed for the special needs community.",
        "We make sure you are connected to qualified professionals depending upon your needs.",
        "It might sound challenging, but it is not. You can find qualified caregivers near you through Xtra Help"
    )


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_tutorial)
        init()

        welcomeAdapter = WelcomeAdapter(activity, images)
        viewPager.setAdapter(welcomeAdapter)


        viewPager.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
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