package com.app.xtrahelpuser.Fragment

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.ViewTreeObserver
import android.widget.Toast
import androidx.core.widget.NestedScrollView
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.MyJobAdapter
import com.app.xtrahelpuser.Adapter.SubstituteAdapter
import com.app.xtrahelpuser.Interface.AcceptRejectSubJobClickListener
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.AcceptRejectSubJobRequest
import com.app.xtrahelpuser.Request.CancelJobRequest
import com.app.xtrahelpuser.Request.SubstituteJobRequest
import com.app.xtrahelpuser.Response.JobData
import com.app.xtrahelpuser.Response.SubstituteListResponse
import com.app.xtrahelpuser.Response.UserRelatedJobResponse
import kotlinx.android.synthetic.main.activity_job_detail.*
import kotlinx.android.synthetic.main.fragment_my_job_tab.*
import kotlinx.android.synthetic.main.fragment_my_job_tab.relative
import kotlinx.android.synthetic.main.fragment_my_job_tab.txtDataNotFound
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

open class SubstituteJobFragment : BaseFragment(), AcceptRejectSubJobClickListener {
    private var mParam1: String? = null
    var search: String = ""

    lateinit var myJobAdapter: SubstituteAdapter

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true

    val jobList: ArrayList<SubstituteListResponse.Data> = ArrayList()
    lateinit var nestedScroll: NestedScrollView
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
        nestedScroll = view.findViewById(R.id.nestedScroll)
        init()
    }

    private fun init() {

        myJobAdapter = SubstituteAdapter(activity)
        recyclerJob.layoutManager = LinearLayoutManager(activity)
        recyclerJob.isNestedScrollingEnabled = false
        recyclerJob.adapter = myJobAdapter
        myJobAdapter.onSubClick(this)

        try {
            nestedScroll.viewTreeObserver
                .addOnScrollChangedListener(ViewTreeObserver.OnScrollChangedListener {
                    val view = nestedScroll.getChildAt(nestedScroll.childCount - 1) as View
                    val diff: Int = view.bottom - (nestedScroll.height + nestedScroll.scrollY)
                    if (diff == 0 && pageNum != totalPage!!.toInt()) {
                        pageNum++
                        isClearList = false
                        getUserRelatedJobList(search)
                    }
                })
        } catch (e: Exception) {
        }
    }

    override fun onResume() {
        super.onResume()
        pageNum = 1
        isClearList = true
        if (search == "null") {
            search = ""
        }
        getUserRelatedJobList(search)
    }

    companion object {
        val ARG_PARAM1 = "param1"
        fun newInstance(param1: String?): SubstituteJobFragment {
            val fragment = SubstituteJobFragment()
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
        getUserRelatedJobList(search)
    }

    private fun getUserRelatedJobList(search: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = SubstituteJobRequest(
                SubstituteJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    pageNum,
                    "10"
                )
            )

            val signUp: Call<SubstituteListResponse?> =
                RetrofitClient.getClient.getUserSubstituteJobRequestList(langTokenRequest)
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
                                myJobAdapter.setAdapterList(jobList)
                                myJobAdapter.notifyDataSetChanged()

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
                RetrofitClient.getClient.acceptSubstituteJobRequestByUser(langTokenRequest)
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
                                getUserRelatedJobList("")
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
                RetrofitClient.getClient.rejectSubstituteJobRequestByUser(langTokenRequest)
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
                                getUserRelatedJobList("")
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
//            Toast.makeText(activity, "Accept", Toast.LENGTH_SHORT).show()
        } else {
//            Toast.makeText(activity, "Decline", Toast.LENGTH_SHORT).show()
            rejectRequestApi(substituteRequestId)
        }
    }


}