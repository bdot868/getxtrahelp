package com.app.xtrahelpuser.Ui

import android.app.DatePickerDialog
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
import androidx.recyclerview.widget.LinearLayoutManager

import android.widget.TextView
import androidx.appcompat.widget.AppCompatCheckBox
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Request.LangTokenSearch
import com.app.xtrahelpcaregiver.Request.LangTokenSearchRequest
import com.app.xtrahelpcaregiver.Response.CategoryData
import com.app.xtrahelpcaregiver.Response.GetJobCategoryListResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.CaregiverAdapter
import com.app.xtrahelpuser.Adapter.FilterAdapter
import com.app.xtrahelpuser.Adapter.FilterCategoryAdapter
import com.app.xtrahelpuser.Interface.FilterCategorySelectClick
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.FindCaregiverRequest
import com.app.xtrahelpuser.Response.FindCaregiverResponse
import com.google.android.flexbox.FlexboxLayoutManager
import com.mohammedalaa.seekbar.DoubleValueSeekBarView
import kotlinx.android.synthetic.main.activity_search.*
import kotlinx.android.synthetic.main.activity_search.etSearch
import kotlinx.android.synthetic.main.activity_search.filterImg
import kotlinx.android.synthetic.main.activity_search.relative
import kotlinx.android.synthetic.main.activity_search.txtDataNotFound
import kotlinx.android.synthetic.main.fragment_time_schedule.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList


class SearchActivity : BaseActivity(), FilterCategorySelectClick {
    companion object {
        val CATEGORYID = "categoryId"
    }

    lateinit var caregiverAdapter: CaregiverAdapter
    lateinit var filterAdapter: FilterAdapter
    lateinit var filterCategoryAdapter: FilterCategoryAdapter

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true
    var search = ""

    var caregiverList: ArrayList<FindCaregiverResponse.Data> = ArrayList()

    var categoryId = ""
    var selectedCategory: ArrayList<String> = ArrayList()
    var categoryDataList: ArrayList<CategoryData> = ArrayList()

    lateinit var txtNewest: TextView
    lateinit var txtOldest: TextView
    lateinit var txtOnline: TextView
    lateinit var txtTopRated: TextView
    lateinit var txtMale: TextView
    lateinit var txtFemale: TextView
    lateinit var txtOther: TextView
    lateinit var txtVaccineYes: TextView
    lateinit var txtVaccineNo: TextView
    lateinit var txtToday: TextView
    lateinit var txtTomorrow: TextView
    lateinit var ageSeekBar: DoubleValueSeekBarView
    lateinit var distanceSeek: DoubleValueSeekBarView
    lateinit var etCustomDate: EditText


    var isFirst = ""
    var isOnline = ""
    var topRated = ""
    var gender = ""
    var ageMin = ""
    var ageMax = ""
    var distanceMin = ""
    var distanceMax = ""
    var isVaccinated = ""
    var isRecurring = ""
    var answer = ""
    var customDate = ""
    var availibility = ""

    var datepicker: DatePickerDialog? = null

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

        val layoutManager = FlexboxLayoutManager(activity)
        filterAdapter = FilterAdapter(activity)
        recyclerFilter.layoutManager = layoutManager
        recyclerFilter.adapter = filterAdapter


        caregiverAdapter = CaregiverAdapter(activity, "search")
        recyclerResult.layoutManager = LinearLayoutManager(activity)
        recyclerResult.isNestedScrollingEnabled = false
        recyclerResult.adapter = caregiverAdapter

        getCategoryList()

