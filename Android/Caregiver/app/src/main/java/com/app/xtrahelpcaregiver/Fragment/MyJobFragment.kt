package com.app.xtrahelpcaregiver.Fragment

import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.EditorInfo
import android.widget.HorizontalScrollView
import android.widget.PopupWindow
import android.widget.TextView
import androidx.core.content.res.ResourcesCompat
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.viewpager.widget.ViewPager
import com.app.xtrahelpcaregiver.Adapter.FilterCategoryAdapter
import com.app.xtrahelpcaregiver.Adapter.ViewPagerAdapter1
import com.app.xtrahelpcaregiver.CustomView.DepthPageTransformer
import com.app.xtrahelpcaregiver.Interface.FilterCategorySelectClick
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.CaregiverRelatedJobRequest
import com.app.xtrahelpcaregiver.Request.LangTokenSearch
import com.app.xtrahelpcaregiver.Request.LangTokenSearchRequest
import com.app.xtrahelpcaregiver.Response.CaregiverRelatedResponse
import com.app.xtrahelpcaregiver.Response.CategoryData
import com.app.xtrahelpcaregiver.Response.GetJobCategoryListResponse
import com.app.xtrahelpcaregiver.Ui.DashboardActivity
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import kotlinx.android.synthetic.main.fragment_my_job.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MyJobFragment : BaseFragment(), FilterCategorySelectClick {

    lateinit var filterCategoryAdapter: FilterCategoryAdapter

    lateinit var txtNewest: TextView
    lateinit var txtOldest: TextView
    lateinit var txtBehavioral: TextView
    lateinit var txtNonBehavioral: TextView
    lateinit var txtVerbal: TextView
    lateinit var txtNonVerbal: TextView

    var categoryDataList: ArrayList<CategoryData> = ArrayList()
    var selectedCatecory: ArrayList<String> = ArrayList()

    var isFirst: String = ""
    var isBehavioral: String = ""
    var isVerbal: String = ""

    var search: String = ""
    var type: String = ""


    lateinit var allFragment: AllFragment
    lateinit var upcomingFragment: UpcomingFragment
    lateinit var completeFragment: CompleteFragment
    lateinit var appliedFragment: AppliedFragment
    lateinit var substituteFragment: SubstituteFragment
    lateinit var awardFragment: AwardFragment


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_my_job, container, false)
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        init()

    }

    private fun init() {

        linearAll.setOnClickListener(this)
        linearUpcoming.setOnClickListener(this)
        linearComplete.setOnClickListener(this)
        linearApplied.setOnClickListener(this)
        linearSubstitute.setOnClickListener(this)
        linearAward.setOnClickListener(this)
        txtAward.setOnClickListener(this)
        filterImg.setOnClickListener(this)

        allFragment = AllFragment.newInstance("")
        upcomingFragment = UpcomingFragment.newInstance("1")
        completeFragment = CompleteFragment.newInstance("2")
        appliedFragment = AppliedFragment.newInstance("3")
        substituteFragment = SubstituteFragment.newInstance("4")
        awardFragment = AwardFragment.newInstance("5")

        var fragmentItems: ArrayList<BaseFragment> = ArrayList()
        fragmentItems.add(allFragment)
        fragmentItems.add(upcomingFragment)
        fragmentItems.add(completeFragment)
        fragmentItems.add(appliedFragment)
        fragmentItems.add(substituteFragment)
        fragmentItems.add(awardFragment)

        viewPager.adapter = ViewPagerAdapter1(childFragmentManager, fragmentItems)
        viewPager.setPageTransformer(true, DepthPageTransformer())

        getCaregiverRelatedJobApi("")

        viewPager.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
            override fun onPageScrolled(
                position: Int,
                positionOffset: Float,
                positionOffsetPixels: Int
            ) {
            }

            override fun onPageSelected(position: Int) {
                etSearch.setText("")
                setSelectedTab(position)
                when (position) {
                    0 -> {
                        type = ""
                        horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_LEFT)
                    }
                    1 -> {
                        type = "1"
                        horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_LEFT)
                    }
                    2 -> {
                        type = "2"
                        horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_LEFT)
                    }
                    3 -> {
                        type = "3"
                        horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_LEFT)
                    }
                    4 -> {
                        type = "4"
                        horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_RIGHT)
                    }
                    5 -> {
                        type = "5"
                        horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_RIGHT)
                    }
                }
            }

            override fun onPageScrollStateChanged(state: Int) {
            }

        })

        if (DashboardActivity.toUpcoming) {
            type = "1"
            setSelectedTab(1)
            DashboardActivity.toUpcoming = false
        } else if (DashboardActivity.fromAward) {
            type = "5"
            setSelectedTab(5)
            DashboardActivity.fromAward = false
            horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_RIGHT)
        }

        etSearch.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable) {
                if (TextUtils.isEmpty(s.toString().trim { it <= ' ' })) {
                    search = ""
                    when (type) {
                        "" -> {
                            allFragment.callInterface(search)
                        }
                        "1" -> {
                            upcomingFragment.callInterface(search)
                        }
                        "2" -> {
                            completeFragment.callInterface(search)
                        }
                        "3" -> {
                            appliedFragment.callInterface(search)
                        }

                        "4" -> {
                            substituteFragment.callInterface(search)
                        }

                        "5" -> {
                            awardFragment.callInterface(search)
                        }
                    }
                }
            }
        })

        etSearch.setOnEditorActionListener(TextView.OnEditorActionListener { v, i, event ->
            if (i == EditorInfo.IME_ACTION_SEARCH) {
                search = etSearch.text.toString().trim()
                utils.hideKeyBoardFromView(activity)
                when (type) {
                    "" -> {
                        allFragment.callInterface(search)
                    }
                    "1" -> {
                        upcomingFragment.callInterface(search)
                    }
                    "2" -> {
                        completeFragment.callInterface(search)
                    }
                    "3" -> {
                        appliedFragment.callInterface(search)
                    }
                    "4" -> {
                        substituteFragment.callInterface(search)
                    }
                    "5" -> {
                        awardFragment.callInterface(search)
                    }
                }
                return@OnEditorActionListener true
            }
            false
        })

        getCategoryApi()
    }

