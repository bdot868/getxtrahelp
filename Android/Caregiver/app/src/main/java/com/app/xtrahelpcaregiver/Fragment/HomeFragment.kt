package com.app.xtrahelpcaregiver.Fragment

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
import com.app.xtrahelpcaregiver.Adapter.CategoryListAdapter
import com.app.xtrahelpcaregiver.Adapter.NearestAdapter
import com.app.xtrahelpcaregiver.Adapter.ResourceBlogAdapter
import com.app.xtrahelpcaregiver.Adapter.UpcomingAdapter
import com.app.xtrahelpcaregiver.Interface.CategoryClickListener
import com.app.xtrahelpcaregiver.Interface.OnFragmentInteractionListener
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.DashboardRequest
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Ui.*
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.google.gson.Gson
import kotlinx.android.synthetic.main.fragment_home.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class HomeFragment : BaseFragment(), CategoryClickListener {

    lateinit var upcomingAdapter: UpcomingAdapter;
    lateinit var nearestAdapter: NearestAdapter
    lateinit var categoryAdapter: CategoryListAdapter
    lateinit var resourceBlogAdapter: ResourceBlogAdapter

    var categoryDataList = ArrayList<CategoryData>()
    var resourceList: ArrayList<Resource> = ArrayList()
    var upcomingJobList: ArrayList<Job> = ArrayList()
    var nearestJobList: ArrayList<DashboardResponse.Data.NearestJob> = ArrayList()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return LayoutInflater.from(context).inflate(R.layout.fragment_home, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        init()
    }

    override fun onResume() {
        super.onResume()
        Log.e("asdklhsdsdsd", "onResume: " + pref.getString(Const.id))

        var loginResponse: LoginResponse? = null
        val userData: String = pref.getString(Const.userData).toString()
        if (!TextUtils.isEmpty(userData)) {
            loginResponse = Gson().fromJson(userData, LoginResponse::class.java)
            if (loginResponse != null) {
                val data: LoginData = loginResponse.data
                pref.setString(Const.id, data.id)
            }
        }
        txtAddress.text = pref.getString(Const.location)
        dashboardApiCall()
    }

    private fun init() {
        txtViewAllBlog.setOnClickListener(this)
        txtChange.setOnClickListener(this)
        etSearch.setOnClickListener(this)
        txtViewAllUpcoming.setOnClickListener(this)
        txtNearestViewAll.setOnClickListener(this)
        txtCategoryViewAll.setOnClickListener(this)
//        CategoryDataList= ArrayList()

        upcomingAdapter = UpcomingAdapter(activity, upcomingJobList)
        recyclerUpcoming.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerUpcoming.isNestedScrollingEnabled = false
        recyclerUpcoming.adapter = upcomingAdapter

        nearestAdapter = NearestAdapter(activity, nearestJobList)
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

    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.txtViewAllBlog -> startActivity(Intent(activity, BlogListActivity::class.java))
            R.id.etSearch -> startActivity(Intent(activity, SearchActivity::class.java))
            R.id.txtViewAllUpcoming -> {
                onFragmentInteractionListener!!.onFragmentInteraction(1)
            }
            R.id.txtNearestViewAll -> {
                startActivity(Intent(activity, SearchActivity::class.java))
            }

            R.id.txtCategoryViewAll -> {
                startActivity(
                    Intent(activity, CategoryListActivity::class.java)
                        .putExtra(CategoryListActivity.FROMHOME, true)
                )
            }
            R.id.txtChange -> {
                startActivity(Intent(activity, LocationChangeActivity::class.java))
            }
        }
    }

    var onFragmentInteractionListener: OnFragmentInteractionListener? = null

    override fun onAttach(context: Context) {
        super.onAttach(context)
        onFragmentInteractionListener = if (context is OnFragmentInteractionListener) {
            context
        } else {
            throw RuntimeException(
                context.toString() + "must implement OnFragmentInteractionListener"
            )
        }
    }

    private fun dashboardApiCall() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = DashboardRequest(
                DashboardRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    pref.getString(Const.TIME_ZONE)!!,
                    pref.getString(Const.latitude).toString(),
                    pref.getString(Const.longitude).toString()
                )
            )

            val signUp: Call<DashboardResponse?> =
                RetrofitClient.getClient.getCaregiverDashboard(langTokenRequest)
            signUp.enqueue(object : Callback<DashboardResponse?> {
                override fun onResponse(
                    call: Call<DashboardResponse?>,
                    response: Response<DashboardResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: DashboardResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                                if (response.data.upcomingJobs.isEmpty()) {
                                    linearUpcoming.visibility = View.GONE
                                } else {
                                    upcomingJobList.clear()
                                    upcomingJobList.addAll(response.data.upcomingJobs)
                                    upcomingAdapter.notifyDataSetChanged()
                                    linearUpcoming.visibility = View.VISIBLE
                                }

                                if (response.data.categories.isEmpty()) {
                                    linearCategories.visibility = View.GONE
                                } else {
                                    linearCategories.visibility = View.VISIBLE
                                    categoryDataList.clear()
                                    categoryDataList.addAll(response.data.categories)
                                    categoryAdapter.notifyDataSetChanged()
                                }

                                if (response.data.nearestJobs.isEmpty()) {
                                    linearNearest.visibility = View.GONE
                                } else {
                                    linearNearest.visibility = View.VISIBLE
                                    nearestJobList.clear()
                                    nearestJobList.addAll(response.data.nearestJobs)
                                    nearestAdapter.notifyDataSetChanged()
                                }

                                if (response.data.resourcesAndBlogs.isEmpty()) {
                                    linearResourceAndBlock.visibility = View.GONE
                                } else {
                                    linearResourceAndBlock.visibility = View.VISIBLE
                                    resourceList.clear()
                                    resourceList.addAll(response.data.resourcesAndBlogs)
                                    resourceBlogAdapter.setAdapterList(resourceList)
                                    resourceBlogAdapter.notifyDataSetChanged()
                                }

                            }
                            "6" -> {
//                                utils.showCustomToast(getCertificationsLicensesResponse.message)
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
                    call: Call<DashboardResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
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