package com.app.xtrahelpcaregiver.Ui

import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.view.ViewTreeObserver
import android.view.inputmethod.EditorInfo
import android.widget.EditText
import android.widget.PopupWindow
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.Nullable
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.FilterCategoryAdapter
import com.app.xtrahelpcaregiver.Adapter.SearchHistoryAdapter
import com.app.xtrahelpcaregiver.Adapter.SearchResultsAdapter
import com.app.xtrahelpcaregiver.Adapter.SpecialitiesFilterAdapter
import com.app.xtrahelpcaregiver.Interface.FilterCategorySelectClick
import com.app.xtrahelpcaregiver.Interface.FilterSpecialitiesSelectClick
import com.app.xtrahelpcaregiver.Interface.RemoveSearchHistoryClick
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.*
import com.app.xtrahelpcaregiver.Request.CommonData
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.google.android.flexbox.FlexboxLayoutManager
import com.mohammedalaa.seekbar.DoubleValueSeekBarView
import com.mohammedalaa.seekbar.OnDoubleValueSeekBarChangeListener
import com.mohammedalaa.seekbar.OnRangeSeekBarChangeListener
import com.mohammedalaa.seekbar.RangeSeekBarView
import kotlinx.android.synthetic.main.activity_login.*
import kotlinx.android.synthetic.main.activity_search.*
import kotlinx.android.synthetic.main.activity_search.relative
import kotlinx.android.synthetic.main.activity_work_details.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.*
import kotlin.collections.ArrayList


