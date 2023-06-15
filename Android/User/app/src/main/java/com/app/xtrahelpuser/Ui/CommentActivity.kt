package com.app.xtrahelpuser.Ui

import android.app.Dialog
import android.content.DialogInterface
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.View
import android.view.Window
import android.widget.EditText
import android.widget.RelativeLayout
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Request.CommentListRequest
import com.app.xtrahelpcaregiver.Request.CommentReportRequest
import com.app.xtrahelpcaregiver.Request.DeleteCommentRequest
import com.app.xtrahelpcaregiver.Request.SetCommentRequest
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.CommentAdapter
import com.app.xtrahelpuser.Interface.CommentDeleteReportClickListener
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.CommentListResponse
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.android.synthetic.main.activity_comment.*
import kotlinx.android.synthetic.main.header.*
import org.apache.commons.lang3.StringEscapeUtils
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class CommentActivity : BaseActivity(), CommentDeleteReportClickListener {

    companion object {
        val USERFEEDID = "userJobId"
    }

    var alertDialog: Dialog? = null
    lateinit var commentAdapter: CommentAdapter
    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true
    var search = ""
    var isLoader = true
    var commentList: ArrayList<CommentListResponse.Data> = ArrayList()
    var userJobId: String = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_comment)
        txtTitle.text = "Comments"
        userJobId = intent.getStringExtra(USERFEEDID)!!

        init()
    }

    override fun onResume() {
        super.onResume()
        isLoader = true
        pageNum = 1
        isClearList = true
        getCommentListApi(search)
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        sendComment.setOnClickListener(this)

        commentAdapter = CommentAdapter(activity);
        recyclerComments.layoutManager = LinearLayoutManager(activity)
        recyclerComments.isNestedScrollingEnabled = false
        recyclerComments.adapter = commentAdapter
        commentAdapter.onReportDeleteClick(this)

        recyclerComments.addOnScrollListener(object : RecyclerView.OnScrollListener() {
            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                super.onScrolled(recyclerView, dx, dy)
                if ((recyclerComments.layoutManager as LinearLayoutManager).findLastVisibleItemPosition() == commentList.size - 1 && pageNum != totalPage!!.toInt()
                ) {
                    isLoader = true
                    pageNum++
                    isClearList = false
                    getCommentListApi(search)
                }
            }
        })
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.sendComment -> {
                if (etComment.text.toString().isNotEmpty()) {
                    setCommentApi()
                }
            }
        }
    }

    private fun getCommentListApi(search: String) {
        if (utils.isNetworkAvailable()) {
            if (isLoader) {
                utils.showProgress(activity)
            }
            val langTokenRequest = CommentListRequest(
                CommentListRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    userJobId,
                    search,
                    pageNum,
                    ""
                )
            )

            val signUp: Call<CommentListResponse?> =
                RetrofitClient.getClient.getFeedCommentList(langTokenRequest)
            signUp.enqueue(object : Callback<CommentListResponse?> {
                override fun onResponse(
                    call: Call<CommentListResponse?>,
                    response: Response<CommentListResponse?>
                ) {
                    if (isLoader) {
                        utils.dismissProgress()
                    }
                    if (response.isSuccessful) {
                        val response: CommentListResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                try {
                                    txtDataNotFound.visibility = View.GONE
                                    recyclerComments.visibility = View.VISIBLE
                                } catch (e: Exception) {
                                }

                                if (isClearList) {
                                    commentList.clear()

                                }
                                totalPage = response.totalPages

                                commentList.addAll(response.data)
                                commentAdapter.setAdapterList(commentList)
                                commentAdapter.notifyDataSetChanged()

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

                override fun onFailure(call: Call<CommentListResponse?>, t: Throwable) {
                    if (isLoader) {
                        utils.dismissProgress()
                    }
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun setCommentApi() {
        if (utils.isNetworkAvailable()) {
//            utils.showProgress(activity)
            val langTokenRequest = SetCommentRequest(
                SetCommentRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    userJobId,
                    StringEscapeUtils.unescapeJava(etComment.text.toString())
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.feedComment(langTokenRequest)
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
                                etComment.setText("")
                                utils.hideKeyboard(activity)

                                isLoader = false
                                getCommentListApi("")
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

    private fun reportApiTask(feedCommentId: String, description: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CommentReportRequest(
                CommentReportRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    feedCommentId,
                    description
                )
            )
            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.feedCommentReport(langTokenRequest)
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

    private fun deleteCommentApi(feedCommentId: String, pos: Int) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = DeleteCommentRequest(
                DeleteCommentRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    feedCommentId
                )
            )
            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.deleteFeedComment(langTokenRequest)
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
                                commentList.removeAt(pos)
                                commentAdapter.setAdapterList(commentList)
                                commentAdapter.notifyDataSetChanged()
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

    private fun reportPopUp(feedCommentId: String) {
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
                reportApiTask(feedCommentId, description)
                alertDialog!!.dismiss()
            }
        }
        alertDialog!!.show()
    }

    override fun reportCommentClick(feedCommentId: String) {
        reportPopUp(feedCommentId)
    }

    override fun deleteCommentClick(feedCommentId: String, pos: Int) {
        MaterialAlertDialogBuilder(this)
            .setCancelable(false)
            .setMessage("Are you sure want to delete this comment?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int -> deleteCommentApi(feedCommentId, pos) }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }
}