package com.app.xtrahelpuser.Fragment

import android.app.TimePickerDialog
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import android.widget.TimePicker
import androidx.annotation.RequiresApi
import androidx.cardview.widget.CardView
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.SaveUserJobRequest
import com.app.xtrahelpuser.Ui.AddJobActivity
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.additionalQuestions
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.categoryId
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.currentEmployment
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.isJob
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.jobLatitude
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.jobLocation
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.jobLongitude
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.jobName
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.jobPrice
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.jobTiming
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.jobdescription
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.media
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.minExperience
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.nonSmoker
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.ownTransportation
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.subCategoryIds
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.yearExperience
import com.app.xtrahelpuser.Ui.JobSuccessActivity
import com.app.xtrahelpuser.decorators.HighlightWeekendsDecorator
import com.app.xtrahelpuser.decorators.MySelectorDecorator
import com.app.xtrahelpuser.decorators.OneDayDecorator
import com.github.hachimann.materialcalendarview.MaterialCalendarView.GONE
import com.github.hachimann.materialcalendarview.MaterialCalendarView.VISIBLE
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.prolificinteractive.materialcalendarview.CalendarDay
import com.prolificinteractive.materialcalendarview.MaterialCalendarView
import kotlinx.android.synthetic.main.fragment_time_schedule.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*


class TimeScheduleFragment : BaseFragment() {

    var picker: TimePickerDialog? = null
    var startTime = ""
    var endTime = ""

    var dates: ArrayList<String> = ArrayList()

    private val selectedDates: List<CalendarDay> = java.util.ArrayList()
    var checkedDates = BooleanArray(7)
    var daysOfWeek: List<Int> = java.util.ArrayList()
    var weekIdentifier = 0
    var isSwitchChecked = false

    lateinit var currentCalendarDay: com.prolificinteractive.materialcalendarview.CalendarDay
    private val oneDayDecorator: OneDayDecorator = OneDayDecorator()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_time_schedule, container, false)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        init()

        val year = Calendar.getInstance()[Calendar.YEAR]
        val month = Calendar.getInstance()[Calendar.MONTH]
        val day = Calendar.getInstance()[Calendar.DAY_OF_MONTH]

        calendarView.addDecorators(
            MySelectorDecorator(activity),
            HighlightWeekendsDecorator(),
            oneDayDecorator
        )