class SearchActivity : BaseActivity(), FilterCategorySelectClick, FilterSpecialitiesSelectClick,
    RemoveSearchHistoryClick {

    companion object {
        val CATEGORYID = "categoryId"
    }

    lateinit var searchResultsAdapter: SearchResultsAdapter
    lateinit var searchHistoryAdapter: SearchHistoryAdapter
    lateinit var filterCategoryAdapter: FilterCategoryAdapter
    lateinit var specialitiesAdapter: SpecialitiesFilterAdapter

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true
    var search = ""

    var jobList: ArrayList<GetUserJobResponse.Data> = ArrayList()

    var selectedCategory: ArrayList<String> = ArrayList()
    var selectedSpeciality: ArrayList<String> = ArrayList()
    var searchHistoryList: ArrayList<SearchHistoryResponse.Data> = ArrayList()

    var categoryDataList: ArrayList<CategoryData> = ArrayList()
    val workSpecialityList: ArrayList<WorkSpeciality> = ArrayList()

    lateinit var txtNewest: TextView
    lateinit var txtOldest: TextView
    lateinit var txtBehavioral: TextView
    lateinit var txtNonBehavioral: TextView
    lateinit var txtVerbal: TextView
    lateinit var txtNonVerbal: TextView
    lateinit var txtRecurring: TextView
    lateinit var txtOneTime: TextView
    lateinit var txtYes: TextView
    lateinit var txtNo: TextView
    lateinit var etAllergies: EditText
    lateinit var seekBar: DoubleValueSeekBarView


    var isFirst: String = ""
    var jobType: String = ""
    var isVaccinated: String = ""
    var isBehavioral: String = ""
    var isVerbal: String = ""
    var categoryId = ""
    var allergies = ""
    var minSeekValue = ""
    var maxSeekValue = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_search)
        categoryId = intent.getStringExtra(CATEGORYID).toString()

        if (categoryId != "null" && categoryId.isNotEmpty()) {
            selectedCategory.add(categoryId)
        }

        init();
    }


    private fun init() {
        filterImg.setOnClickListener(this)
        txtCancel.setOnClickListener(this)
        txtClear.setOnClickListener(this)

        getCategoryApi()
        getCommonDataApi()
        getUserSearchHistoryApi()

        pageNum = 1
        isClearList = true
        getUserJobListApi(search)

        etSearch.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable) {
                if (TextUtils.isEmpty(s.toString().trim { it <= ' ' })) {
                    jobList.clear()
                    search = ""
                    getUserJobListApi(search)
                }
            }
        })

        etSearch.setOnEditorActionListener(TextView.OnEditorActionListener { v, i, event ->
            if (i == EditorInfo.IME_ACTION_SEARCH) {
                jobList.clear()
                search = etSearch.text.toString().trim { it <= ' ' }
                getUserJobListApi(search)
                utils.hideKeyBoardFromView(activity)
                return@OnEditorActionListener true
            }
            false
        })


        nestedScroll.viewTreeObserver
            .addOnScrollChangedListener(ViewTreeObserver.OnScrollChangedListener {
                val view = nestedScroll.getChildAt(nestedScroll.getChildCount() - 1) as View
                val diff: Int = view.bottom - (nestedScroll.getHeight() + nestedScroll
                    .getScrollY())
                if (diff == 0 && pageNum != totalPage!!.toInt()) {
                    pageNum++
                    isClearList = false
                    getUserJobListApi(search)
                }
            })

        val layoutManager = FlexboxLayoutManager(activity)
        searchHistoryAdapter = SearchHistoryAdapter(activity, searchHistoryList)
        recyclerFilter.layoutManager = layoutManager
        recyclerFilter.adapter = searchHistoryAdapter
        searchHistoryAdapter.removeSearchHistoryClick(this)

        searchResultsAdapter = SearchResultsAdapter(activity)
        recyclerResult.layoutManager = LinearLayoutManager(activity)
        recyclerResult.isNestedScrollingEnabled = false
        recyclerResult.adapter = searchResultsAdapter


    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.filterImg -> filterPopUp()
            R.id.txtCancel -> finish()
            R.id.txtClear -> {
                clearUserHistoryApi()
            }
        }
    }

    private fun filterPopUp() {
        val view = layoutInflater.inflate(R.layout.job_filter_popup, null, false)
        val popupWindow = PopupWindow(
            view,
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        popupWindow.showAtLocation(view, Gravity.CENTER, 0, 0)

        val txtCancel: TextView = view.findViewById(R.id.txtCancel)
        val recyclerCategory: RecyclerView = view.findViewById(R.id.recyclerCategory)
        val txtApplyFilter: TextView = view.findViewById(R.id.txtApplyFilter)
        val txtReset: TextView = view.findViewById(R.id.txtReset)
        val recyclerSpecialities: RecyclerView = view.findViewById(R.id.recyclerSpecialities)
          
        popupWindow.isFocusable = true
        popupWindow.update()

        txtNewest = view.findViewById(R.id.txtNewest)
        txtOldest = view.findViewById(R.id.txtOldest)
        txtBehavioral = view.findViewById(R.id.txtBehavioral)
        txtNonBehavioral = view.findViewById(R.id.txtNonBehavioral)
        txtVerbal = view.findViewById(R.id.txtVerbal)
        txtNonVerbal = view.findViewById(R.id.txtNonVerbal)
        txtRecurring = view.findViewById(R.id.txtRecurring)
        txtOneTime = view.findViewById(R.id.txtOneTime)
        txtYes = view.findViewById(R.id.txtYes)
        txtNo = view.findViewById(R.id.txtNo)
        etAllergies = view.findViewById(R.id.etAllergies)
        seekBar = view.findViewById(R.id.seekBar)


        if (minSeekValue.isNotEmpty() || maxSeekValue.isNotEmpty()) {
            seekBar.currentMaxValue = maxSeekValue.toInt()
            seekBar.currentMinValue = minSeekValue.toInt()
        }


        filterCategoryAdapter = FilterCategoryAdapter(activity, categoryDataList, selectedCategory)
        recyclerCategory.layoutManager = GridLayoutManager(activity, 2)
        recyclerCategory.isNestedScrollingEnabled = false
        recyclerCategory.adapter = filterCategoryAdapter
        filterCategoryAdapter.filterCategorySelectClick(this)

        specialitiesAdapter =
            SpecialitiesFilterAdapter(activity, workSpecialityList, selectedSpeciality)
        recyclerSpecialities.layoutManager = GridLayoutManager(activity, 2)
        recyclerSpecialities.isNestedScrollingEnabled = false
        recyclerSpecialities.adapter = specialitiesAdapter
        specialitiesAdapter.filterSpecialitiesSelectClick(this)

        if (isFirst == "1") {
            setNewest(1)
        } else if (isFirst == "2") {
            setNewest(2)
        }

        if (isBehavioral == "1") {
            setBehavioral(1)
        } else if (isBehavioral == "2") {
            setBehavioral(2)
        }

        if (isVerbal == "1") {
            setVerbal(1)
        } else if (isVerbal == "2") {
            setVerbal(2)
        }

        if (jobType == "1") {
            setJobType(1)
        } else if (jobType == "2") {
            setJobType(2)
        }

        if (isVaccinated == "1") {
            setVaccine(1)
        } else if (isVaccinated == "2") {
            setVaccine(2)
        }

        txtNewest.setOnClickListener {
            setNewest(1)
        }

        txtOldest.setOnClickListener {
            setNewest(2)
        }

        txtBehavioral.setOnClickListener {
            setBehavioral(1)
        }

        txtNonBehavioral.setOnClickListener {
            setBehavioral(2)
        }

        txtVerbal.setOnClickListener {
            setVerbal(1)
        }

        txtNonVerbal.setOnClickListener {
            setVerbal(2)
        }

        txtRecurring.setOnClickListener {
            setJobType(1)
        }

        txtOneTime.setOnClickListener {
            setJobType(2)
        }

        txtYes.setOnClickListener {
            setVaccine(1)
        }

        txtNo.setOnClickListener {
            setVaccine(2)
        }

        txtCancel.setOnClickListener(View.OnClickListener {
            popupWindow.dismiss()
        })

        txtApplyFilter.setOnClickListener {
            allergies = etAllergies.text.toString()
            minSeekValue = seekBar.currentMinValue.toString()
            maxSeekValue = seekBar.currentMaxValue.toString()

            if (minSeekValue == "1" && maxSeekValue == "10") {
                minSeekValue = ""
                maxSeekValue = ""
            }

            getUserJobListApi(search)
            popupWindow.dismiss()
        }

        txtReset.setOnClickListener {
            resetFilter()
        }
    }

    private fun resetFilter() {
        txtNewest.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtNewest.background = resources.getDrawable(R.drawable.unselect_bg);
        txtOldest.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtOldest.background = resources.getDrawable(R.drawable.unselect_bg);
        txtNonBehavioral.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtNonBehavioral.background = resources.getDrawable(R.drawable.unselect_bg);
        txtBehavioral.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtBehavioral.background = resources.getDrawable(R.drawable.unselect_bg);
        txtNonVerbal.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtNonVerbal.background = resources.getDrawable(R.drawable.unselect_bg);
        txtVerbal.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtVerbal.background = resources.getDrawable(R.drawable.unselect_bg)
        txtOneTime.setTextColor(resources.getColor(R.color.txtLightPurple));
        txtOneTime.background = resources.getDrawable(R.drawable.unselect_bg);
        txtRecurring.setTextColor(resources.getColor(R.color.txtLightPurple));
        txtRecurring.background = resources.getDrawable(R.drawable.unselect_bg);
        txtYes.setTextColor(resources.getColor(R.color.txtLightPurple));
        txtYes.background = resources.getDrawable(R.drawable.unselect_bg);
        txtNo.setTextColor(resources.getColor(R.color.txtLightPurple));
        txtNo.background = resources.getDrawable(R.drawable.unselect_bg);

        etAllergies.setText("")

        seekBar.currentMinValue = 1
        seekBar.currentMaxValue = 10

        minSeekValue = ""
        maxSeekValue = ""
        allergies = ""
        isVaccinated = ""
        jobType = ""
        isFirst = ""
        isBehavioral = ""
        isVerbal = ""
        selectedCategory.clear()
        selectedSpeciality.clear()
        specialitiesAdapter.notifyDataSetChanged()
        filterCategoryAdapter.notifyDataSetChanged()

    }

    private fun setNewest(pos: Int) {
        txtNewest.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtNewest.background = resources.getDrawable(R.drawable.unselect_bg);
        txtOldest.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtOldest.background = resources.getDrawable(R.drawable.unselect_bg);

        if (pos == 1) {
            txtNewest.background = resources.getDrawable(R.drawable.select_bg);
            txtNewest.setTextColor(resources.getColor(R.color.txtOrange))
            isFirst = "1"
        } else {
            txtOldest.background = resources.getDrawable(R.drawable.select_bg);
            txtOldest.setTextColor(resources.getColor(R.color.txtOrange))
            isFirst = "2"
        }
    }

    private fun setBehavioral(pos: Int) {
        txtBehavioral.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtBehavioral.background = resources.getDrawable(R.drawable.unselect_bg);
        txtNonBehavioral.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtNonBehavioral.background = resources.getDrawable(R.drawable.unselect_bg);
        if (pos == 1) {
            txtBehavioral.background = resources.getDrawable(R.drawable.select_bg);
            txtBehavioral.setTextColor(resources.getColor(R.color.txtOrange))
            isBehavioral = "1"
        } else {
            txtNonBehavioral.setTextColor(resources.getColor(R.color.txtOrange))
            txtNonBehavioral.background = resources.getDrawable(R.drawable.select_bg);
            isBehavioral = "2"
        }
    }

    private fun setJobType(pos: Int) {
        txtRecurring.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtRecurring.background = resources.getDrawable(R.drawable.unselect_bg);
        txtOneTime.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtOneTime.background = resources.getDrawable(R.drawable.unselect_bg);
        if (pos == 1) {
            txtRecurring.background = resources.getDrawable(R.drawable.select_bg);
            txtRecurring.setTextColor(resources.getColor(R.color.txtOrange))
            jobType = "1"
        } else {
            txtOneTime.background = resources.getDrawable(R.drawable.select_bg);
            txtOneTime.setTextColor(resources.getColor(R.color.txtOrange))
            jobType = "2"
        }
    }

    private fun setVerbal(pos: Int) {
        txtVerbal.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtVerbal.background = resources.getDrawable(R.drawable.unselect_bg);
        txtNonVerbal.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtNonVerbal.background = resources.getDrawable(R.drawable.unselect_bg);
        if (pos == 1) {
            txtVerbal.background = resources.getDrawable(R.drawable.select_bg);
            txtVerbal.setTextColor(resources.getColor(R.color.txtOrange))
            isVerbal = "1"
        } else {
            txtNonVerbal.background = resources.getDrawable(R.drawable.select_bg);
            txtNonVerbal.setTextColor(resources.getColor(R.color.txtOrange))
            isVerbal = "2"
        }
    }

    private fun setVaccine(pos: Int) {
        txtYes.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtYes.background = resources.getDrawable(R.drawable.unselect_bg);
        txtNo.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtNo.background = resources.getDrawable(R.drawable.unselect_bg);
        if (pos == 1) {
            txtYes.background = resources.getDrawable(R.drawable.select_bg);
            txtYes.setTextColor(resources.getColor(R.color.txtOrange))
            isVaccinated = "1"
        } else {
            txtNo.background = resources.getDrawable(R.drawable.select_bg);
            txtNo.setTextColor(resources.getColor(R.color.txtOrange))
            isVaccinated = "2"
        }
    }

    private fun getUserJobListApi(search: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = GetUserJobListRequest(
                GetUserJobListRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    pageNum,
                    "10",
                    pref.getString(Const.latitude).toString(),
                    pref.getString(Const.longitude).toString(),
//                    "-122.08408969999998",
//                    "37.422065599999996",
                    search,
                    selectedCategory,
                    isFirst,
                    isBehavioral,
                    isVerbal,
                    allergies,
                    selectedSpeciality,
                    isVaccinated,
                    jobType,
                    minSeekValue,
                    maxSeekValue
                )
            )

            val signUp: Call<GetUserJobResponse?> =
                RetrofitClient.getClient.getUserJobList(langTokenRequest)
            signUp.enqueue(object : Callback<GetUserJobResponse?> {
                override fun onResponse(
                    call: Call<GetUserJobResponse?>, response: Response<GetUserJobResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: GetUserJobResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                getUserSearchHistoryApi()
                                txtNoJobFound.visibility = View.GONE
                                recyclerResult.visibility = View.VISIBLE
                                if (isClearList) {
                                    jobList.clear()

                                }
                                totalPage = response.totalPages

                                jobList.addAll(response.data)
                                searchResultsAdapter.setAdapterList(jobList)
                                searchResultsAdapter.notifyDataSetChanged()

                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                                txtNoJobFound.text = response.message
                                txtNoJobFound.visibility = View.VISIBLE
                                recyclerResult.visibility = View.GONE
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<GetUserJobResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getCategoryApi() {
        if (utils.isNetworkAvailable()) {
//            utils.showProgress(activity)
            val langTokenRequest = LangTokenSearchRequest(
                LangTokenSearch(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    ""
                )
            )

            val signUp: Call<GetJobCategoryListResponse?> =
                RetrofitClient.getClient.getJobCategoryList(langTokenRequest)
            signUp.enqueue(object : Callback<GetJobCategoryListResponse?> {
                override fun onResponse(
                    call: Call<GetJobCategoryListResponse?>,
                    response: Response<GetJobCategoryListResponse?>
                ) {
//                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val getJobCategoruListResponse: GetJobCategoryListResponse =
                            response.body()!!
                        when (getJobCategoruListResponse.status) {
                            "1" -> {
                                categoryDataList.clear()
                                categoryDataList.addAll(getJobCategoruListResponse.data)
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
                    call: Call<GetJobCategoryListResponse?>,
                    t: Throwable
                ) {
//                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getCommonDataApi() {
        if (utils.isNetworkAvailable()) {
//            utils.showProgress(activity)
            val commonDataRequest = CommonDataRequest(
                CommonData(
                    Const.langType,
                )
            )

            val signUp: Call<CommonDataResponse?> =
                RetrofitClient.getClient.getCommonData(commonDataRequest)
            signUp.enqueue(object : Callback<CommonDataResponse?> {
                override fun onResponse(
                    call: Call<CommonDataResponse?>, response: Response<CommonDataResponse?>
                ) {
//                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val commonDataResponse: CommonDataResponse = response.body()!!
                        when (commonDataResponse.status) {
                            "1" -> {
                                workSpecialityList.clear()
                                workSpecialityList.addAll(commonDataResponse.data.workSpeciality)
                            }
                            "6" -> {
                                utils.showCustomToast(commonDataResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    commonDataResponse.status,
                                    commonDataResponse.status
                                )
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<CommonDataResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getUserSearchHistoryApi() {
        if (utils.isNetworkAvailable()) {
//            utils.showProgress(activity)
            val langTokenRequest = SearchHistoryRequest(
                SearchHistoryRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    "1",
                    "5",
                    ""
                )
            )

            val signUp: Call<SearchHistoryResponse?> =
                RetrofitClient.getClient.getUserSearchHistory(langTokenRequest)
            signUp.enqueue(object : Callback<SearchHistoryResponse?> {
                override fun onResponse(
                    call: Call<SearchHistoryResponse?>,
                    response: Response<SearchHistoryResponse?>
                ) {
//                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val getJobCategoruListResponse: SearchHistoryResponse =
                            response.body()!!
                        when (getJobCategoruListResponse.status) {
                            "1" -> {
                                linearSearchHistory.visibility = View.VISIBLE
                                searchHistoryList.clear()
                                searchHistoryList.addAll(getJobCategoruListResponse.data)
                                searchHistoryAdapter.notifyDataSetChanged()
                            }
                            "6" -> {
                                linearSearchHistory.visibility = View.GONE
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
                    call: Call<SearchHistoryResponse?>,
                    t: Throwable
                ) {
//                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun clearUserHistoryApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.clearUserSearchHistory(langTokenRequest)
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
                                getUserSearchHistoryApi()
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

    private fun removeSearchApi(id: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = RemoveSearchRequest(
                RemoveSearchRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    id
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.removeUserSearchHistory(langTokenRequest)
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
                                getUserSearchHistoryApi()
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

    override fun onCategorySelectUnselect(id: String, isAdd: Boolean) {
        if (isAdd) {
            selectedCategory.add(id)
        } else {
            selectedCategory.remove(id)
        }
        filterCategoryAdapter.notifyDataSetChanged()
    }

    override fun onSpecialitiesSelectUnselect(id: String, isAdd: Boolean) {
        if (isAdd) {
            selectedSpeciality.add(id)
        } else {
            selectedSpeciality.remove(id)
        }

        specialitiesAdapter.notifyDataSetChanged()
    }

    override fun removeSearchClick(id: String, isRemove: Boolean) {
        if (isRemove) {
            removeSearchApi(id)
        } else {
            etSearch.setText(id)
            jobList.clear()
            search = etSearch.text.toString().trim { it <= ' ' }
            getUserJobListApi(search)
        }
    }


}