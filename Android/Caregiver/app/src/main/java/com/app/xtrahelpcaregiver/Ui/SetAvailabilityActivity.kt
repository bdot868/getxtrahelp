package com.app.xtrahelpcaregiver.Ui


import android.app.TimePickerDialog
import android.content.DialogInterface
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.TimePicker
import androidx.annotation.RequiresApi
import androidx.appcompat.widget.AppCompatCheckBox
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Adapter.AvailabilityAdapter
import com.app.xtrahelpcaregiver.Adapter.TimeOffAdapter
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.*
import com.app.xtrahelpcaregiver.Response.AvailabilityResponse
import com.app.xtrahelpcaregiver.Response.CaregiverCalendarAvailabilityNewResponse
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpcaregiver.decorators.HighlightWeekendsDecorator
import com.app.xtrahelpcaregiver.decorators.MySelectorDecorator
import com.app.xtrahelpcaregiver.decorators.OneDayDecorator
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.android.synthetic.main.activity_set_availability.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.text.DateFormatSymbols
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*

class SetAvailabilityActivity : BaseActivity() {

    lateinit var availabilityAdapter: AvailabilityAdapter
    lateinit var timeOffAdapter: TimeOffAdapter
    var availabilitySettingsList: ArrayList<Availability> = ArrayList()
    var timeOffList: ArrayList<OffDateTime> = ArrayList()

    var windowList: ArrayList<String> = ArrayList()
    var fromList = ArrayList<String>()
    var toList = ArrayList<String>()

    var monthsList: ArrayList<String> = ArrayList()
    var dayList: ArrayList<String> = ArrayList()

    companion object {
        val FROMEDIT = "fromEdit"
    }

    var fromEdit = false

    var picker: TimePickerDialog? = null
    var startTime = ""
    var endTime = ""

    val cldr = Calendar.getInstance()
    var hour = cldr[Calendar.HOUR_OF_DAY]
    var hour1 = cldr[Calendar.HOUR_OF_DAY]
    var minutes = cldr[Calendar.MINUTE]
    var minutes1 = cldr[Calendar.MINUTE]

    var selected = "1"
    var dateList: ArrayList<String> = ArrayList()

    var selectedDates: ArrayList<CaregiverCalendarAvailabilityNewResponse.Data> = ArrayList()

    private val oneDayDecorator: OneDayDecorator = OneDayDecorator()

    var isDateSelected = false

