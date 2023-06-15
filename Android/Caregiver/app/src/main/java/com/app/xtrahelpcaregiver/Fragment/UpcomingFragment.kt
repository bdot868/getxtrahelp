package com.app.xtrahelpcaregiver.Fragment

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.ViewTreeObserver
import androidx.core.widget.NestedScrollView
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Adapter.MyJobAdapter
import com.app.xtrahelpcaregiver.Interface.CancelJobClickListener
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.CaregiverRelatedJobRequest
import com.app.xtrahelpcaregiver.Response.CaregiverRelatedResponse
import com.app.xtrahelpcaregiver.Response.Job
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import kotlinx.android.synthetic.main.fragment_my_job_tab.*
import kotlinx.android.synthetic.main.fragment_my_job_tab.relative
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

open class UpcomingFragment : BaseFragment(), CancelJobClickListener {
    private var mParam1: String? = null
    var search: String = ""

    lateinit var myJobAdapter: MyJobAdapter
    lateinit var myJobFragment: MyJobFragment

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true

    val jobList: ArrayList<Job> = ArrayList()
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
        nestedScroll = view.findViewById(R.id.nestedScroll)

        if (arguments != null) {
            mParam1 = requireArguments().getString(ARG_PARAM1)
        }
        init()
    }

    private fun init() {
        myJobAdapter = MyJobAdapter(activity, "1")
        recyclerJob.layoutManager = LinearLayoutManager(activity)
        recyclerJob.isNestedScrollingEnabled = false
        recyclerJob.adapter = myJobAdapter
        myJobAdapter.cancelJobClickListener(this)

        try {
            nestedScroll.viewTreeObserver
                .addOnScrollChangedListener(ViewTreeObserver.OnScrollChangedListener {
                    val view = nestedScroll.getChildAt(nestedScroll.childCount - 1) as View
                    val diff: Int = view.bottom - (nestedScroll.height + nestedScroll
                        .scrollY)
                    if (diff == 0 && pageNum != totalPage!!.toInt()) {
                        pageNum++
                        isClearList = false
                        getCaregiverRelatedJobApi(search)
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
        getCaregiverRelatedJobApi(search)
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
        getCaregiverRelatedJobApi(search)
    }

    private fun getCaregiverRelatedJobApi(search: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CaregiverRelatedJobRequest(
                CaregiverRelatedJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    pageNum,
                    "10",
                    search,
                    "1"
                )
            )

            val signUp: Call<CaregiverRelatedResponse?> =
                RetrofitClient.getClient.getCaregiverRelatedJobList(langTokenRequest)
            signUp.enqueue(object : Callback<CaregiverRelatedResponse?> {
                override fun onResponse(
                    call: Call<CaregiverRelatedResponse?>,
                    response: Response<CaregiverRelatedResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CaregiverRelatedResponse = response.body()!!
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

                override fun onFailure(call: Call<CaregiverRelatedResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    override fun onCancelJobClick(id: String?) {

    }

}