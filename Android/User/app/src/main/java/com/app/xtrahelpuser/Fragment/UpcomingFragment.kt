package com.app.xtrahelpuser.Fragment

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.ViewTreeObserver
import androidx.core.widget.NestedScrollView
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.MyJobAdapter
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.UserRelatedJobRequest
import com.app.xtrahelpuser.Response.JobData
import com.app.xtrahelpuser.Response.UserRelatedJobResponse
import kotlinx.android.synthetic.main.fragment_my_job_tab.*
import kotlinx.android.synthetic.main.fragment_my_job_tab.relative
import kotlinx.coroutines.Job
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

open class UpcomingFragment : BaseFragment() {
    private var mParam1: String? = null
    var search: String = ""

    lateinit var myJobAdapter: MyJobAdapter

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true

    val jobList: ArrayList<JobData> = ArrayList()
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
        myJobAdapter = MyJobAdapter(activity, "1")
        recyclerJob.layoutManager = LinearLayoutManager(activity)
        recyclerJob.isNestedScrollingEnabled = false
        recyclerJob.adapter = myJobAdapter

        try {
            nestedScroll.viewTreeObserver
                .addOnScrollChangedListener {
                    val view = nestedScroll.getChildAt(nestedScroll.childCount - 1) as View
                    val diff: Int = view.bottom - (nestedScroll.height + nestedScroll.scrollY)
                    if (diff == 0 && pageNum != totalPage!!.toInt()) {
                        pageNum++
                        isClearList = false
                        getUserRelatedJobList(search)
                    }
                }
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
        fun newInstance(param1: String?): UpcomingFragment {
            val fragment = UpcomingFragment()
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
            val langTokenRequest = UserRelatedJobRequest(
                UserRelatedJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    pageNum,
                    "10",
                    search,
                    "1"
                )
            )

            val signUp: Call<UserRelatedJobResponse?> =
                RetrofitClient.getClient.getUserRelatedJobList(langTokenRequest)
            signUp.enqueue(object : Callback<UserRelatedJobResponse?> {
                override fun onResponse(
                    call: Call<UserRelatedJobResponse?>,
                    response: Response<UserRelatedJobResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: UserRelatedJobResponse = response.body()!!
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

                override fun onFailure(call: Call<UserRelatedJobResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

}