    var availabilityId = ""
    var selectedDay = ""
    var repeatType = "1"
    lateinit var currentCalendarDay: com.prolificinteractive.materialcalendarview.CalendarDay

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_set_availability)
        fromEdit = intent.getBooleanExtra(EditProfileActivity.FROMEDIT, false)
        setArray()
        init()
    }

    private fun setArray() {
        windowList = ArrayList()
        fromList = ArrayList()
        toList = ArrayList()
        availabilitySettingsList = ArrayList()

        windowList.add("Every Day")
        windowList.add("Mon-Sat")
        windowList.add("Monday")
        windowList.add("Tuesday")
        windowList.add("Wednesday")
        windowList.add("Thursday")
        windowList.add("Friday")
        windowList.add("Saturday")
        windowList.add("Sunday")

        val sdf = SimpleDateFormat("hh:mm a")

        //full Slot
//        for (i in 0..23) {
//            val calendar: Calendar = GregorianCalendar()
//            calendar[Calendar.HOUR_OF_DAY] = 1 //Added this line only
//            calendar.add(Calendar.HOUR_OF_DAY, i)
//            calendar[Calendar.MINUTE] = 0
//            calendar[Calendar.SECOND] = 0
//            val day1 = sdf.format(calendar.time)
//            calendar.add(Calendar.HOUR, 1)
////            fullSlot.add(i, day1)
//            fromList.add(i, day1)
//            toList.add(i, day1)
////            Log.e("Get Time Set", "Morning Full Slab: " + morningFullSlabList.get(i));
//        }

        var n = 0
        for (i in 0..47) {
            val calendar: Calendar = GregorianCalendar()
            calendar[Calendar.HOUR_OF_DAY] = 13 //Added this line only
            calendar.add(Calendar.HOUR_OF_DAY, n)
            if (i % 2 == 0) {
                // number is even
                calendar[Calendar.MINUTE] = 0
            } else {
                // number is odd
                calendar[Calendar.MINUTE] = 30
                n = n + 1
            }
            val day1 = sdf.format(calendar.time)
            calendar.add(Calendar.HOUR, 0)
            fromList.add(i, day1)
            toList.add(i, day1)
        }

        val months = DateFormatSymbols().months
        for (i in months.indices) {
            val month = months[i]
            val monthId = i + 1
            println("month = $month")
            monthsList.add(months[i])
            var monthString: String
            monthString = if (monthId < 10) {
                "0$monthId"
            } else {
                monthId.toString()
            }
//            monthsListId.add(monthString);
        }

        for (i in 1..31) {
            dayList.add(i.toString() + "")
        }
    }

    private fun init() {
        val year = Calendar.getInstance()[Calendar.YEAR]
        val month = Calendar.getInstance()[Calendar.MONTH]
        val day = Calendar.getInstance()[Calendar.DAY_OF_MONTH]

        currentCalendarDay = com.prolificinteractive.materialcalendarview.CalendarDay.from(
            org.threeten.bp.LocalDate.of(
                year,
                month + 1,
                day
            )
        )
        calendarView.state().edit()
            .setMinimumDate(
                com.prolificinteractive.materialcalendarview.CalendarDay.from(
                    year,
                    month + 1,
                    1
                )
            )
            .commit()

        if (fromEdit) {
            txtNext.text = "Save"
        } else {
            txtNext.text = "Next"
        }
        txtNext.setOnClickListener(this)
        arrowBack.setOnClickListener(this)
        txtAddAvailability.setOnClickListener(this)
        txtAddTimeOff.setOnClickListener(this)
        txtSkip.setOnClickListener(this)
        txtManual.setOnClickListener(this)
        txtCalendar.setOnClickListener(this)
        relativeStartTime.setOnClickListener(this)
        relativeEndTime.setOnClickListener(this)
        radioWeekly.setOnClickListener(this)
        radioEveryWeekly.setOnClickListener(this)
        removeImg.setOnClickListener(this)

        availabilityAdapter =
            AvailabilityAdapter(activity, availabilitySettingsList, windowList, fromList, toList)
        recyclerAvailability.layoutManager = LinearLayoutManager(activity)
        recyclerAvailability.isNestedScrollingEnabled = false
        recyclerAvailability.adapter = availabilityAdapter

        timeOffAdapter =
            TimeOffAdapter(activity, timeOffList, fromList, toList, monthsList, dayList)
        recyclerTimeOff.layoutManager = LinearLayoutManager(activity)
        recyclerTimeOff.isNestedScrollingEnabled = false
        recyclerTimeOff.adapter = timeOffAdapter

        calendarView.setOnDateChangedListener { widget, date, selected ->
            if (date.isBefore(currentCalendarDay)) {
                calendarView.setDateSelected(date, false)
                return@setOnDateChangedListener
            }

            var day: String = date.day.toString()
            var month: String = date.month.toString()
            var year: String = date.year.toString()

            if (day.length < 2) {
                day = "0$day"
            }
            if (month.length < 2) {
                month = "0$month"
            }
            val finalDate = "$year-$month-$day"
            Log.e("sdlnsd", "init: $finalDate")

            removeImg.visibility = View.GONE
            txtStartTime.text = ""
            txtEndTime.text = ""

            val inFormat = SimpleDateFormat("dd-MM-yyyy")
            val myDate: Date = inFormat.parse("$day-$month-$year")
            val simpleDateFormat = SimpleDateFormat("EEE")
            val dayName = simpleDateFormat.format(myDate)
            radioWeekly.text = "Weekly on $dayName"
            selectedDay = dayName
            startTime = ""
            endTime = ""
            radioWeekly.isChecked = true
            txtNext.text = "Save Availability"
            if (containsDates(selectedDates, finalDate)) {
                for (i in selectedDates.indices) {
                    if (finalDate == selectedDates[i].date) {
                        calendarView.clearSelection()
                        val dates1 = selectedDates[i].date
                        val datess = org.threeten.bp.LocalDate.parse(
                            dates1,
                            org.threeten.bp.format.DateTimeFormatter.ofPattern("yyyy-MM-dd")
                        )
                        val calendarDay =
                            com.prolificinteractive.materialcalendarview.CalendarDay.from(datess)
                        calendarView.setDateSelected(calendarDay, true)

                        removeImg.visibility = View.VISIBLE
                        txtStartTime.text = selectedDates[i].startTime
                        txtEndTime.text = selectedDates[i].endTime
                        txtNext.text = "Update Availability"
                        availabilityId = selectedDates[i].availabilityId
                        startTime = selectedDates[i].startTime
                        endTime = selectedDates[i].endTime
                        isDateSelected = true
                        break
                    }
                }
            } else {
                if (isDateSelected) {
                    calendarView.clearSelection()
                    val dates1 = finalDate
                    val datess = org.threeten.bp.LocalDate.parse(
                        dates1,
                        org.threeten.bp.format.DateTimeFormatter.ofPattern("yyyy-MM-dd")
                    )
                    val calendarDay =
                        com.prolificinteractive.materialcalendarview.CalendarDay.from(datess)
                    calendarView.setDateSelected(calendarDay, true)
                    isDateSelected = false
                }
            }
        }

        getAvailabilityNewApi()
    }

    private fun containsDates(
        list: ArrayList<CaregiverCalendarAvailabilityNewResponse.Data>,
        name: String?
    ): Boolean {
        for (item in list) {
            if (item.date == name) {
                return true
            }
        }
        return false
    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()

            R.id.txtNext -> {
                if (isValid()) {
                    saveCaregiverAvailability()
                }
//                saveAvailabilityApi()
            }
            R.id.removeImg -> removePopup()

            R.id.txtSkip -> {
//                availabilitySettingsList.clear()
//                timeOffList.clear()
//                updateProfile()
                if (fromEdit) {
                    finish()
                } else {
                    updateProfile()
                }
            }
            

            R.id.txtAddAvailability -> {
                setTxtAddAvailability()
                availabilityAdapter.notifyItemChanged(availabilitySettingsList.size - 1)
            }

            R.id.txtAddTimeOff -> {
                setTimeOffList()
                timeOffAdapter.notifyItemChanged(timeOffList.size - 1)
            }

            R.id.txtCalendar -> {
                calendarView.clearSelection()
                selectedDay = ""
                selected = "1"
                tabSelect(1)
                linearWeekly.visibility = View.GONE
            }

            R.id.txtManual -> {
                calendarView.clearSelection()
                selectedDay = ""
                tabSelect(2)
                selected = "2"
                linearWeekly.visibility = View.VISIBLE
            }

            R.id.radioWeekly -> {
                repeatType = "1"
            }

            R.id.radioEveryWeekly -> {
                repeatType = "2"
                calendarView.clearSelection()
            }

            R.id.relativeStartTime -> startDate()

            R.id.relativeEndTime -> {
                if (startTime == "") {
                    utils.showSnackBar(
                        relative,
                        activity,
                        "Please select start time",
                        Const.alert,
                        Const.successDuration
                    )
                } else {
                    endDate()
                }
            }

        }
    }

    private fun removePopup() {
        MaterialAlertDialogBuilder(activity)
            .setCancelable(false)
            .setMessage("Are you sure want to remove this availability?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int -> removeSingleAvailabilityApi() }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }


    private fun tabSelect(pos: Int) {
        txtCalendar.setTextColor(resources.getColor(R.color.gray))
        txtManual.setTextColor(resources.getColor(R.color.gray))
        relCalendar.setBackgroundResource(R.drawable.btnselectunselect)
        relManual.setBackgroundResource(R.drawable.btnselectunselect)

        if (pos == 1) {
            txtCalendar.setTextColor(resources.getColor(R.color.txtPurple))
            relCalendar.setBackgroundResource(R.drawable.btnselect)
            calendarView.selectionMode =
                com.prolificinteractive.materialcalendarview.MaterialCalendarView.SELECTION_MODE_MULTIPLE
        } else {
            txtManual.setTextColor(resources.getColor(R.color.txtPurple))
            relManual.setBackgroundResource(R.drawable.btnselect)
            calendarView.selectionMode =
                com.prolificinteractive.materialcalendarview.MaterialCalendarView.SELECTION_MODE_SINGLE
        }
    }

    fun startDate() {
        // time picker dialog
        picker = TimePickerDialog(
            activity,
            { tp: TimePicker?, sHour: Int, sMinute: Int ->
                hour = sHour
                minutes = sMinute
                val calendar = Calendar.getInstance()
                calendar[Calendar.HOUR_OF_DAY] = sHour
                calendar[Calendar.MINUTE] = sMinute
                val dateIn12Hour =
                    SimpleDateFormat("hh:mm a").format(calendar.timeInMillis)
                startTime = SimpleDateFormat("HH:mm").format(calendar.timeInMillis)
                Log.e("TAG", "onTimeSet: $startTime")
                txtStartTime.text = dateIn12Hour.toLowerCase()
                startTime = dateIn12Hour.toLowerCase()
            }, hour, minutes, false
        )
        picker!!.show()
    }

    private fun endDate() {
        picker = TimePickerDialog(
            activity,
            { tp: TimePicker?, sHour: Int, sMinute: Int ->
                hour1 = sHour
                minutes1 = sMinute
                val calendar = Calendar.getInstance()
                calendar[Calendar.HOUR_OF_DAY] = sHour
                calendar[Calendar.MINUTE] = sMinute
                val dateIn12Hour = SimpleDateFormat("hh:mm a").format(calendar.timeInMillis)
                var tempEndTime = SimpleDateFormat("HH:mm").format(calendar.timeInMillis)
                tempEndTime = dateIn12Hour.toLowerCase()
                Log.e("TAG", "onTimeSet123: $tempEndTime")

                val dateFormat = SimpleDateFormat("HH:mm")
                var date: Date? = null
                var date1: Date? = null
                try {
                    date = dateFormat.parse(startTime)
                    date1 = dateFormat.parse(tempEndTime)
                } catch (e: ParseException) {
                    e.printStackTrace()
                }

                if (date!!.after(date1) || date == date1) {
                    utils.showSnackBar(
                        relative,
                        activity,
                        "Current time is greater than finish time.",
                        Const.alert,
                        Const.successDuration
                    )
                } else {
                    endTime = SimpleDateFormat("HH:mm").format(calendar.timeInMillis)
                    txtEndTime.setText(dateIn12Hour.toLowerCase())
                    endTime = dateIn12Hour.toLowerCase()
                }
            }, hour1, minutes1, false
        )
        picker!!.show()
    }

    private fun setTxtAddAvailability() {
        val availabilitySetting = Availability("", "", "", "")
        availabilitySettingsList.add(availabilitySetting)
    }

    private fun setTimeOffList() {
        val timeOff = OffDateTime("", "", "", "")
        timeOffList.add(timeOff)
    }

    override fun onBackPressed() {
        super.onBackPressed()
        if (!fromEdit) {
            startActivity(
                Intent(activity, InsuranceActivity::class.java)
                    .putExtra(InsuranceActivity.FROMEDIT, fromEdit)
            )
        }
        finish()
    }

    private fun saveAvailabilityApi() {
        if (selected == "2") {
            if (radioWeekly.isChecked) {
                if (selectedDay == "Mon") {
                    repeatType = "1"
                } else if (selectedDay == "Tue") {
                    repeatType = "2"
                } else if (selectedDay == "Wed") {
                    repeatType = "3"
                } else if (selectedDay == "Thu") {
                    repeatType = "4"
                } else if (selectedDay == "Fri") {
                    repeatType = "5"
                } else if (selectedDay == "Sat") {
                    repeatType = "6"
                } else if (selectedDay == "Sun") {
                    repeatType = "7"
                }
            } else if (radioEveryWeekly.isChecked) {
                repeatType = "8"
            }
        }

        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val saveWorkDetailRequest =  SaveCaregiverAvailibility(
                SaveCaregiverAvailibility.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    selected,
                    dateList,
                    repeatType,
                    startTime,
                    endTime
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.saveCaregiverAvailability(saveWorkDetailRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>, response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                utils.customToast(activity, response.message)
                                selectedDay = ""
                                calendarView.clearSelection()

                                getAvailabilityNewApi()

                                txtStartTime.text = ""
                                txtEndTime.text = ""
                                removeImg.visibility = View.GONE
                                txtNext.text = "Save Availability"
                                startTime = ""
                                endTime = ""

                                if (fromEdit) {
                                    utils.customToast(activity, response.message)
                                    finish()
                                } else {
                                    updateProfile()
                                }
                            }
                            "6" -> {
                                utils.showCustomToast(response.message)
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

                override fun onFailure(call: Call<CommonResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun updateProfile() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)

            val updateProfileStatusRequest = UpdateProfileStatusRequest(
                UpdateProfileStatus(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    "7"
                )
            )

            val signUp: Call<LoginResponse?> =
                RetrofitClient.getClient.updateProfileStatus(updateProfileStatusRequest)
            signUp.enqueue(object : Callback<LoginResponse?> {
                override fun onResponse(
                    call: Call<LoginResponse?>, response: Response<LoginResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: LoginResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                pref.setString(
                                    Const.profileStatus,
                                    loginResponse.data.profileStatus
                                )

                                startActivity(
                                    Intent(
                                        activity,
                                        SubmitSuccessfullyActivity::class.java
                                    )
                                )
                                finish()
                            }
                            "6" -> {
//                                utils.showCustomToast(loginResponse.message)
                            }
                            else -> {
                                checkStatus(relative, loginResponse.status, loginResponse.message)
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

    private fun getAvailabilityNewApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<CaregiverCalendarAvailabilityNewResponse?> =
                RetrofitClient.getClient.getCaregiverCalendarAvailabilityNew(langTokenRequest)
            signUp.enqueue(object : Callback<CaregiverCalendarAvailabilityNewResponse?> {
                @RequiresApi(Build.VERSION_CODES.O)
                override fun onResponse(
                    call: Call<CaregiverCalendarAvailabilityNewResponse?>,
                    response: Response<CaregiverCalendarAvailabilityNewResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CaregiverCalendarAvailabilityNewResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                selectedDates.clear()
                                selectedDates.addAll(response.data)
                                calendarView.removeDecorators()
                                calendarView.addDecorators(
                                    MySelectorDecorator(activity),
                                    HighlightWeekendsDecorator(),
                                    oneDayDecorator
                                )
                                var dates: ArrayList<com.prolificinteractive.materialcalendarview.CalendarDay> =
                                    ArrayList()
                                for (i in response.data.indices) {
                                    val dates1 = response.data[i].date
                                    val datess = org.threeten.bp.LocalDate.parse(
                                        dates1,
                                        org.threeten.bp.format.DateTimeFormatter.ofPattern("yyyy-MM-dd")
                                    )

                                    val calendarDay =
                                        com.prolificinteractive.materialcalendarview.CalendarDay.from(
                                            datess
                                        )
//                                        calendarView.setDateSelected(calendarDay, true)

//                                        val eventDecorator = EventDecorator(calendarDay)
//                                        calendarView.addDecorator(eventDecorator)
//                                        calendarView.invalidateDecorators()
                                    dates.add(calendarDay)
                                }
                                calendarView.addDecorator(
                                    com.app.xtrahelpcaregiver.decorators.EventDecorator(
                                        Color.parseColor("#F79C1C"),
                                        dates
                                    )
                                )
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

                override fun onFailure(
                    call: Call<CaregiverCalendarAvailabilityNewResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getAvailabilityApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<AvailabilityResponse?> =
                RetrofitClient.getClient.getCaregiverAvailabilitySetting(langTokenRequest)
            signUp.enqueue(object : Callback<AvailabilityResponse?> {
                override fun onResponse(
                    call: Call<AvailabilityResponse?>, response: Response<AvailabilityResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: AvailabilityResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                availabilitySettingsList.clear()

                                for (i in response.data.availabilitySetting.indices) {
                                    val availability = Availability(
                                        response.data.availabilitySetting[i].day,
                                        response.data.availabilitySetting[i].type,
                                        response.data.availabilitySetting[i].startTime,
                                        response.data.availabilitySetting[i].endTime
                                    )
                                    availabilitySettingsList.add(availability)
                                }

                                if (response.data.availabilitySetting[0].timing == "30") {
                                    checkTime.isChecked = true
                                }

                                availabilityAdapter.notifyDataSetChanged()

                                timeOffList.clear()
                                for (i in response.data.timeOff.indices) {
                                    val offDateTime = OffDateTime(
                                        response.data.timeOff[i].day,
                                        response.data.timeOff[i].month,
                                        response.data.timeOff[i].startTime,
                                        response.data.timeOff[i].endTime
                                    )

                                    timeOffList.add(offDateTime)
                                }
                                timeOffAdapter.notifyDataSetChanged()

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

                override fun onFailure(call: Call<AvailabilityResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun removeSingleAvailabilityApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = RemoveSingleAvailabilityRequest(
                RemoveSingleAvailabilityRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    availabilityId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.removeSingleAvailabilityNew(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                @RequiresApi(Build.VERSION_CODES.O)
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                var removeDate = ""
                                for (i in selectedDates.indices) {
                                    if (selectedDates[i].availabilityId == availabilityId) {
                                        removeDate = selectedDates[i].date
                                        var dates: ArrayList<com.prolificinteractive.materialcalendarview.CalendarDay> =
                                            ArrayList()
                                        val dates1 = removeDate
                                        val datess = org.threeten.bp.LocalDate.parse(
                                            dates1,
                                            org.threeten.bp.format.DateTimeFormatter.ofPattern("yyyy-MM-dd")
                                        )
                                        val calendarDay =
                                            com.prolificinteractive.materialcalendarview.CalendarDay.from(
                                                datess
                                            )
                                        dates.add(calendarDay)
                                        break
                                    }
                                }

                                calendarView.clearSelection()
                                availabilityId = ""
                                getAvailabilityNewApi()
                                txtStartTime.text = ""
                                txtEndTime.text = ""
                                removeImg.visibility = View.GONE
                                txtNext.text = "Save Availability"
                                startTime = ""
                                endTime = ""
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<CommonResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun showAddWorkDialog() {
        val dialogView = layoutInflater.inflate(R.layout.add_availability_popup, null)
        val dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val linearWeekly = dialog.findViewById<LinearLayout>(R.id.linearWeekly)
        val checkRepeat = dialog.findViewById<AppCompatCheckBox>(R.id.checkRepeat)
        val txtSetAvailability = dialog.findViewById<TextView>(R.id.txtSetAvailability)
        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }
        checkRepeat!!.setOnClickListener { v: View? ->
            if (checkRepeat.isChecked) {
                linearWeekly!!.visibility = View.VISIBLE
            } else {
                linearWeekly!!.visibility = View.GONE
            }
        }
        txtSetAvailability!!.setOnClickListener { v: View? ->
            dialog.dismiss()
            startActivity(Intent(this, SubmitSuccessfullyActivity::class.java))
            finish()
        }
        dialog.show()
    }

    private fun saveCaregiverAvailability() {
        if (selected == "2") {
            if (radioWeekly.isChecked) {
                if (selectedDay == "Mon") {
                    repeatType = "1"
                } else if (selectedDay == "Tue") {
                    repeatType = "2"
                } else if (selectedDay == "Wed") {
                    repeatType = "3"
                } else if (selectedDay == "Thu") {
                    repeatType = "4"
                } else if (selectedDay == "Fri") {
                    repeatType = "5"
                } else if (selectedDay == "Sat") {
                    repeatType = "6"
                } else if (selectedDay == "Sun") {
                    repeatType = "7"
                }
            } else if (radioEveryWeekly.isChecked) {
                repeatType = "8"
            }
        }

        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val saveWorkDetailRequest = SaveCaregiverAvailibility(
                SaveCaregiverAvailibility.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    selected,
                    dateList,
                    repeatType,
                    startTime,
                    endTime
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.saveCaregiverAvailability(saveWorkDetailRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>, response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                utils.customToast(activity, response.message)
                                selectedDay = ""
                                calendarView.clearSelection()

                                getAvailabilityNewApi()

                                txtStartTime.text = ""
                                txtEndTime.text = ""
                                removeImg.visibility = View.GONE
                                txtNext.text = "Save Availability"
                                startTime = ""
                                endTime = ""

                                if (fromEdit) {
                                    utils.customToast(activity, response.message)
                                    finish()
                                } else {
                                    updateProfile()
                                }
                            }
                            "6" -> {
                                utils.showCustomToast(response.message)
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

                override fun onFailure(call: Call<CommonResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun isValid(): Boolean {
        var message = ""
        dateList.clear()
        for (i in calendarView.selectedDates.indices) {
            val year = calendarView.selectedDates[i].year
            val month = calendarView.selectedDates[i].month
            val day = calendarView.selectedDates[i].day
            var formatDay: String = day.toString()
            var formatmonth: String = month.toString()

            if (formatDay.length < 2) {
                formatDay = "0$formatDay"
            }

            if (formatmonth.length < 2) {
                formatmonth = "0$formatmonth"
            }


            val date = "$year-$formatmonth-$formatDay"
            dateList.add(date)
        }

        if (selected == "1") {
            if (dateList.isEmpty()) {
                message = getString(R.string.selectDates)
            } else if (startTime.isEmpty()) {
                message = "Please select start time"
            } else if (endTime.isEmpty()) {
                message = "Please select end time"
            }
        } else if (selected == "2") {
            if (repeatType == "1" && selectedDay == "") {
                message = "Please select repeat date"
            } else if (startTime.isEmpty()) {
                message = "Please select start time"
            } else if (endTime.isEmpty()) {
                message = "Please select end time"
            }
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }
}