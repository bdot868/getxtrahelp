package com.app.xtrahelpcaregiver.Ui

import android.content.DialogInterface
import android.content.Intent
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.text.TextUtils
import android.transition.Fade
import android.view.Gravity
import android.view.View
import androidx.appcompat.app.ActionBarDrawerToggle
import androidx.fragment.app.Fragment
import androidx.viewpager2.widget.ViewPager2
import com.app.xtrahelpcaregiver.CustomView.SharedFragTransition
import com.app.xtrahelpcaregiver.Fragment.FeedFragment
import com.app.xtrahelpcaregiver.Fragment.HomeFragment
import com.app.xtrahelpcaregiver.Fragment.MyCalenderFragment
import com.app.xtrahelpcaregiver.Fragment.MyJobFragment
import com.app.xtrahelpcaregiver.Interface.OnFragmentInteractionListener
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.LangToken
import com.app.xtrahelpcaregiver.Request.LangTokenRequest
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Response.LoginData
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Response.NotificationCountResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.bumptech.glide.Glide
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.gson.Gson
import kotlinx.android.synthetic.main.activity_dashboard.*
import kotlinx.android.synthetic.main.dashboard_main.*
import kotlinx.android.synthetic.main.drawer_layout.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class DashboardActivity : BaseActivity(), OnFragmentInteractionListener {

    private var doubleBackToExitPressedOnce = false
    private val AUTOCOMPLETE_REQUEST_CODE = 123
    private val REQUEST_LOCATION = 1
    var locationManager: LocationManager? = null
    var latitude: String? = null
    var longitude: String? = null
    var lat: String? = null
    var lng: String? = null

    companion object {
        var toUpcoming = false
        var fromAward = false
        var TOUPCOMING = "toUpcoming"
        var FROMAWARD = "fromAward"
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_dashboard)
        toUpcoming = intent.getBooleanExtra(TOUPCOMING, false)
        fromAward = intent.getBooleanExtra(FROMAWARD, false)
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        menuImg.setOnClickListener(this)
        homeImg.setOnClickListener(this)
        myJobImg.setOnClickListener(this)
        myCalenderImg.setOnClickListener(this)
        feedImg.setOnClickListener(this)
        notificationIcon.setOnClickListener(this)
        messageImg.setOnClickListener(this)
        linearProfile.setOnClickListener(this)
        linearBilling.setOnClickListener(this)
        linearMyReview.setOnClickListener(this)
        linearSupport.setOnClickListener(this)
        linearNotification.setOnClickListener(this)
        linearAccount.setOnClickListener(this)
        linearSubscription.setOnClickListener(this)
        txtFeedback.setOnClickListener(this)
        txtExtraHelp.setOnClickListener(this)
        txtLogOut.setOnClickListener(this)

        if (toUpcoming) {
            toUpcoming = true
            setSelectedTab(1)
        } else if (fromAward) {
            setSelectedTab(1)
        } else {
            replaceFragment(0)
        }

//        var fragmentItems: ArrayList<BaseFragment> = ArrayList()
//        fragmentItems.add(HomeFragment())
//        fragmentItems.add(MyJobFragment())
//        fragmentItems.add(MyCalenderFragment())
//        fragmentItems.add(FeedFragment())

//        viewPager2.adapter = ViewPagerAdapter1(supportFragmentManager, fragmentItems)
//        viewPager2.setPageTransformer(true, DepthPageTransformer())
//
//        viewPager2.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
//            override fun onPageScrolled(
//                position: Int,
//                positionOffset: Float,
//                positionOffsetPixels: Int
//            ) {
//            }
//
//            override fun onPageSelected(position: Int) {
//                setSelectedTab(position)
//            }
//
//            override fun onPageScrollStateChanged(state: Int) {
//            }
//
//        })
//
        val actionBarDrawerToggle: ActionBarDrawerToggle = object : ActionBarDrawerToggle(
            activity,
            drawerLayout,
            R.string.navigation_drawer_open,
            R.string.navigation_drawer_close
        ) {
            override fun onDrawerOpened(drawerView: View) {
                super.onDrawerOpened(drawerView)
                utils.statusBarColor(activity, resources.getColor(R.color.txtPurple))

            }

            override fun onDrawerClosed(drawerView: View) {
                super.onDrawerClosed(drawerView)
                utils.statusBarColor(activity, resources.getColor(R.color.activity_bg))
            }
        }

        drawerLayout.addDrawerListener(actionBarDrawerToggle)
        actionBarDrawerToggle.syncState()
    }

    var pageChangeCallback: ViewPager2.OnPageChangeCallback =
        object : ViewPager2.OnPageChangeCallback() {
            override fun onPageSelected(position: Int) {
                super.onPageSelected(position)
                setSelectedTab(position)
            }
        }


    override fun onResume() {
        super.onResume()
        var loginResponse: LoginResponse? = null
        val userData: String = pref.getString(Const.userData).toString()
        if (!TextUtils.isEmpty(userData)) {
            loginResponse = Gson().fromJson(userData, LoginResponse::class.java)
            if (loginResponse != null) {
                val data: LoginData = loginResponse.data
                pref.setString(Const.id, data.id)

                imageName = data.profileImageName

                Glide.with(this)
                    .load(data.profileImageUrl)
                    .placeholder(R.drawable.placeholder)
                    .centerCrop()
                    .into(userImg)

                txtUserName.text = data.firstName + " " + data.lastName
                txtCityState.text = data.address

            }
        }
        getNotificationCountApi()
    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.arrowBack -> drawerLayout.closeDrawer(Gravity.LEFT)
            R.id.menuImg -> drawerLayout.openDrawer(Gravity.LEFT)
            R.id.homeImg -> setSelectedTab(0)
            R.id.myJobImg -> setSelectedTab(1)                                              
            R.id.myCalenderImg -> setSelectedTab(2)
            R.id.feedImg -> setSelectedTab(3)
            R.id.notificationIcon -> {
                startActivity(Intent(activity, NotificationsActivity::class.java))
//                startActivity(Intent(activity, UnderReviewActivity::class.java))
            }
            R.id.messageImg -> startActivity(Intent(activity, MessageActivity::class.java))
            R.id.linearProfile -> startActivity(Intent(activity, ProfileActivity::class.java))
            R.id.linearBilling -> startActivity(
                Intent(
                    activity,
                    PaymentBillingActivity::class.java
                )
            )
            R.id.linearMyReview -> startActivity(Intent(activity, MyReviewActivity::class.java))
            R.id.linearNotification -> startActivity(
                Intent(
                    activity,
                    NotificationSettingActivity::class.java
                )
            )
            R.id.linearSupport -> startActivity(Intent(activity, FAQsActivity::class.java))
            R.id.linearAccount -> startActivity(Intent(activity, AccountActivity::class.java))
            R.id.linearSubscription -> startActivity(
                Intent(activity, SubscriptionActivity::class.java)
                    .putExtra(SubscriptionActivity.FROMEDIT, true)
            )
            R.id.txtFeedback -> startActivity(Intent(activity, FeedbackActivity::class.java))
            R.id.txtExtraHelp -> startActivity(Intent(activity, AboutExtraHelpActivity::class.java))
            R.id.txtLogOut -> logOutPopup()
        }
    }

    fun setSelectedTab(pos: Int) {
        homeImg.setImageResource(if (pos == 0) R.drawable.home_select else R.drawable.home_unselect)
        myJobImg.setImageResource(if (pos == 1) R.drawable.my_job_select else R.drawable.my_job_unselect)
        myCalenderImg.setImageResource(if (pos == 2) R.drawable.my_calender_select else R.drawable.my_calender_unselect)
        feedImg.setImageResource(if (pos == 3) R.drawable.feed_select else R.drawable.feed_unselect)
//        viewPager2.currentItem = pos
        replaceFragment(pos)
    }

    fun replaceFragment(pos: Int) {
        var fragment: Fragment? = null
        fragment = if (pos == 0) {
            HomeFragment()
        } else if (pos == 1) {
            MyJobFragment()
        } else if (pos == 2) {
            MyCalenderFragment()
        } else {
            FeedFragment()
        }

        val fragmentTransaction = supportFragmentManager.beginTransaction()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            fragment.sharedElementEnterTransition = SharedFragTransition()
            fragment.enterTransition = Fade()
            fragment.exitTransition = Fade()
            fragment.sharedElementReturnTransition = SharedFragTransition()
        }
        fragmentTransaction.add(R.id.relativeFragment, fragment)
        fragmentTransaction.replace(R.id.relativeFragment, fragment)
        fragmentTransaction.commit()
    }

    private fun logOutPopup() {
        MaterialAlertDialogBuilder(this)
            .setIcon(R.mipmap.ic_launcher)
            .setTitle(getString(R.string.app_name))
            .setCancelable(false)
            .setMessage("Are you sure want to logout?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int -> logoutAPITask() }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }

    private fun logoutAPITask() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.logout(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>, response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: CommonResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                utils.logOut(activity, loginResponse.message)
                                finish()
                            }
                            "6" -> {
                                utils.showCustomToast(loginResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    drawerLayout,
                                    loginResponse.status,
                                    loginResponse.message
                                )
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

    override fun onFragmentInteraction(pos: Int) {
        if (pos == 1) {
            toUpcoming = true
        } else {

        }
        setSelectedTab(pos)
    }

    private fun getNotificationCountApi() {
        if (utils.isNetworkAvailable()) {
//            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<NotificationCountResponse?> =
                RetrofitClient.getClient.getUnreadNotificationsCount(langTokenRequest)
            signUp.enqueue(object : Callback<NotificationCountResponse?> {
                override fun onResponse(
                    call: Call<NotificationCountResponse?>,
                    response: Response<NotificationCountResponse?>
                ) {
//                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: NotificationCountResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                if (response.chatCount == "0") {
                                    txtUnreadChat.visibility = View.GONE
                                } else {
                                    txtUnreadChat.visibility = View.VISIBLE
                                    txtUnreadChat.text = response.chatCount
                                }

                                if (response.notificationCount == "0") {
                                    txtUnreadNoti.visibility = View.GONE
                                } else {
                                    txtUnreadNoti.visibility = View.VISIBLE
                                    txtUnreadNoti.text = response.notificationCount
                                }

                            }
                            "6" -> {

                            }

                            else -> {
                                checkStatus(drawerLayout, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<NotificationCountResponse?>, t: Throwable) {
//                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }
}