//        currentCalendarDay = CalendarDay.from(LocalDate.of(year, month + 1, day))
        currentCalendarDay = CalendarDay.from(year, month + 1, day)
        calendarView.state().edit()
            .setMinimumDate(CalendarDay.from(year, month + 1, 1))
            .commit()

        if (isJob == "1") {
            selected(txtOneTime)
            checkCondition()
        } else {
            selected(txtRecurring)
            checkCondition()
        }

        if (jobTiming.startTime.isNotEmpty()) {
            txtStartTime.text = jobTiming.startTime
        }
        if (jobTiming.endTime.isNotEmpty()) {
            txtEndTime.text = jobTiming.endTime
        }

        if (jobTiming.date.isNotEmpty()) {
            for (i in jobTiming.date.indices) {
                val currentString = jobTiming.date[i]
                val separated: List<String> = currentString.split("-")
                val year: String = separated[0]
                val month: String = separated[1]
                val day: String = separated[2]
                val calendarDay: CalendarDay =
                    CalendarDay.from(year.toInt(), month.toInt(), day.toInt())

                calendarView.setDateSelected(calendarDay, true)
            }
        }


    }


    @RequiresApi(Build.VERSION_CODES.O)
    private fun init() {
        relativeNext.setOnClickListener(this)
        relativeBack.setOnClickListener(this)
        txtRecurring.setOnClickListener(this)
        txtOneTime.setOnClickListener(this)
        linearStartTime.setOnClickListener(this)
        linearEndTime.setOnClickListener(this)

        checkCondition()

        calendarView.setOnDateChangedListener { widget, date, selected ->
            if (date.isBefore(currentCalendarDay)) {
                calendarView.setDateSelected(date, false)
                return@setOnDateChangedListener
            }
//            for (calendarDay in selectedDates) {
//                if (daysOfWeek.contains(calendarDay.date.dayOfWeek.value)) {
//                    calendarView.setDateSelected(date, false)
////                    calendarView.setDateSelected(calendarDay, !selectedDates.contains(calendarDay))
//                }
//                if (!daysOfWeek.contains(calendarDay.date.dayOfWeek.value)) {
//                    calendarView.setDateSelected(date, true)
////                    calendarView.setDateSelected(calendarDay, selectedDates.contains(calendarDay))
//                }
//            }
        }

//        calendarView.selectDaysOfWeek(daysOfWeek, 0, weekIdentifier, false)
//        for (calendarDay in selectedDates) {
//            if (daysOfWeek.contains(calendarDay.date.dayOfWeek.value)) {
//                calendarView.setDateSelected(
//                    calendarDay, !selectedDates.contains(calendarDay)
//                )
//            }
//            if (!daysOfWeek.contains(calendarDay.date.dayOfWeek.value)) {
//                calendarView.setDateSelected(
//                    calendarDay, selectedDates.contains(calendarDay)
//                )
//            }
//        }

//        calendarView.setOnDateChangedListener(OnDateSelectedListener { widget, date, selected ->
//            calendarView.selectedDate = date
//        })

    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.relativeNext -> {
                saveDates()
                if (isValid()) {
                    showAddCardDialog()
                }
            }

            R.id.relativeBack -> {
                saveDates()
                (getActivity() as AddJobActivity?)?.backFragment()
            }

            R.id.txtOneTime -> {
                if (isJob != "1") {
                    selected(txtOneTime)
                    isJob = "1"
                    checkCondition()
                }
            }
            R.id.txtRecurring -> {
                if (isJob != "2") {
                    selected(txtRecurring)
                    isJob = "2"
                    checkCondition()
                }
            }

            R.id.linearStartTime -> startDate()

            R.id.linearEndTime -> if (startTime == "") {
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
                val tempEndTime = SimpleDateFormat("HH:mm").format(calendar.timeInMillis)
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

                if (date!!.after(date1)) {
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
                    jobTiming.endTime = dateIn12Hour.toLowerCase()
                }
            }, hour1, minutes1, false
        )
        picker!!.show()
    }

    private fun checkCondition() {
        if (isJob == "1") {
            calendarView.clearSelection()
            calendarView.selectionMode = MaterialCalendarView.SELECTION_MODE_SINGLE
//            calendarView.selectionMode = SELECTION_MODE_MULTIPLE
        } else {
            calendarView.clearSelection()
            calendarView.selectionMode = MaterialCalendarView.SELECTION_MODE_MULTIPLE
        }
    }

    private fun selected(text: TextView) {
        txtOneTime.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtOneTime.background = resources.getDrawable(R.drawable.unselect_bg)
        txtRecurring.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtRecurring.background = resources.getDrawable(R.drawable.unselect_bg)

        text.setTextColor(resources.getColor(R.color.white))
        text.background = resources.getDrawable(R.drawable.select_job_bg)
    }

    val cldr = Calendar.getInstance()
    var hour = cldr[Calendar.HOUR_OF_DAY]
    var hour1 = cldr[Calendar.HOUR_OF_DAY]
    var minutes = cldr[Calendar.MINUTE]
    var minutes1 = cldr[Calendar.MINUTE]

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
                jobTiming!!.startTime = dateIn12Hour.toLowerCase()
            }, hour, minutes, false
        )
        picker!!.show()
    }


    private fun showAddCardDialog() {
        val dialogView = layoutInflater.inflate(R.layout.job_action_popup, null)
        val dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtFinish = dialog.findViewById<TextView>(R.id.txtFinish)
        val cardPostJob = dialog.findViewById<CardView>(R.id.cardPostJob)
        val cardSearch = dialog.findViewById<CardView>(R.id.cardSearch)
        val greenCheckPostJob = dialog.findViewById<ImageView>(R.id.greenCheckPostJob)
        val greenCheckSearchCaregiver =
            dialog.findViewById<ImageView>(R.id.greenCheckSearchCaregiver)

        var type: String = ""

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }
        txtFinish!!.setOnClickListener { v: View? ->
            if (type.isEmpty()) {
                utils.showCustomToast("Please select type")
            } else {
                saveJobApi()
                dialog.dismiss()
            }
//            startActivity(Intent(activity, JobSuccessActivity::class.java))
//            activity.finish()
        }

        cardPostJob!!.setOnClickListener {
            greenCheckPostJob!!.visibility = VISIBLE
            greenCheckSearchCaregiver!!.visibility = GONE
            type = "1"
        }

        cardSearch!!.setOnClickListener {
            greenCheckPostJob!!.visibility = GONE
            greenCheckSearchCaregiver!!.visibility = VISIBLE
            type = "2"
        }


        dialog.show()
    }


    fun saveDates() {
        jobTiming.date.clear()
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
            jobTiming.date.add(date)
        }

        Log.e("asdf]sdfsf", "onClick: $jobTiming.date")
    }


    private fun saveJobApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val mediaRequest1 = SaveUserJobRequest.Media("123", "")
            media.remove(mediaRequest1)

            val langTokenRequest = SaveUserJobRequest(
                SaveUserJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    categoryId,
                    subCategoryIds,
                    jobName,
                    jobPrice,
                    jobLocation,
                    jobLongitude,
                    jobLatitude,
                    jobdescription,
                    isJob,
                    ownTransportation,
                    nonSmoker,
                    currentEmployment,
                    minExperience,
                    yearExperience,
                    additionalQuestions,
                    media,
                    jobTiming
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.saveUserJob(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
//                                utils.customToast(activity, response.message)
                                (getActivity() as AddJobActivity).clearAllValue()

//                                categoryId = ""
//                                jobName = ""
//                                jobPrice = ""
//                                jobLocation = ""
//                                jobLatitude = ""
//                                jobLongitude = ""
//                                jobdescription = ""
//                                isJob = "1"
//                                ownTransportation = "0"
//                                nonSmoker = "0"
//                                currentEmployment = "0"
//                                minExperience = "0"
//                                yearExperience = ""
//                                subCategoryIds = java.util.ArrayList()
//                                additionalQuestions = java.util.ArrayList()
//                                media = java.util.ArrayList()
//                                jobTiming =
//                                    SaveUserJobRequest.JobTiming(java.util.ArrayList(), "", "")

                                startActivity(Intent(activity, JobSuccessActivity::class.java))
                                activity.finish()
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

    private fun isValid(): Boolean {
        var message: String
        message = ""

        if (isJob == "1" && jobTiming.date.isEmpty()) {
            message = "Please select date"
        } else if (isJob == "2" && (jobTiming.date.size < 2)) {
            message = "Please select atleast 2 dates"
        } else if (jobTiming.startTime.isEmpty()) {
            message = "Please select start time"
        } else if (jobTiming.endTime.isEmpty()) {
            message = "Please select end time"
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }

}
