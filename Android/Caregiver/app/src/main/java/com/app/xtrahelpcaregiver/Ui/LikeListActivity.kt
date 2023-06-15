package com.app.xtrahelpcaregiver.Ui

import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.LikeAdapter
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.FeedLikeUserListRequest
import com.app.xtrahelpcaregiver.Response.FeedLikeListResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import kotlinx.android.synthetic.main.activity_like_list.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class LikeListActivity : BaseActivity() {
    lateinit var likeAdapter: LikeAdapter
    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true

    companion object {
        val FEEDID = "feedId"
    }

    var feedId: String = ""
    var userLikeList: ArrayList<FeedLikeListResponse.Data> = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_like_list)
        txtTitle.text = "Likes"
        feedId = intent.getStringExtra(FEEDID).toString()
        init();
    }

    override fun onResume() {
        super.onResume()
        pageNum = 1
        isClearList = true
        getLikeListApi()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)

        likeAdapter = LikeAdapter(activity)
        recyclerLike.layoutManager = LinearLayoutManager(activity)
        recyclerLike.isNestedScrollingEnabled = false
        recyclerLike.adapter = likeAdapter

        recyclerLike.addOnScrollListener(object : RecyclerView.OnScrollListener() {
            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                super.onScrolled(recyclerView, dx, dy)
                if ((recyclerLike.layoutManager as LinearLayoutManager).findLastVisibleItemPosition() == userLikeList.size - 1 && pageNum != totalPage!!.toInt()
                ) {
                    pageNum++
                    isClearList = false
                    getLikeListApi()
                }
            }
        })
    }


    override fun onClick(view: View?) {
        when (view?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }

    private fun getLikeListApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = FeedLikeUserListRequest(
                FeedLikeUserListRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    feedId,
                    pageNum,
                    "15"
                )
            )

            val signUp: Call<FeedLikeListResponse?> =
                RetrofitClient.getClient.getFeedLikeUserList(langTokenRequest)
            signUp.enqueue(object : Callback<FeedLikeListResponse?> {
                override fun onResponse(
                    call: Call<FeedLikeListResponse?>,
                    response: Response<FeedLikeListResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: FeedLikeListResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                txtDataNotFound.visibility = View.GONE
                                recyclerLike.visibility = View.VISIBLE

                                if (isClearList) {
                                    userLikeList.clear()
                                }
                                totalPage = response.totalPages

                                userLikeList.addAll(response.data)
                                likeAdapter.setAdapterList(userLikeList)
                                likeAdapter.notifyDataSetChanged()

                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                                try {
                                    txtDataNotFound.text = response.message
                                    txtDataNotFound.visibility = View.VISIBLE
                                    recyclerLike.visibility = View.GONE
                                } catch (e: Exception) {
                                }
                            }

                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<FeedLikeListResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }
}