//    var pageChangeCallback: ViewPager2.OnPageChangeCallback =
//        object : ViewPager2.OnPageChangeCallback() {
//            override fun onPageSelected(position: Int) {
//                super.onPageSelected(position)
//                etSearch.setText("")
//                setSelectedTab(position)
//            }
//        }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.linearAll -> {
                setSelectedTab(0)
                type = ""
                horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_LEFT)
            }
            R.id.linearUpcoming -> {
                setSelectedTab(1)
                type = "1"
                horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_LEFT)
            }
            R.id.linearComplete -> {
                setSelectedTab(2)
                type = "2"
                horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_LEFT)
            }
            R.id.linearApplied -> {
                setSelectedTab(3)
                type = "3"
                horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_LEFT)
            }

            R.id.linearSubstitute -> {
                setSelectedTab(4)
                type = "4"
                horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_RIGHT)
            }

            R.id.linearAward -> {
                setSelectedTab(5)
                type = "5"
                horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_RIGHT)
            }
            R.id.txtAward -> {
                setSelectedTab(5)
                type = "5"
                horizontalScroll.fullScroll(HorizontalScrollView.FOCUS_RIGHT)
            }

            R.id.filterImg -> {
                filterPopUp()
            }


        }
    }


    private fun setSelectedTab(pos: Int) {
        val semiBold = ResourcesCompat.getFont(activity, R.font.rubik_medium)
        val regular = ResourcesCompat.getFont(activity, R.font.rubik_regular)
//        etSearch.setText("")
        txtAll.setTextColor(
            if (pos == 0) resources.getColor(R.color.txtPurple) else resources.getColor(
                R.color.txtDarkGray
            )
        )

        txtUpcoming.setTextColor(
            if (pos == 1) resources.getColor(R.color.txtPurple) else resources.getColor(
                R.color.txtDarkGray
            )
        )

        txtComplete.setTextColor(
            if (pos == 2) resources.getColor(R.color.txtPurple) else resources.getColor(
                R.color.txtDarkGray
            )
        )

        txtApplied.setTextColor(
            if (pos == 3) resources.getColor(R.color.txtPurple) else resources.getColor(
                R.color.txtDarkGray
            )
        )

        txtSubstitute.setTextColor(
            if (pos == 4) resources.getColor(R.color.txtPurple) else resources.getColor(
                R.color.txtDarkGray
            )
        )

        txtAward.setTextColor(
            if (pos == 5) resources.getColor(R.color.txtPurple) else resources.getColor(
                R.color.txtDarkGray
            )
        )

        txtAll.typeface = if (pos == 0) semiBold else regular
        txtUpcoming.typeface = if (pos == 1) semiBold else regular
        txtComplete.typeface = if (pos == 2) semiBold else regular
        txtApplied.typeface = if (pos == 3) semiBold else regular
        txtSubstitute.typeface = if (pos == 4) semiBold else regular
        txtAward.typeface = if (pos == 5) semiBold else regular

        lineAll.visibility = if (pos == 0) View.VISIBLE else View.GONE
        lineUpcoming.visibility = if (pos == 1) View.VISIBLE else View.GONE
        lineComplete.visibility = if (pos == 2) View.VISIBLE else View.GONE
        lineApplied.visibility = if (pos == 3) View.VISIBLE else View.GONE
        lineSubstitute.visibility = if (pos == 4) View.VISIBLE else View.GONE
        lineAward.visibility = if (pos == 5) View.VISIBLE else View.GONE

        viewPager.currentItem = pos

        viewPager.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
            override fun onPageScrolled(
                position: Int,
                positionOffset: Float,
                positionOffsetPixels: Int
            ) {

            }

            override fun onPageSelected(position: Int) {
                when (position) {
                    0 -> {
                        type = ""
                    }
                    1 -> {
                        type = "1"
                    }
                    2 -> {
                        type = "2"
                    }
                    3 -> {
                        type = "3"
                    }
                    4 -> {
                        type = "4"
                    }
                    5 -> {
                        type = "5"
                    }
                }
            }

            override fun onPageScrollStateChanged(state: Int) {

            }

        })
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
        txtNewest = view.findViewById(R.id.txtNewest)
        txtOldest = view.findViewById(R.id.txtOldest)
        txtBehavioral = view.findViewById(R.id.txtBehavioral)
        txtNonBehavioral = view.findViewById(R.id.txtNonBehavioral)
        txtVerbal = view.findViewById(R.id.txtVerbal)
        txtNonVerbal = view.findViewById(R.id.txtNonVerbal)

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

        filterCategoryAdapter = FilterCategoryAdapter(activity, categoryDataList, selectedCatecory)
        recyclerCategory.layoutManager = GridLayoutManager(activity, 2)
        recyclerCategory.isNestedScrollingEnabled = false
        recyclerCategory.adapter = filterCategoryAdapter
        filterCategoryAdapter.filterCategorySelectClick(this)

        txtCancel.setOnClickListener(View.OnClickListener {
            popupWindow.dismiss()
        })
    }

    private fun getCategoryApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
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
                    utils.dismissProgress()
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
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
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

    private fun getCaregiverRelatedJobApi(search: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CaregiverRelatedJobRequest(
                CaregiverRelatedJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    1,
                    "1",
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
                                txtTime.text = response.totalWorkTime
                            }
                            "6" -> {
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

    override fun onCategorySelectUnselect(id: String, isAdd: Boolean) {

    }
}