        etSearch.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable) {
                if (TextUtils.isEmpty(s.toString().trim { it <= ' ' })) {
                    caregiverList.clear()
                    search = ""
                    findCaregiversApi(search)
                }
            }
        })

        etSearch.setOnEditorActionListener(TextView.OnEditorActionListener { v, i, event ->
            if (i == EditorInfo.IME_ACTION_SEARCH) {
                caregiverList.clear()
                search = etSearch.text.toString().trim { it <= ' ' }
                findCaregiversApi(search)
                utils.hideKeyBoardFromView(activity)
                return@OnEditorActionListener true
            }
            false
        })


        nestedScroll.viewTreeObserver
            .addOnScrollChangedListener {
                val view = nestedScroll.getChildAt(nestedScroll.childCount - 1) as View
                val diff: Int = view.bottom - (nestedScroll.height + nestedScroll
                    .scrollY)
                if (diff == 0 && pageNum != totalPage!!.toInt()) {
                    pageNum++
                    isClearList = false
                    findCaregiversApi(search)
                }
            }

    }

    override fun onResume() {
        super.onResume()
        pageNum = 1
        isClearList = true
        findCaregiversApi(search)
    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.filterImg -> filterPopUp()
            R.id.txtCancel -> onBackPressed()
        }
    }

    private fun findCaregiversApi(search: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = FindCaregiverRequest(
                FindCaregiverRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    selectedCategory,
                    pageNum,
                    "10",
                    search,
                    "",
                    "",
                    isFirst,
                    isOnline,
                    topRated,
                    gender,
                    ageMin,
                    ageMax,
                    distanceMin,
                    distanceMin,
                    isVaccinated,
                    availibility,
                    customDate
                )
            )

            val signUp: Call<FindCaregiverResponse?> =
                RetrofitClient.getClient.findCaregivers(langTokenRequest)
            signUp.enqueue(object : Callback<FindCaregiverResponse?> {
                override fun onResponse(
                    call: Call<FindCaregiverResponse?>,
                    response: Response<FindCaregiverResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: FindCaregiverResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                try {
                                    txtDataNotFound.visibility = View.GONE
                                    recyclerResult.visibility = View.VISIBLE
                                } catch (e: Exception) {
                                }

                                if (isClearList) {
                                    caregiverList.clear()

                                }
                                totalPage = response.totalPages

                                caregiverList.addAll(response.data)
                                caregiverAdapter.setAdapterList(caregiverList)
                                caregiverAdapter.notifyDataSetChanged()

                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                                try {
                                    txtDataNotFound.text = response.message
                                    txtDataNotFound.visibility = View.VISIBLE
                                    recyclerResult.visibility = View.GONE
                                } catch (e: Exception) {
                                }
                            }

                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<FindCaregiverResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun filterPopUp() {
//        pwindow = PopupWindow(layout, WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT, true)
        val view = layoutInflater.inflate(R.layout.filter_popup, null, false)
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

        txtNewest = view.findViewById(R.id.txtNewest)
        txtOldest = view.findViewById(R.id.txtOldest)
        txtTopRated = view.findViewById(R.id.txtTopRated)
        txtOnline = view.findViewById(R.id.txtOnline)
        txtMale = view.findViewById(R.id.txtMale)
        txtFemale = view.findViewById(R.id.txtFemale)
        txtOther = view.findViewById(R.id.txtOther)
        txtVaccineYes = view.findViewById(R.id.txtVaccineYes)
        txtVaccineNo = view.findViewById(R.id.txtVaccineNo)
        ageSeekBar = view.findViewById(R.id.ageSeekBar)
        distanceSeek = view.findViewById(R.id.distanceSeek)
        etCustomDate = view.findViewById(R.id.etCustomDate)
        txtToday = view.findViewById(R.id.txtToday)
        txtTomorrow = view.findViewById(R.id.txtTomorrow)


        filterCategoryAdapter = FilterCategoryAdapter(activity, selectedCategory, categoryDataList)
        recyclerCategory.layoutManager = GridLayoutManager(activity, 2)
        recyclerCategory.isNestedScrollingEnabled = false
        recyclerCategory.adapter = filterCategoryAdapter
        filterCategoryAdapter.filterCategorySelectClick(this)

        if (ageMin.isNotEmpty() || ageMax.isNotEmpty()) {
            ageSeekBar.currentMinValue = ageMin.toInt()
            ageSeekBar.currentMaxValue = ageMax.toInt()
        }

        if (distanceMin.isNotEmpty() || distanceMax.isNotEmpty()) {
            distanceSeek.currentMinValue = distanceMin.toInt()
            distanceSeek.currentMaxValue = distanceMax.toInt()
        }

        if (isFirst == "1") {
            setNewest(1)
        } else if (isFirst == "2") {
            setNewest(2)
        }

        if (availibility == "1") {
            setAvailable(1)
        } else if (availibility == "2") {
            setAvailable(2)
        }

        if (gender == "1") {
            setGender(1)
        } else if (gender == "2") {
            setGender(2)
        } else if (gender == "3") {
            setGender(3)
        }

        if (isVaccinated == "1") {
            setVaccinated(1)
        } else if (isVaccinated == "2") {
            setVaccinated(2)
        }

        val inputFormat: DateFormat = SimpleDateFormat("yyyy-MM-dd")
        val outputFormat: DateFormat = SimpleDateFormat("MM-dd-yyyy")

        if (customDate != "") {
            try {
                val date: Date = inputFormat.parse(customDate)
                val outputDateStr: String = outputFormat.format(date)
                etCustomDate.setText(outputDateStr)
            } catch (e: Exception) {
            }
        }

        if (isOnline == "1") {
            txtOnline.background = resources.getDrawable(R.drawable.select_bg);
            txtOnline.setTextColor(resources.getColor(R.color.txtOrange))
        } else {
            txtOnline.setTextColor(resources.getColor(R.color.txtLightPurple))
            txtOnline.background = resources.getDrawable(R.drawable.unselect_bg);
        }

        if (topRated == "1") {
            txtTopRated.background = resources.getDrawable(R.drawable.select_bg);
            txtTopRated.setTextColor(resources.getColor(R.color.txtOrange))
        } else {
            txtTopRated.setTextColor(resources.getColor(R.color.txtLightPurple))
            txtTopRated.background = resources.getDrawable(R.drawable.unselect_bg);
        }

        etCustomDate.setOnClickListener { selectDate() }

        txtNewest.setOnClickListener { setNewest(1) }
        txtOldest.setOnClickListener { setNewest(2) }
        txtToday.setOnClickListener { setAvailable(1) }
        txtTomorrow.setOnClickListener { setAvailable(2) }

        txtOnline.setOnClickListener {
            if (isOnline == "1") {
                txtOnline.setTextColor(resources.getColor(R.color.txtLightPurple))
                txtOnline.background = resources.getDrawable(R.drawable.unselect_bg);
                isOnline = ""
            } else {
                txtOnline.background = resources.getDrawable(R.drawable.select_bg);
                txtOnline.setTextColor(resources.getColor(R.color.txtOrange))
                isOnline = "1"
            }
        }

        txtTopRated.setOnClickListener {
            if (topRated == "1") {
                txtTopRated.setTextColor(resources.getColor(R.color.txtLightPurple))
                txtTopRated.background = resources.getDrawable(R.drawable.unselect_bg);
                topRated = ""
            } else {
                txtTopRated.background = resources.getDrawable(R.drawable.select_bg);
                txtTopRated.setTextColor(resources.getColor(R.color.txtOrange))
                topRated = "1"
            }
        }

        txtMale.setOnClickListener { setGender(1) }
        txtFemale.setOnClickListener { setGender(2) }
        txtOther.setOnClickListener { setGender(3) }
        txtVaccineYes.setOnClickListener { setVaccinated(1) }
        txtVaccineNo.setOnClickListener { setVaccinated(2) }

        txtApplyFilter.setOnClickListener {
            ageMin = ageSeekBar.currentMinValue.toString()
            ageMax = ageSeekBar.currentMaxValue.toString()

            if (ageMin == "20" && ageMax == "35") {
                ageMin = ""
                ageMax = ""
            }

            distanceMin = distanceSeek.currentMinValue.toString()
            distanceMax = distanceSeek.currentMaxValue.toString()

            if (distanceMin == "1" && distanceMax == "10") {
                distanceMin = ""
                distanceMax = ""
            }

            findCaregiversApi("")
            popupWindow.dismiss()
        }

        txtReset.setOnClickListener { resetFilter() }

        txtCancel.setOnClickListener { popupWindow.dismiss() }
    }

    private fun selectDate() {
        val year: Int
        val month: Int
        val dayOfMonth: Int
        val calendar: Calendar = Calendar.getInstance()
        year = calendar[Calendar.YEAR]
        month = calendar[Calendar.MONTH]
        dayOfMonth = calendar[Calendar.DAY_OF_MONTH]

        datepicker = DatePickerDialog(
            activity,
            { view, year, monthOfYear, dayOfMonth ->
                var monthOfYear = monthOfYear
                var strMonth = ""
                var strDay = ""
                monthOfYear = monthOfYear + 1
                strDay = if (dayOfMonth < 10) {
                    "0$dayOfMonth"
                } else {
                    "" + dayOfMonth
                }
                strMonth = if (monthOfYear < 10) {
                    "0$monthOfYear"
                } else {
                    "" + monthOfYear
                }

                customDate = "$year-$strMonth-$strDay"

                etCustomDate.setText("$strMonth-$strDay-$year")
            }, year, month, dayOfMonth
        )
//        datepicker!!.datePicker.minDate = calendar.timeInMillis
        datepicker!!.show()
    }

    private fun resetFilter() {
        txtNewest.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtNewest.background = resources.getDrawable(R.drawable.unselect_bg)
        txtOldest.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtOldest.background = resources.getDrawable(R.drawable.unselect_bg)
        txtTopRated.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtTopRated.background = resources.getDrawable(R.drawable.unselect_bg)
        txtOnline.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtOnline.background = resources.getDrawable(R.drawable.unselect_bg)
        txtMale.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtMale.background = resources.getDrawable(R.drawable.unselect_bg)
        txtFemale.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtFemale.background = resources.getDrawable(R.drawable.unselect_bg)
        txtOther.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtOther.background = resources.getDrawable(R.drawable.unselect_bg)
        txtVaccineYes.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtVaccineYes.background = resources.getDrawable(R.drawable.unselect_bg)
        txtVaccineNo.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtVaccineNo.background = resources.getDrawable(R.drawable.unselect_bg)
        txtToday.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtToday.background = resources.getDrawable(R.drawable.unselect_bg)
        txtTomorrow.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtTomorrow.background = resources.getDrawable(R.drawable.unselect_bg)

        ageSeekBar.currentMinValue = 20
        ageSeekBar.currentMaxValue = 35

        distanceSeek.currentMinValue = 1
        distanceSeek.currentMaxValue = 10

        etCustomDate.setText("")
        
        answer = ""
        isFirst = ""
        isOnline = ""
        topRated = ""
        gender = ""
        ageMin = ""
        ageMax = ""
        distanceMin = ""
        distanceMax = ""
        isVaccinated = ""
        isRecurring = ""
        customDate = ""
        availibility = ""
        selectedCategory.clear()
        filterCategoryAdapter.notifyDataSetChanged()
    }

    private fun getCategoryList() {
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

    private fun setAvailable(pos: Int) {
        txtToday.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtToday.background = resources.getDrawable(R.drawable.unselect_bg);
        txtTomorrow.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtTomorrow.background = resources.getDrawable(R.drawable.unselect_bg);

        if (pos == 1) {
            txtToday.background = resources.getDrawable(R.drawable.select_bg);
            txtToday.setTextColor(resources.getColor(R.color.txtOrange))
            availibility = "1"
        } else {
            txtTomorrow.background = resources.getDrawable(R.drawable.select_bg);
            txtTomorrow.setTextColor(resources.getColor(R.color.txtOrange))
            availibility = "2"
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

    private fun setGender(pos: Int) {
        txtMale.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtMale.background = resources.getDrawable(R.drawable.unselect_bg);
        txtFemale.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtFemale.background = resources.getDrawable(R.drawable.unselect_bg);
        txtOther.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtOther.background = resources.getDrawable(R.drawable.unselect_bg);
        if (pos == 1) {
            txtMale.background = resources.getDrawable(R.drawable.select_bg);
            txtMale.setTextColor(resources.getColor(R.color.txtOrange))
            gender = "1"
        } else if (pos == 2) {
            txtFemale.setTextColor(resources.getColor(R.color.txtOrange))
            txtFemale.background = resources.getDrawable(R.drawable.select_bg);
            gender = "2"
        } else {
            txtOther.setTextColor(resources.getColor(R.color.txtOrange))
            txtOther.background = resources.getDrawable(R.drawable.select_bg);
            gender = "3"
        }
    }

    private fun setVaccinated(pos: Int) {
        txtVaccineYes.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtVaccineYes.background = resources.getDrawable(R.drawable.unselect_bg);
        txtVaccineNo.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtVaccineNo.background = resources.getDrawable(R.drawable.unselect_bg);
        if (pos == 1) {
            txtVaccineYes.background = resources.getDrawable(R.drawable.select_bg);
            txtVaccineYes.setTextColor(resources.getColor(R.color.txtOrange))
            isVaccinated = "1"
        } else {
            txtVaccineNo.setTextColor(resources.getColor(R.color.txtOrange))
            txtVaccineNo.background = resources.getDrawable(R.drawable.select_bg);
            isVaccinated = "2"
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

}