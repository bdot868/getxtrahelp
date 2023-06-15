package com.app.xtrahelpcaregiver.Fragment

import android.content.DialogInterface
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Adapter.MyJobAdapter
import com.app.xtrahelpcaregiver.Adapter.SubstituteAdapter
import com.app.xtrahelpcaregiver.Interface.AcceptRejectSubJobClickListener
import com.app.xtrahelpcaregiver.Interface.CancelJobClickListener
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.AcceptRejectSubJobRequest
import com.app.xtrahelpcaregiver.Request.CancelJobRequest
import com.app.xtrahelpcaregiver.Request.CaregiverRelatedJobRequest
import com.app.xtrahelpcaregiver.Request.SubstituteJobRequest
import com.app.xtrahelpcaregiver.Response.CaregiverRelatedResponse
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Response.Job
import com.app.xtrahelpcaregiver.Response.SubstituteListResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.android.synthetic.main.fragment_my_job_tab.*
import kotlinx.android.synthetic.main.fragment_my_job_tab.relative
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

open class SubstituteFragment : BaseFragment(),
    AcceptRejectSubJobClickListener {
    private var mParam1: String? = null
    var search: String = ""

    lateinit var myJobAdapter: SubstituteAdapter


    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true

    val jobList: ArrayList<SubstituteListResponse.Data> = ArrayList()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_my_job_tab, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        if (arguments != null) {
            mParam1 = requireArguments().getString(ARG_PARAM1)
        }
        init()
    }

    private fun init() {
        myJobAdapter = SubstituteAdapter(activity)
        recyclerJob.layoutManager = LinearLayoutManager(activity)
        recyclerJob.isNestedScrollingEnabled = false
        recyclerJob.adapter = myJobAdapter
        myJobAdapter.onSubClick(this)

//        nestedScroll.getViewTreeObserver()
//                .addOnScrollChangedListener(ViewTreeObserver.OnScrollChangedListener {
//                    val view = nestedScroll.getChildAt(nestedScroll.getChildCount() - 1) as View
//                    val diff: Int = view.bottom - (nestedScroll.getHeight() + nestedScroll
//                        .getScrollY())
//                    if (diff == 0 && pageNum != totalPage!!.toInt()) {
//                        pageNum++
//                        isClearList = false
//                        getCaregiverRelatedJobApi(search)
//                    }
//                })
    }

    override fun onResume() {
        super.onResume()
        pageNum = 1
        isClearList = true
        if (search == "null") {
            search = ""
        }
        getCaregiverRelatedJobApi(search)
    }

    companion object {
        val ARG_PARAM1 = "param1"
        fun newInstance(param1: String?): SubstituteFragment {
            val fragment = SubstituteFragment()
            val args = Bundle()
            args.putString(ARG_PARAM1, param1)
            fragment.arguments = args
            return fragment
        }
    }

    fun callInterface(search: String) {
        Log.e("TAG", "searchJob: $search ")
        pageNum = 1
        isClearList = true
        getCaregiverRelatedJobApi(search)
    }

    private fun getCaregiverRelatedJobApi(search: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = SubstituteJobRequest(
                SubstituteJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    pageNum,
                    "10",
                    search
                )
            )

            val signUp: Call<SubstituteListResponse?> =
                RetrofitClient.getClient.getSubstituteJobRequestList(langTokenRequest)
            signUp.enqueue(object : Callback<SubstituteListResponse?> {
                override fun onResponse(
                    call: Call<SubstituteListResponse?>,
                    response: Response<SubstituteListResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: SubstituteListResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                try {
                                    txtDataNotFound.visibility = View.GONE
                                    recyclerJob.visibility = View.VISIBLE
                                } catch (e: Exception) {
                                }

                                if (isClearList) {
                                    jobList.clear()

                                }
                                totalPage = response.totalPages

                                jobList.addAll(response.data)
                                myJobAdapter?.setAdapterList(jobList)
                                myJobAdapter?.notifyDataSetChanged()

                            }
                            "6" -> {
                                try {
                                    txtDataNotFound.text = response.message
                                    txtDataNotFound.visibility = View.VISIBLE
                                    recyclerJob.visibility = View.GONE
                                } catch (e: Exception) {
                                }
                            }

                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<SubstituteListResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun acceptRequestApi(substituteRequestId: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = AcceptRejectSubJobRequest(
                AcceptRejectSubJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    substituteRequestId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.acceptSubstituteJobRequest(langTokenRequest)
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
                                getCaregiverRelatedJobApi("")
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

    private fun rejectRequestApi(substituteRequestId: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = AcceptRejectSubJobRequest(
                AcceptRejectSubJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    substituteRequestId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.rejectSubstituteJobRequest(langTokenRequest)
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
                                getCaregiverRelatedJobApi("")
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

    override fun onSubClick(substituteRequestId: String, isAccept: Boolean) {
        if (isAccept) {
            acceptRequestApi(substituteRequestId)
        }else {
            rejectRequestApi(substituteRequestId)
        }
    }
}