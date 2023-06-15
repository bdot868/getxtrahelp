package com.app.xtrahelpcaregiver.Ui

import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.MyReviewAdapter
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.CommentListRequest
import com.app.xtrahelpcaregiver.Request.MyReviewListRequest
import com.app.xtrahelpcaregiver.Response.CommentListResponse
import com.app.xtrahelpcaregiver.Response.MyReviewListResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import kotlinx.android.synthetic.main.activity_comment.*
import kotlinx.android.synthetic.main.activity_my_review.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MyReviewActivity : BaseActivity() {
    var reviewList: ArrayList<MyReviewListResponse.Data> = ArrayList()

    lateinit var myReviewAdapter: MyReviewAdapter
    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_my_review)
        txtTitle.text = "My Reviews"
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)

        myReviewAdapter = MyReviewAdapter(activity)
        recyclerReview.layoutManager = LinearLayoutManager(activity)
        recyclerReview.isNestedScrollingEnabled = false
        recyclerReview.adapter = myReviewAdapter

        recyclerReview.addOnScrollListener(object : RecyclerView.OnScrollListener() {
            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                super.onScrolled(recyclerView, dx, dy)
                if ((recyclerReview.layoutManager as LinearLayoutManager).findLastVisibleItemPosition() == reviewList.size - 1 && pageNum != totalPage!!.toInt()
                ) {
                    pageNum++
                    isClearList = false
                    getMyReviewListApi()
                }
            }
        })
    }

    override fun onResume() {
        super.onResume()
        pageNum = 1
        isClearList = true
        getMyReviewListApi()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }

    private fun getMyReviewListApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = MyReviewListRequest(
                MyReviewListRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    pref.getString(Const.id).toString(),
                    pageNum,
                    "10"
                )
            )

            val signUp: Call<MyReviewListResponse?> =
                RetrofitClient.getClient.getCaregiverReviewList(langTokenRequest)
            signUp.enqueue(object : Callback<MyReviewListResponse?> {
                override fun onResponse(
                    call: Call<MyReviewListResponse?>,
                    response: Response<MyReviewListResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: MyReviewListResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                try {
                                    txtDataNotFound.visibility = View.GONE
                                    recyclerComments.visibility = View.VISIBLE
                                } catch (e: Exception) {
                                }

                                if (isClearList) {
                                    reviewList.clear()

                                }
                                totalPage = response.totalPages

                                reviewList.addAll(response.data)
                                myReviewAdapter.setAdapterList(reviewList)
                                myReviewAdapter.notifyDataSetChanged()

                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                                try {
                                    txtDataNotFound.text = response.message
                                    txtDataNotFound.visibility = View.VISIBLE
                                    recyclerComments.visibility = View.GONE
                                } catch (e: Exception) {
                                }
                            }

                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<MyReviewListResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }
}