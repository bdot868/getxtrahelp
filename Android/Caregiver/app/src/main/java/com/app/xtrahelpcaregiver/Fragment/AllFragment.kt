package com.app.xtrahelpcaregiver.Fragment

import android.content.DialogInterface
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Adapter.MyJobAdapter
import com.app.xtrahelpcaregiver.Interface.CancelJobClickListener
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.CancelJobRequest
import com.app.xtrahelpcaregiver.Request.CaregiverRelatedJobRequest
import com.app.xtrahelpcaregiver.Response.CaregiverRelatedResponse
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Response.Job
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.android.synthetic.main.fragment_my_job_tab.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

open class AllFragment : BaseFragment(), CancelJobClickListener {
    private var mParam1: String? = null
    var search: String = ""

    lateinit var myJobAdapter: MyJobAdapter

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true

    val jobList: ArrayList<Job> = ArrayList()

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
            search = requireArguments().getString(SEARCH).toString()
        }
        init()
    }

    private fun init() {

        myJobAdapter = MyJobAdapter(activity, "")
        recyclerJob.layoutManager = LinearLayoutManager(activity)
        recyclerJob.isNestedScrollingEnabled = false
        recyclerJob.adapter = myJobAdapter
        myJobAdapter.cancelJobClickListener(this)

    }

    fun callInterface(search: String) {
        Log.e("TAG", "searchJob: $search ")
        pageNum = 1
        isClearList = true
        getCaregiverRelatedJobApi(search)
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
        val SEARCH = "search"
        fun newInstance(param1: String?): AllFragment {
            val fragment = AllFragment()
            val args = Bundle()
            args.putString(ARG_PARAM1, param1)
            fragment.arguments = args
            return fragment
        }
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
                    ""
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

//                                (getActivity() as MyJobFragment?)?.addTime(response.totalWorkTime)


                                if (isClearList) {
                                    jobList.clear()

                                }
                                totalPage = response.totalPages

                                jobList.addAll(response.data)
                                myJobAdapter?.setAdapterList(jobList)
                                myJobAdapter?.notifyDataSetChanged()

                                
                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
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

    private fun cancelJobRequestApi(jobId: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CancelJobRequest(
                CancelJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.cancelJobRequest(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val getJobCategoruListResponse: CommonResponse =
                            response.body()!!
                        when (getJobCategoruListResponse.status) {
                            "1" -> {
                                pageNum = 1
                                isClearList = true
                                getCaregiverRelatedJobApi(search)
                            }
                            "6" -> {
//                                utils.showCustomToast(getCertificationsLicensesResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    getJobCategoruListResponse.status,
                                    getJobCategoruListResponse.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<CommonResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    override fun onCancelJobClick(id: String?) {
        MaterialAlertDialogBuilder(activity)
            .setCancelable(false)
            .setMessage("Are you sure you want to cancel this job request?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int ->
                cancelJobRequestApi(id.toString())
            }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }


}