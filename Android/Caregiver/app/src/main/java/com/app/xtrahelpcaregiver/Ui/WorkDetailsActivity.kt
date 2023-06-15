package com.app.xtrahelpcaregiver.Ui

import android.app.DatePickerDialog
import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.*
import com.app.xtrahelpcaregiver.Interface.DisabilitiesClickListener
import com.app.xtrahelpcaregiver.Interface.RemoveClick
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.*
import com.app.xtrahelpcaregiver.Request.CommonData
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.google.android.flexbox.FlexboxLayoutManager
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.whiteelephant.monthpicker.MonthPickerDialog
import com.whiteelephant.monthpicker.MonthPickerDialog.OnYearChangedListener
import kotlinx.android.synthetic.main.activity_category_list.*
import kotlinx.android.synthetic.main.activity_work_details.*
import kotlinx.android.synthetic.main.activity_work_details.arrowBack
import kotlinx.android.synthetic.main.activity_work_details.relative
import kotlinx.android.synthetic.main.activity_work_details.txtNext
import kotlinx.android.synthetic.main.adapter_certification.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.lang.Exception
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

class WorkDetailsActivity : BaseActivity(), RemoveClick, DisabilitiesClickListener {

    lateinit var selectedCategoryAdapter: SelectedCategoryAdapter
    lateinit var categoryDataList: ArrayList<CategoryData>
    lateinit var dialog: BottomSheetDialog
    lateinit var workSpecialityList: ArrayList<WorkSpeciality>
    lateinit var specialityAdapter: SpecialityAdapter

    lateinit var transporationMethodAdapter: TransporationMethodAdapter
    lateinit var workMethodOfTransportationList: ArrayList<WorkMethodOfTransportation>

    lateinit var workDisabilitiesWillingType: ArrayList<WorkDisabilitiesWillingType>
    lateinit var disabilitiesAdapter: DisabilitiesAdapter

    var specialityId: String = ""
    var transportationId: String = ""
    var disabilitiesId: String = ""
    var experience: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var selectedMonth1 = 0;
    var selectedYear1 = 0;

    private lateinit var today: Calendar
    var month = ""

    lateinit var experienceYearList: ArrayList<String>
    lateinit var experienceAdapter: ExperienceAdapter
    lateinit var etWorkPlace: EditText
    lateinit var etReason: EditText
    lateinit var etDesc: EditText
    lateinit var txtStartDate: TextView
    lateinit var txtEndDate: TextView

    lateinit var workExperienceList: ArrayList<WorkExperience>
    lateinit var workExperienceAdapter: WorkExperienceAdapter

    var datepicker: DatePickerDialog? = null
    var inputFormat: DateFormat = SimpleDateFormat("yyyy-MM-dd")
    var outputFormat: DateFormat = SimpleDateFormat("MM-dd-yyyy")

    var selectedDisabilities: ArrayList<String> = ArrayList()

    lateinit var disabilitiesSelectAdapter: DisabilitiesSelectAdapter

    companion object {
        val FROMEDIT = "fromEdit"
    }

