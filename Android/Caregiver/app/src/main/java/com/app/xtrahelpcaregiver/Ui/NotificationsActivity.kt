package com.app.xtrahelpcaregiver.Ui

import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.NotificationAdapter
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.CaregiverTransactionRequest
import com.app.xtrahelpcaregiver.Response.NotificationListResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import kotlinx.android.synthetic.main.activity_notifications.*
import kotlinx.android.synthetic.main.activity_notifications.relative
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class NotificationsActivity : BaseActivity() {

    lateinit var notificationAdapter: NotificationAdapter
    var notificationList: ArrayList<NotificationListResponse.Data> = ArrayList()

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_notifications)
        init();
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtTitle.setText("Notifications")

        notificationAdapter = NotificationAdapter(activity)
        recyclerNotification.layoutManager = LinearLayoutManager(activity)
        recyclerNotification.isNestedScrollingEnabled = false
        recyclerNotification.adapter = notificationAdapter

        recyclerNotification.addOnScrollListener(object : RecyclerView.OnScrollListener() {
            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                super.onScrolled(recyclerView, dx, dy)
                if ((recyclerNotification.layoutManager as LinearLayoutManager).findLastVisibleItemPosition() == notificationList.size - 1 && pageNum != totalPage!!.toInt()
                ) {
                    pageNum++
                    isClearList = false
                    getNotificationListApi()
                }
            }
        })
    }

    override fun onResume() {
        super.onResume()
        pageNum = 1
        isClearList = true
        getNotificationListApi()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }

    private fun getNotificationListApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CaregiverTransactionRequest(
                CaregiverTransactionRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    pageNum,
                    "10",
                )
            )

            val signUp: Call<NotificationListResponse?> =
                RetrofitClient.getClient.getNotificationsList(langTokenRequest)
            signUp.enqueue(object : Callback<NotificationListResponse?> {
                override fun onResponse(
                    call: Call<NotificationListResponse?>,
                    response: Response<NotificationListResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: NotificationListResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                txtDataNotFound.visibility = View.GONE
                                recyclerNotification.visibility = View.VISIBLE
                                if (isClearList) {
                                    notificationList.clear()
                                }
                                totalPage = response.total_page

                                notificationList.addAll(response.data)
                                notificationAdapter.setAdapterList(notificationList)
                                notificationAdapter.notifyDataSetChanged()

                            }
                            "6" -> {
                                txtDataNotFound.visibility = View.VISIBLE
                                recyclerNotification.visibility = View.GONE
                                txtDataNotFound.text = response.message
                            }

                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<NotificationListResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }
}