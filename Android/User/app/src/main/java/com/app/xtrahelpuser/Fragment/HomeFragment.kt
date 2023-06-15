package com.app.xtrahelpuser.Fragment

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.CategoryData
import com.app.xtrahelpcaregiver.Response.LoginData
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.*
import com.app.xtrahelpuser.Interface.CategoryClickListener
import com.app.xtrahelpuser.Interface.OnFragmentInteractionListener
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.UserDashboardRequest
import com.app.xtrahelpuser.Response.*
import com.app.xtrahelpuser.Ui.*
import com.google.gson.Gson
import kotlinx.android.synthetic.main.activity_search.*
import kotlinx.android.synthetic.main.fragment_home.*
import kotlinx.android.synthetic.main.fragment_home.etSearch
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class HomeFragment : BaseFragment(), CategoryClickListener {
    lateinit var myJobAdapter: MyJobAdapter;
    lateinit var nearestAdapter: NearestAdapter
    lateinit var categoryAdapter: CategoryListAdapter
    lateinit var resourceBlogAdapter: ResourceBlogAdapter
    lateinit var ongoingAdapter: OngoingAdapter

    var categoryDataList: ArrayList<CategoryData> = ArrayList()
    var nearestCaregiverList: ArrayList<UserDashboardResponse.Data.NearestCaregiver> = ArrayList()
    var ongoingJobsList: ArrayList<UserDashboardResponse.Data.OnGoing> = ArrayList()
    var resourcesAndBlogsList: ArrayList<Resource> = ArrayList()
    var upcomingJobsList: ArrayList<JobData> = ArrayList()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_home, container, false)

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        init()
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
            }
        }
        Log.e(
            "dihasdkjhasd",
            "onResume: " + pref.getString(Const.latitude) + " " + pref.getString(Const.longitude)
        )

        Log.e(
            "ffffffdfg", "onResume: " + pref.getString(Const.location)
        )
        txtAddress.text = pref.getString(Const.location)
    }

    var onFragmentInteractionListener: OnFragmentInteractionListener? = null

    override fun onAttach(context: Context) {
        super.onAttach(context)
        onFragmentInteractionListener = if (context is OnFragmentInteractionListener) {
            context as OnFragmentInteractionListener
        } else {
            throw RuntimeException(
                context.toString() + "must implement OnFragmentInteractionListener"
            )
        }
    }


    private fun init() {
        txtViewAllCategories.setOnClickListener(this)
        etSearch.setOnClickListener(this)
        createImg.setOnClickListener(this)
        txtViewAllBlog.setOnClickListener(this)
        txtViewAllUpcoming.setOnClickListener(this)
        txtNearestViewAll.setOnClickListener(this)
        txtChange.setOnClickListener(this)

        myJobAdapter = MyJobAdapter(activity, "dashboard")
        recyclerUpcoming.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerUpcoming.isNestedScrollingEnabled = false
        recyclerUpcoming.adapter = myJobAdapter

        nearestAdapter = NearestAdapter(activity, nearestCaregiverList)
        recyclerNearest.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerNearest.isNestedScrollingEnabled = false
        recyclerNearest.adapter = nearestAdapter

        categoryAdapter = CategoryListAdapter(activity, "home", categoryDataList)
        recyclerCategories.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerCategories.isNestedScrollingEnabled = false
        recyclerCategories.adapter = categoryAdapter
        categoryAdapter.setOnCategoryClick(this)

        resourceBlogAdapter = ResourceBlogAdapter(activity)
        recyclerBlog.layoutManager = LinearLayoutManager(activity)
        recyclerBlog.isNestedScrollingEnabled = false
        recyclerBlog.adapter = resourceBlogAdapter

        ongoingAdapter = OngoingAdapter(activity, ongoingJobsList)
        recyclerOngoing.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerOngoing.isNestedScrollingEnabled = false
        recyclerOngoing.adapter = ongoingAdapter

        dashBoardApiCall()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.txtViewAllCategories -> startActivity(
                Intent(activity, CategoryListActivity::class.java)
                    .putExtra(CategoryListActivity.FROMHOME, true)
            )
            R.id.etSearch -> startActivity(Intent(activity, SearchActivity::class.java))
            R.id.createImg -> startActivity(Intent(activity, CreateJobActivity::class.java))
            R.id.txtViewAllBlog -> startActivity(Intent(activity, BlogListActivity::class.java))
            R.id.txtViewAllUpcoming -> {
                onFragmentInteractionListener!!.onFragmentInteraction(1)
            }

            R.id.txtNearestViewAll -> {
                onFragmentInteractionListener!!.onFragmentInteraction(2)
            }

            R.id.txtChange -> {
                startActivity(Intent(activity, LocationChangeActivity::class.java))
            }
        }
    }

    private fun dashBoardApiCall() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = UserDashboardRequest(
                UserDashboardRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    pref.getString(Const.TIME_ZONE).toString(),
//                    "", ""
                    pref.getString(Const.latitude).toString(),
                    pref.getString(Const.longitude).toString()
                )
            )

            val signUp: Call<UserDashboardResponse?> =
                RetrofitClient.getClient.getUserDashboard(langTokenRequest)
            signUp.enqueue(object : Callback<UserDashboardResponse?> {
                override fun onResponse(
                    call: Call<UserDashboardResponse?>,
                    response: Response<UserDashboardResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: UserDashboardResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                val data = response.data
                                try {
                                    if (data.upcomingJobs.isEmpty()) {
                                        linearUpcoming.visibility = View.GONE
                                    } else {
                                        linearUpcoming.visibility = View.VISIBLE
                                        upcomingJobsList.clear()
//                                    upcomingJobsList.addAll(data.upcomingJobs)
                                        myJobAdapter.setAdapterList(data.upcomingJobs)
                                        myJobAdapter.notifyDataSetChanged()
                                    }

                                } catch (e: Exception) {
                                }

                                try {
                                    if (data.nearestCaregiver.isEmpty()) {
                                        linearNearest.visibility = View.GONE
                                    } else {
                                        linearNearest.visibility = View.VISIBLE
                                        nearestCaregiverList.clear()
                                        nearestCaregiverList.addAll(data.nearestCaregiver)
                                        nearestAdapter.notifyDataSetChanged()
                                    }
                                } catch (e: Exception) {
                                }

                                try {
                                    if (data.categories.isEmpty()) {
                                        linearCategory.visibility = View.GONE
                                    } else {
                                        linearCategory.visibility = View.VISIBLE
                                        categoryDataList.clear()
                                        categoryDataList.addAll(data.categories)
                                        categoryAdapter.notifyDataSetChanged()
                                    }

                                } catch (e: Exception) {
                                }

                                try {
                                    if (data.resourcesAndBlogs.isEmpty()) {
                                        linearResources.visibility = View.GONE
                                    } else {
                                        linearResources.visibility = View.VISIBLE
                                        resourcesAndBlogsList.clear()
                                        resourceBlogAdapter.setAdapterList(data.resourcesAndBlogs)
                                        resourceBlogAdapter.notifyDataSetChanged()
                                    }
                                } catch (e: Exception) {
                                }


                                try {
                                    if (data.ongoingJobs.isEmpty()) {
                                        linearOnGoing.visibility = View.GONE
                                    } else {
                                        linearOnGoing.visibility = View.VISIBLE
                                        ongoingJobsList.clear()
                                        ongoingJobsList.addAll(data.ongoingJobs)
                                        ongoingAdapter.notifyDataSetChanged()
                                    }
                                } catch (e: Exception) {
                                }
                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                            }

                            else -> {
                                try {
                                    checkStatus(relative, response.status, response.message)
                                } catch (e: Exception) {
                                }
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<UserDashboardResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    override fun onCategoryClick(categoryId: String) {
        startActivity(
            Intent(activity, SearchActivity::class.java)
                .putExtra(SearchActivity.CATEGORYID, categoryId)
        )
    }


}