    var fromEdit = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_work_details)
        fromEdit = intent.getBooleanExtra(EditProfileActivity.FROMEDIT, false)
        selectDefaultValue()
        init()
    }


    private fun init() {
        if (fromEdit) {
            txtSave.visibility = View.VISIBLE
            txtNext.text = resources.getString(R.string.save_next)
        } else {
            txtSave.visibility = View.GONE
            txtNext.text = "Next"
        }

        txtNext.setOnClickListener(this)
        txtSelectCategory.setOnClickListener(this)
        arrowBack.setOnClickListener(this)
        txtAdd.setOnClickListener(this)
        txtSpeciality.setOnClickListener(this)
        txtTransportationMethod.setOnClickListener(this)
        txtDisabilities.setOnClickListener(this)
        txtSave.setOnClickListener(this)
        txtExperience.setOnClickListener(this)

        experienceYearList = ArrayList()

        for (i in 0..24) {
            experienceYearList.add((i + 1).toString())
        }

        experienceYearList.add("25+")
        
        workSpecialityList = ArrayList()
        workMethodOfTransportationList = ArrayList()
        workDisabilitiesWillingType = ArrayList()
        workExperienceList = ArrayList()

        workExperienceAdapter = WorkExperienceAdapter(activity, workExperienceList)
        recyclerExperience.layoutManager = LinearLayoutManager(activity)
        recyclerExperience.isNestedScrollingEnabled = false
        recyclerExperience.adapter = workExperienceAdapter
        workExperienceAdapter.onRemoveClick(this)

        disabilitiesSelectAdapter =
            DisabilitiesSelectAdapter(activity, workDisabilitiesWillingType, selectedDisabilities)
//        recyclerDisabilities.layoutManager = LinearLayoutManager(activity)
//        recyclerDisabilities.isNestedScrollingEnabled = false
//        recyclerDisabilities.adapter = disabilitiesSelectAdapter

        val layoutManager = FlexboxLayoutManager(activity)
        recyclerDisabilities.layoutManager = layoutManager
        recyclerDisabilities.adapter = disabilitiesSelectAdapter
        disabilitiesSelectAdapter.removeClick(this)

        getCommonDataApi()
    }

    override fun onResume() {
        super.onResume()
        categoryDataList = ArrayList()
        selectedCategoryAdapter = SelectedCategoryAdapter(activity, categoryDataList)

        getCategoryApi()

    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtSave -> if (isValid()) {
                saveWorkDetailsApi(true)
            }
            R.id.txtNext -> {
                if (isValid()) {
                    saveWorkDetailsApi(false)
                }
//                startActivity(Intent(activity, InsuranceActivity::class.java))
//                finish()
            }
            R.id.txtSelectCategory -> startActivity(
                Intent(
                    activity,
                    CategoryListActivity::class.java
                )
            )
            R.id.txtAdd -> showAddWorkDialog()
            R.id.txtSpeciality -> showSelectSpecialityDialog()
            R.id.txtTransportationMethod -> showSelectTransportationDialog()
            R.id.txtDisabilities -> showSelectDisabilitiesDialog()
            R.id.txtExperience -> showSelectExperienceDialog()
        }
    }

    override fun onBackPressed() {
        super.onBackPressed()
        if (!fromEdit) {
            startActivity(
                Intent(activity, YourAddressActivity::class.java)
                    .putExtra(YourAddressActivity.FROMEDIT, fromEdit)
            )
        }
        finish()
    }

    private fun showAddWorkDialog() {
        val dialogView = layoutInflater.inflate(R.layout.add_work_expirance_popup, null)
        val dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtAddExperience = dialog.findViewById<TextView>(R.id.txtAddExperience)

        etWorkPlace = dialog.findViewById(R.id.etWorkPlace)!!
        etReason = dialog.findViewById(R.id.etReason)!!
        etDesc = dialog.findViewById(R.id.etDesc)!!
        txtStartDate = dialog.findViewById(R.id.txtStartDate)!!
        txtEndDate = dialog.findViewById(R.id.txtEndDate)!!

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        txtStartDate.setOnClickListener {
//            selectIssueDate()
            selectStartDatePicker()
        }

        txtEndDate.setOnClickListener {
//            selectExpireDate()
            selectEndDatePicker()
        }

        txtAddExperience?.setOnClickListener {
            if (isValidPopup()) {
                var workExperience = WorkExperience(
                    etWorkPlace.text.toString(),
                    startDate,
                    endDate,
                    etReason.text.toString(),
                    etDesc.text.toString()
                )
                workExperienceList.add(workExperience)
                workExperienceAdapter.notifyDataSetChanged()
                dialog.dismiss()
            }
        }

        dialog.show()
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
                                selectedCategoryAdapter.notifyDataSetChanged()

                                val layoutManager = FlexboxLayoutManager(activity)
                                recyclerSelectedCategory.layoutManager = layoutManager
                                recyclerSelectedCategory.adapter = selectedCategoryAdapter
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

                                workMethodOfTransportationList.clear()
                                workMethodOfTransportationList.addAll(commonDataResponse.data.workMethodOfTransportation)

                                workDisabilitiesWillingType.clear()
                                workDisabilitiesWillingType.addAll(commonDataResponse.data.workDisabilitiesWillingType)

                                getWorkDetailApi()

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

    private fun getWorkDetailApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<GetWorkDetailsResponse?> =
                RetrofitClient.getClient.getWorkDetails(langTokenRequest)
            signUp.enqueue(object : Callback<GetWorkDetailsResponse?> {
                override fun onResponse(
                    call: Call<GetWorkDetailsResponse?>, response: Response<GetWorkDetailsResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: GetWorkDetailsResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                Const.selectedCategory.clear()
                                for (i in response.data.categoryData.indices) {
                                    val data: CategoryDatas = response.data.categoryData[i]
                                    Const.selectedCategory.add(data.jobCategoryId)
                                }

                                selectedCategoryAdapter.notifyDataSetChanged()

                                for (i in response.data.workExperienceData.indices) {
                                    val data: WorkExperienceData =
                                        response.data.workExperienceData[i]
                                    val workExperience = WorkExperience(
                                        data.workPlace,
                                        data.startDate,
                                        data.endDate,
                                        data.leavingReason,
                                        data.description
                                    )
                                    workExperienceList.add(workExperience)
                                }
                                workExperienceAdapter.notifyDataSetChanged()


                                specialityId = response.data.workSpecialityId
                                txtSpeciality.text = response.data.workSpecialityName

                                transportationId = response.data.workMethodOfTransportationId
                                txtTransportationMethod.text =
                                    response.data.workMethodOfTransportationName

                                for (i in response.data.workDisabilitiesWillingTypeData.indices) {
                                    selectedDisabilities.add(response.data.workDisabilitiesWillingTypeData[i].workDisabilitiesWillingTypeId)
                                }
                                disabilitiesSelectAdapter.notifyDataSetChanged()
//                                disabilitiesId = response.data.workDisabilitiesWillingTypeId
//                                txtDisabilities.text = response.data.workDisabilitiesWillingTypeName

                                experience = response.data.experienceOfYear

                                makingDistance.progress = response.data.maxDistanceTravel.toInt()
                                txtExperience.text = response.data.experienceOfYear
                                etInspired.setText(response.data.inspiredYouBecome)
                                etBio.setText(response.data.bio)


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

                override fun onFailure(call: Call<GetWorkDetailsResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun saveWorkDetailsApi(fromSave: Boolean) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            var profileStatus = ""
            if (!fromEdit) {
                profileStatus = "5"
            }
            val saveWorkDetailRequest = SaveWorkDetailsRequest(
                SaveWorkDetail(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    Const.selectedCategory,
                    specialityId,
                    makingDistance.progress.toString(),
                    transportationId,
                    selectedDisabilities,
                    experience,
                    etInspired.text.toString(),
                    etBio.text.toString(),
                    profileStatus,
                    workExperienceList
                )
            )

            val signUp: Call<LoginResponse?> =
                RetrofitClient.getClient.saveWorkDetails(saveWorkDetailRequest)
            signUp.enqueue(object : Callback<LoginResponse?> {
                override fun onResponse(
                    call: Call<LoginResponse?>, response: Response<LoginResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: LoginResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                Const.selectedCategory.clear()
                                pref.setString(
                                    Const.profileStatus,
                                    loginResponse.data.profileStatus
                                )
                                if (fromEdit) {
                                    if (fromSave) {
                                        finish()
                                    } else {
                                        startActivity(
                                            Intent(activity, InsuranceActivity::class.java)
                                                .putExtra(InsuranceActivity.FROMEDIT, true)
                                        )
                                        finish()
                                    }
                                } else {
                                    loginActivity()
                                }
                            }
                            "6" -> {
                                utils.showCustomToast(loginResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    loginResponse.status,
                                    loginResponse.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<LoginResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun showSelectSpecialityDialog() {
        val layoutInflater = LayoutInflater.from(activity)
        val dialogView = layoutInflater.inflate(R.layout.common_popup, null)

        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtTitlePopup = dialog.findViewById<TextView>(R.id.txtTitlePopup)

        txtTitlePopup?.text = "Select Speciality"

        val recyclerView: RecyclerView = dialog.findViewById(R.id.recyclerView)!!
        val txtDataNotFoundPopup: TextView = dialog.findViewById(R.id.txtDataNotFoundPopup)!!
        recyclerView.layoutManager = LinearLayoutManager(activity)

        specialityAdapter = SpecialityAdapter(activity, workSpecialityList, object :
            SpecialityAdapter.CallbackListen {
            override fun clickItem(id: String) {
                for (i in workSpecialityList.indices) {
                    if (workSpecialityList[i].workSpecialityId == id) {
                        specialityId = id
                        txtSpeciality.text = workSpecialityList[i].name
                        dialog.dismiss()
                    }
                }
            }
        })
        recyclerView.adapter = specialityAdapter
        specialityAdapter.notifyDataSetChanged()

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        dialog.show()
    }

    private fun showSelectTransportationDialog() {
        val layoutInflater = LayoutInflater.from(activity)
        val dialogView = layoutInflater.inflate(R.layout.common_popup, null)

        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtTitlePopup = dialog.findViewById<TextView>(R.id.txtTitlePopup)

        txtTitlePopup?.text = "Select Method of Transportation"

        val recyclerView: RecyclerView = dialog.findViewById(R.id.recyclerView)!!
        val txtDataNotFoundPopup: TextView = dialog.findViewById(R.id.txtDataNotFoundPopup)!!
        recyclerView.layoutManager = LinearLayoutManager(activity)

        transporationMethodAdapter =
            TransporationMethodAdapter(activity, workMethodOfTransportationList, object :
                TransporationMethodAdapter.CallbackListen {
                override fun clickItem(id: String) {
                    for (i in workMethodOfTransportationList.indices) {
                        if (workMethodOfTransportationList[i].workMethodOfTransportationId == id) {
                            transportationId = id
                            txtTransportationMethod.text = workMethodOfTransportationList[i].name
                            dialog.dismiss()
                        }
                    }
                }
            })
        recyclerView.adapter = transporationMethodAdapter
        transporationMethodAdapter.notifyDataSetChanged()

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        dialog.show()
    }

    private fun showSelectDisabilitiesDialog() {
        val layoutInflater = LayoutInflater.from(activity)
        val dialogView = layoutInflater.inflate(R.layout.disability_popup, null)

        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtTitlePopup = dialog.findViewById<TextView>(R.id.txtTitlePopup)
        val txtSelect = dialog.findViewById<TextView>(R.id.txtSelect)

        txtTitlePopup?.text = "Select Type of Disabilities"

        val recyclerView: RecyclerView = dialog.findViewById(R.id.recyclerView)!!
        val txtDataNotFoundPopup: TextView = dialog.findViewById(R.id.txtDataNotFoundPopup)!!
        recyclerView.layoutManager = LinearLayoutManager(activity)

        disabilitiesAdapter = DisabilitiesAdapter(
            activity,
            workDisabilitiesWillingType,
            selectedDisabilities,
            object :
                DisabilitiesAdapter.CallbackListen {
                override fun clickItem(id: String) {
                    for (i in workDisabilitiesWillingType.indices) {
                        if (workDisabilitiesWillingType[i].workDisabilitiesWillingTypeId == id) {
                            disabilitiesId = id
                            txtDisabilities.text = workDisabilitiesWillingType[i].name
                            dialog.dismiss()
                        }
                    }
                }
            })

        disabilitiesAdapter.disabilitiesClickListener(this)
        recyclerView.adapter = disabilitiesAdapter
        disabilitiesAdapter.notifyDataSetChanged()

        txtSelect?.setOnClickListener {
            disabilitiesAdapter.notifyDataSetChanged()
            disabilitiesSelectAdapter.notifyDataSetChanged()
            Log.e("asdlhddsad", "showSelectDisabilitiesDialog: $selectedDisabilities")
            dialog.dismiss()
        }
        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        dialog.show()
    }

    private fun showSelectExperienceDialog() {
        val layoutInflater = LayoutInflater.from(activity)
        val dialogView = layoutInflater.inflate(R.layout.common_popup, null)

        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtTitlePopup = dialog.findViewById<TextView>(R.id.txtTitlePopup)

        txtTitlePopup?.text = "How many years of experience"

        val recyclerView: RecyclerView = dialog.findViewById(R.id.recyclerView)!!
        val txtDataNotFoundPopup: TextView = dialog.findViewById(R.id.txtDataNotFoundPopup)!!
        recyclerView.layoutManager = LinearLayoutManager(activity)

        experienceAdapter = ExperienceAdapter(activity, experienceYearList, object :
            ExperienceAdapter.CallbackListen {
            override fun clickItem(id: String) {
                txtExperience.text = id
                experience = id
                dialog.dismiss()
            }
        })
        recyclerView.adapter = experienceAdapter
        experienceAdapter.notifyDataSetChanged()

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        dialog.show()
    }

    private fun selectStartDatePicker() {
        month = ""
        val builder: MonthPickerDialog.Builder? =
            today?.let {
                today?.get(Calendar.MONTH)?.let { it1 ->
                    MonthPickerDialog.Builder(activity, { selectedMonths, selectedYear ->
                        selectedMonth1 = selectedMonths
                        selectedYear1 = selectedYear
                        var selectMonth = selectedMonths
                        selectMonth += 1
                        Log.d("TAG", "selectedMonth : $selectMonth selectedYear : $selectedYear")
                        month = if (selectMonth < 9) {
                            "0$selectMonth"
                        } else {
                            java.lang.String.valueOf(selectMonth)
                        }
                        startDate = "$month/$selectedYear"
                        txtStartDate.text = "$month/$selectedYear"
                    }, it.get(Calendar.YEAR), it1)
                }
            }
        today?.get(Calendar.MONTH)?.let {
            builder?.setActivatedMonth(it)?.setMinYear(1980)
                ?.setActivatedYear(today?.get(Calendar.YEAR)!!)
                ?.setMaxYear(today?.get(Calendar.YEAR)!!)?.setMinMonth(Calendar.JANUARY)
                ?.setTitle("Select Start Date")
                ?.setMonthRange(Calendar.JANUARY, Calendar.DECEMBER)
                ?.setOnMonthChangedListener { selectedMonth ->
                    Log.d(
                        "TAG",
                        "Selected month : $selectedMonth"
                    )
                }?.setOnYearChangedListener { selectedYear ->
                    Log.d(
                        "TAG",
                        "Selected year : $selectedYear"
                    )
                }?.build()?.show()
        }
    }

    private fun selectIssueDate() {
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

                startDate = "$year-$strMonth-$strDay"
                txtStartDate.text = "$strMonth-$strDay-$year"

            }, year, month, dayOfMonth
        )
        datepicker!!.show()
    }

    private fun selectEndDatePicker() {
        month = ""
        val builder1 = MonthPickerDialog.Builder(
            activity,
            { selectedMonth: Int, selectedYear: Int ->
                month = if (selectedMonth < 9) {
                    "0$selectedMonth"
                } else {
                    selectedMonth.toString()
                }
                endDate = "$month/$selectedYear"
                txtEndDate.text = "$month/$selectedYear"
                Log.d(
                    "TAG",
                    "selectedMonth : $selectedMonth selectedYear : $selectedYear"
                )
            }, today!![Calendar.YEAR], today!![Calendar.MONTH]
        )
        builder1.setActivatedMonth(today!![Calendar.MONTH])
            .setMinYear(selectedYear1)
            .setActivatedYear(selectedYear1)
            .setMaxYear(today!![Calendar.YEAR])
            .setMinMonth(Calendar.JANUARY)
            .setTitle("Select End Date")
            .setMonthRange(Calendar.JANUARY, Calendar.DECEMBER) // .setMaxMonth(Calendar.OCTOBER)
            .setOnMonthChangedListener { selectedMonth: Int ->
                Log.d(
                    "TAG",
                    "Selected month : $selectedMonth"
                )
            }
            .setOnYearChangedListener { selectedYear: Int ->
                Log.d(
                    "TAG",
                    "Selected year : $selectedYear"
                )
            }
            .build()
            .show()
    }

    private fun selectDefaultValue() {
        today = Calendar.getInstance()
        selectedMonth1 = today.get(Calendar.MONTH)
        selectedYear1 = today.get(Calendar.YEAR)
    }

    private fun selectExpireDate() {
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

                val tempEndDate = "$year-$strMonth-$strDay"
                isDateAfter(startDate, tempEndDate)

            }, year, month, dayOfMonth
        )
        datepicker!!.datePicker.maxDate = calendar.timeInMillis
        datepicker!!.show()
    }

    private fun isDateAfter(startDate: String, endDate: String): Boolean {
        return try {
            //            String myFormatString = "yyyy-MM-dd"; // for example
            val myFormatString = "yyyy-MM-dd" // for example
            val df = SimpleDateFormat(myFormatString)
            val date1 = df.parse(endDate)
            val startingDate = df.parse(startDate)
            if (date1.after(startingDate)) {
                this.endDate = endDate
                val date: Date = inputFormat.parse(this.endDate)
                val outputDateStr: String = outputFormat.format(date)
                txtEndDate.text = outputDateStr
                true
            } else {
                utils.showCustomToast("Please select Valid Date")
                false
            }
        } catch (e: Exception) {
            false
        }
    }

    private fun isValidPopup(): Boolean {
        var message: String
        message = ""

        when {
            etWorkPlace.text.toString() == "" -> {
                message = getString(R.string.enterWorkPlace)
                etWorkPlace.requestFocus()
            }
            startDate == "" -> {
                message = getString(R.string.selectStartDate)
            }
            endDate == "" -> {
                message = getString(R.string.selectEndDate)
            }
            etReason.text.toString() == "" -> {
                message = getString(R.string.enterReason)
                etReason.requestFocus()
            }
            etDesc.text.toString() == "" -> {
                message = getString(R.string.enterDesc)
                etDesc.requestFocus()
            }
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showCustomToast(message)
//            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }

    private fun isValid(): Boolean {
        var message: String
        message = ""
        val distance: Int = makingDistance.progress

        when {
            Const.selectedCategory.isEmpty() -> {
                message = getString(R.string.selectCategory)
            }
            specialityId.isEmpty() -> {
                message = getString(R.string.selectSpeciality)
            }
            distance <= 0 -> {
                message = getString(R.string.selectDistance)
            }
            transportationId.isEmpty() -> {
                message = getString(R.string.selectTransportMethod)
            }
            selectedDisabilities.isEmpty() -> {
                message = getString(R.string.selectDisability)
            }
            experience.isEmpty() -> {
                message = getString(R.string.selectExperience)
            }

            etInspired.text.isEmpty() -> {
                message = getString(R.string.enterInspire)
                etInspired.requestFocus()
            }
            etBio.text.isEmpty() -> {
                message = getString(R.string.enterBio)
                etBio.requestFocus()
            }

        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }

    override fun onRemoveClick(pos: Int) {
        MaterialAlertDialogBuilder(this)
            .setCancelable(false)
            .setMessage("Are you sure want to remove this Work Experience?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int ->
                workExperienceList.removeAt(pos)
                workExperienceAdapter.notifyDataSetChanged()
            }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()


    }

    override fun onRemoveDisabilityClick(id: String) {
        selectedDisabilities.remove(id)
        disabilitiesSelectAdapter.notifyDataSetChanged()
    }

    override fun onDisabilityClick(id: String, isAdd: Boolean) {
        if (isAdd) {
            selectedDisabilities.add(id)
        } else {
            selectedDisabilities.remove(id)
        }
    }


}