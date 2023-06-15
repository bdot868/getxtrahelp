package com.app.xtrahelpuser.Fragment

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.NestedScrollView
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.MyJobAdapter
import com.app.xtrahelpuser.Adapter.PostedJobAdapter
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.GetPostedJobRequest
import com.app.xtrahelpuser.Response.GetMyPostedJobResponse
import kotlinx.android.synthetic.main.fragment_my_job_tab.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


open class PostedJobFragment : BaseFragment() {
    private var mParam1: String? = null
    var myJobAdapter: MyJobAdapter? = null
    var postedJobAdapter: PostedJobAdapter? = null

    var pageNum = 1
    var search = ""
    var totalPage = "1"
    private var isClearList = true

    var myJobList: ArrayList<GetMyPostedJobResponse.Data> = ArrayList()
    lateinit var nestedScroll: NestedScrollView

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_my_job_tab, container, false)
    }

    companion object {
        val ARG_PARAM1 = "param1"
        fun newInstance(param1: String?): PostedJobFragment {
            val fragment = PostedJobFragment()
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
        getMyPostedJobApi(search)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        if (arguments != null) {
            mParam1 = requireArguments().getString(ARG_PARAM1)
        }
        init()
    }

    override fun onResume() {
        super.onResume()
        pageNum = 1
        isClearList = true
        getMyPostedJobApi(search)
    }

    private fun init() {
        nestedScroll = view?.findViewById(R.id.nestedScroll)!!
        if (mParam1 == "2") {
            try {
                nestedScroll.viewTreeObserver.addOnScrollChangedListener {
                    val view = nestedScroll.getChildAt(nestedScroll.childCount - 1) as View
                    val diff: Int = view.bottom - (nestedScroll.height + nestedScroll.scrollY)
                    if (diff == 0 && pageNum != totalPage.toInt()) {
                        pageNum++
                        isClearList = false
                        getMyPostedJobApi(search)
                    }
                }
            } catch (e: Exception) {

            }


            postedJobAdapter = PostedJobAdapter(activity, mParam1)
            recyclerJob.layoutManager = LinearLayoutManager(activity)
            recyclerJob.isNestedScrollingEnabled = false
            recyclerJob.adapter = postedJobAdapter

        } else {
            myJobAdapter = MyJobAdapter(activity, mParam1)
            recyclerJob.layoutManager = LinearLayoutManager(activity)
            recyclerJob.isNestedScrollingEnabled = false
            recyclerJob.adapter = myJobAdapter
        }


    }

    private fun getMyPostedJobApi(search: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = GetPostedJobRequest(
                GetPostedJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    search,
                    pageNum,
                    "10",
                )
            )

            val signUp: Call<GetMyPostedJobResponse?> =
                RetrofitClient.getClient.getMyPostedJob(langTokenRequest)
            signUp.enqueue(object : Callback<GetMyPostedJobResponse?> {
                override fun onResponse(
                    call: Call<GetMyPostedJobResponse?>,
                    response: Response<GetMyPostedJobResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: GetMyPostedJobResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                                try {
                                    recyclerJob.visibility = View.VISIBLE
                                    lblDataNotFound.visibility = View.GONE
                                } catch (e: Exception) {
                                }
                                if (isClearList) {
                                    myJobList.clear()
                                }
                                totalPage = response.totalPages


                                myJobList.addAll(response.data)
                                postedJobAdapter?.setAdapterList(myJobList)
                                postedJobAdapter?.notifyDataSetChanged()
                            }
                            "6" -> {
                                recyclerJob.visibility = View.GONE
                                lblDataNotFound.visibility = View.VISIBLE
                                lblDataNotFound.text = response.message
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    response.status,
                                    response.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<GetMyPostedJobResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

}