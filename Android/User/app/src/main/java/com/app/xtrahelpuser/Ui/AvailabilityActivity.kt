package com.app.xtrahelpuser.Ui

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.os.Build
import android.os.Bundle
import android.text.style.ForegroundColorSpan
import android.view.View
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.GridLayoutManager
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.AvailabilityAdapter
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.CaregiverAvailabilityRequest
import com.app.xtrahelpuser.Response.CaregiverAvailabilityResponse
import com.github.hachimann.materialcalendarview.CalendarDay
import com.github.hachimann.materialcalendarview.DayViewDecorator
import com.github.hachimann.materialcalendarview.DayViewFacade
import kotlinx.android.synthetic.main.activity_availability.*
import kotlinx.android.synthetic.main.activity_notification_setting.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.*
import kotlin.collections.ArrayList

class AvailabilityActivity : BaseActivity() {

    companion object {
        val CAREGIVRID = "caregiverId"
    }

    lateinit var availabilityAdapter: AvailabilityAdapter
    var caregiverId = ""
    lateinit var caregiverAvailRes: CaregiverAvailabilityResponse

    var slotList: ArrayList<CaregiverAvailabilityResponse.Data.Slot> = ArrayList()

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_availability)
        txtTitle.text = "Availability"
        caregiverId = intent.getStringExtra(CAREGIVRID)!!
        init()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun init() {
        arrowBack.setOnClickListener(this)

        availabilityAdapter = AvailabilityAdapter(activity, slotList)
        recyclerAvailability.layoutManager = GridLayoutManager(activity, 4)
        recyclerAvailability.isNestedScrollingEnabled = false
        recyclerAvailability.adapter = availabilityAdapter

        calendarView.setOnDateChangedListener { widget, date, selected ->
            val setDays: HashSet<CalendarDay> = HashSet()
            setDays.add(date)
            val myColor: Int = R.color.white

            calendarView.removeDecorators()
            calendarView.clearSelection()
            calendarView.addDecorator(CircleDecorator(activity, myColor, setDays))
            setSelectDate()

            slotList.clear()
            for (i in caregiverAvailRes.data.indices) {
                if (date.date.toString() == caregiverAvailRes.data[i].date) {
                    txtDateTime.text = caregiverAvailRes.data[i].dayAndDate
                    slotList.addAll(caregiverAvailRes.data[i].slot)
                    break
                }
            }
            if (slotList.isNotEmpty()) {
                linearAvailability.visibility = View.VISIBLE
            } else {
                linearAvailability.visibility = View.GONE
            }
            availabilityAdapter.notifyDataSetChanged()

//            calendarView.invalidateDecorators()
        }
//        calendarView.invalidate()

        getCaregiverAvailabilityApi()
    }

    class CircleDecorator(context: Context?, resId: Int, dates: Collection<CalendarDay?>?) :
        DayViewDecorator {
        private val dates: HashSet<CalendarDay>
        private val drawable: Drawable?
        override fun shouldDecorate(day: CalendarDay): Boolean {
            return dates.contains(day)
        }

        override fun decorate(view: DayViewFacade) {
            view.addSpan(ForegroundColorSpan(Color.WHITE))
            view.setSelectionDrawable(drawable!!)

        }

        init {
            drawable = ContextCompat.getDrawable(context!!, R.drawable.selected_date_bg)
            this.dates = HashSet(dates)
        }
    }

    private class BookingDecorator(
        private val mColor: Int,
        private val mCalendarDayCollection: HashSet<CalendarDay>
    ) :
        DayViewDecorator {
        override fun shouldDecorate(day: CalendarDay): Boolean {
            return mCalendarDayCollection.contains(day)
        }

        override fun decorate(view: DayViewFacade) {
            view.addSpan(ForegroundColorSpan(mColor))
            //view.addSpan(new BackgroundColorSpan(Color.BLUE));
//            view.setBackgroundDrawable(
//                ContextCompat.getDrawable(,
//                    R.drawable.greenbox
//                )!!
//            )
        }
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }

    private fun getCaregiverAvailabilityApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)

            val langTokenRequest = CaregiverAvailabilityRequest(
                CaregiverAvailabilityRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    caregiverId
                )
            )

            val signUp: Call<CaregiverAvailabilityResponse?> =
                RetrofitClient.getClient.getCaregiverAvailabilityNew(langTokenRequest)
            signUp.enqueue(object : Callback<CaregiverAvailabilityResponse?> {
                @RequiresApi(Build.VERSION_CODES.O)
                override fun onResponse(
                    call: Call<CaregiverAvailabilityResponse?>,
                    response: Response<CaregiverAvailabilityResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        caregiverAvailRes = response.body()!!
                        when (caregiverAvailRes.status) {
                            "1" -> {
                                try {
                                    for (i in caregiverAvailRes.data.indices) {
                                        val dates = caregiverAvailRes.data[i].date
                                        val datess = LocalDate.parse(
                                            dates,
                                            DateTimeFormatter.ofPattern("yyyy-MM-dd")
                                        )

                                        val calendarDay = CalendarDay.from(datess)
                                        calendarView.setDateSelected(calendarDay, true)
                                    }


                                } catch (e: Exception) {

                                }
                            }
                            "6" -> {

                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    caregiverAvailRes.status,
                                    caregiverAvailRes.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<CaregiverAvailabilityResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun setSelectDate() {
        try {
            for (i in caregiverAvailRes.data.indices) {
                val dates = caregiverAvailRes.data[i].date
                val datess = LocalDate.parse(
                    dates,
                    DateTimeFormatter.ofPattern("yyyy-MM-dd")
                )

                val calendarDay = CalendarDay.from(datess)
                calendarView.setDateSelected(calendarDay, true)
            }


        } catch (e: Exception) {

        }
    }
}