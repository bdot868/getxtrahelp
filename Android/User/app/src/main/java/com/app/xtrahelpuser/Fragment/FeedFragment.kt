package com.app.xtrahelpuser.Fragment

import android.app.Dialog
import android.content.DialogInterface
import android.content.Intent
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.text.TextUtils
import android.view.*
import android.widget.EditText
import android.widget.RelativeLayout
import androidx.core.widget.NestedScrollView
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Request.DeleteFeedRequest
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Response.LoginData
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.FeedAdapter
import com.app.xtrahelpuser.Interface.FeedLikeUnlikeClickListener
import com.app.xtrahelpuser.Interface.ReportFeedClickListener
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.FeedListRequest
import com.app.xtrahelpuser.Request.LikeUnlikeRequest
import com.app.xtrahelpuser.Request.ReportFeedRequest
import com.app.xtrahelpuser.Response.FeedListResponse
import com.app.xtrahelpuser.Ui.CreateFeedActivity
import com.bumptech.glide.Glide
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.gson.Gson
import kotlinx.android.synthetic.main.adapter_subscription.relative
import kotlinx.android.synthetic.main.fragment_feed.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


class FeedFragment : BaseFragment(), FeedLikeUnlikeClickListener, ReportFeedClickListener {
    lateinit var feedAdapter: FeedAdapter
    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true
    var search = ""
    var alertDialog: Dialog? = null
    var feedList: ArrayList<FeedListResponse.Data> = ArrayList()
    lateinit var nestedScroll: NestedScrollView

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_feed, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        nestedScroll = view.findViewById(R.id.nestedScroll)
        init()                                                           
    }

    private fun init() {
        linearFeed.setOnClickListener(this)

        feedAdapter = FeedAdapter(activity)
        recyclerFeed.layoutManager = LinearLayoutManager(activity)
        recyclerFeed.isNestedScrollingEnabled = false
        recyclerFeed.adapter = feedAdapter;
        feedAdapter.feedLikeUnlikeClickListener(this)
        feedAdapter.reportFeedClickListener(this)

        nestedScroll.viewTreeObserver.addOnScrollChangedListener {
                val view = nestedScroll.getChildAt(nestedScroll.childCount - 1) as View
                val diff: Int = view.bottom - (nestedScroll.height + nestedScroll
                    .scrollY)
                if (diff == 0 && pageNum != totalPage!!.toInt()) {
                    pageNum++
                    isClearList = false
                    getFeedApi(search)
                }
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

                Glide.with(this)
                    .load(data.profileImageUrl)
                    .placeholder(R.drawable.placeholder)
                    .centerCrop()
                    .into(userImg)
            }
        }

        pageNum = 1
        isClearList = true
        getFeedApi(search)
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.linearFeed -> startActivity(Intent(activity, CreateFeedActivity::class.java))
        }
    }

    private fun getFeedApi(search: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = FeedListRequest(
                FeedListRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    search,
                    pageNum,
                    "",
                )
            )

            val signUp: Call<FeedListResponse?> =
                RetrofitClient.getClient.getUserFeedList(langTokenRequest)
            signUp.enqueue(object : Callback<FeedListResponse?> {
                override fun onResponse(
                    call: Call<FeedListResponse?>,
                    response: Response<FeedListResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: FeedListResponse = response.body()!!
                        when (response.status) {
                            "1" -> {

                                txtDataNotFound.visibility = View.GONE
                                recyclerFeed.visibility = View.VISIBLE

                                if (isClearList) {
                                    feedList.clear()
                                }
                                totalPage = response.totalPages

                                feedList.addAll(response.data)
                                feedAdapter.setAdapterList(feedList)
                                feedAdapter.notifyDataSetChanged()

                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                                try {
                                    txtDataNotFound.text = response.message
                                    txtDataNotFound.visibility = View.VISIBLE
                                    recyclerFeed.visibility = View.GONE
                                } catch (e: Exception) {
                                }
                            }

                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<FeedListResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun likeUnlikeFeedApi(feedId: String, pos: Int, isLike: Boolean) {
        if (utils.isNetworkAvailable()) {
//            utils.showProgress(activity)
            val langTokenRequest = LikeUnlikeRequest(
                LikeUnlikeRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    feedId,
                )
            )
            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.likeUnlikeFeed(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
//                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                var totalLike: Int = feedList[pos].totalFeedLike.toInt()
                                if (isLike) {
                                    totalLike++
                                    feedList[pos].isLike = "1"
                                    feedList[pos].totalFeedLike = totalLike.toString()
                                } else {
                                    totalLike--
                                    feedList[pos].isLike = "0"
                                    feedList[pos].totalFeedLike = totalLike.toString()
                                }
                                feedAdapter.notifyDataSetChanged()
                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                            }

                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<CommonResponse?>, t: Throwable) {
//                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun reportApiTask(feedId: String, description: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = ReportFeedRequest(
                ReportFeedRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    feedId,
                    description
                )
            )
            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.feedReport(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                utils.customToast(activity, response.message)
                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                            }

                            else -> {
                                checkStatus(relative, response.status, response.message)
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

    private fun reportPopUp(feedId: String) {
        alertDialog = Dialog(activity)
        alertDialog!!.requestWindowFeature(Window.FEATURE_NO_TITLE)
        alertDialog!!.getWindow()?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        alertDialog!!.setContentView(R.layout.feed_report_popup)
        alertDialog!!.setCancelable(true)
        val etReport: EditText = alertDialog!!.findViewById<EditText>(R.id.etReport)
        val relativeReport: RelativeLayout =
            alertDialog!!.findViewById<RelativeLayout>(R.id.relativeReport)
        relativeReport.setOnClickListener { v: View? ->
            if (etReport.text.toString() != "") {
                val description = etReport.text.toString()
                reportApiTask(feedId, description)
                alertDialog!!.dismiss()
            }
        }
        alertDialog!!.show()
    }

    private fun deletePostApi(feedId: String, pos: Int) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = DeleteFeedRequest(
                DeleteFeedRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    feedId
                )
            )
            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.deleteFeed(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                utils.customToast(activity, response.message)
                                feedList.removeAt(pos)
                                feedAdapter.setAdapterList(feedList)
                                feedAdapter.notifyDataSetChanged()
//                                getCommentListApi("")
                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                            }

                            else -> {
                                checkStatus(relative, response.status, response.message)
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

    override fun onFeedLikeUnlikeClick(feedId: String, pos: Int, isLike: Boolean) {
        likeUnlikeFeedApi(feedId, pos, isLike)
    }

    override fun reportClick(feedId: String) {
        reportPopUp(feedId)
    }

    override fun deleteFeedClick(feedId: String, pos: Int) {
        MaterialAlertDialogBuilder(activity)
            .setCancelable(false)
            .setMessage("Are you sure want to delete this post?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int -> deletePostApi(feedId, pos) }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }
}