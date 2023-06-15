package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.media.Image
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.ImageView
import android.widget.Spinner
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.OffDateTime
import java.lang.NumberFormatException
import java.util.ArrayList

class TimeOffAdapter(
    val context: Context,
    val timeOffList: ArrayList<OffDateTime> = ArrayList<OffDateTime>(),
    val fromList: ArrayList<String> = ArrayList<String>(),
    val toList: ArrayList<String> = ArrayList<String>(),
    val monthsList: ArrayList<String> = ArrayList(),
    val dayList: ArrayList<String> = ArrayList()
) : RecyclerView.Adapter<TimeOffAdapter.ViewHolder>() {

    var fromAdapter: ArrayAdapter<*>? = null
    var toAdapter: ArrayAdapter<*>? = null
    var monthAdapter: ArrayAdapter<*>? = null
    var dayAdapter: ArrayAdapter<*>? = null

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val monthSpinner: Spinner = view.findViewById(R.id.monthSpinner)
        val daySpinner: Spinner = view.findViewById(R.id.daySpinner)
        val fromSpinner: Spinner = view.findViewById(R.id.fromSpinner)
        val toSpinner: Spinner = view.findViewById(R.id.toSpinner)
        val removeImg: ImageView = view.findViewById(R.id.removeImg)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TimeOffAdapter.ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_time_off, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: TimeOffAdapter.ViewHolder, position: Int) {
        dayAdapter = ArrayAdapter<Any?>(context, R.layout.spinner_textview, dayList as List<Any?>)
        (dayAdapter as ArrayAdapter<Any?>).setDropDownViewResource(R.layout.spinner_textview)

        monthAdapter = ArrayAdapter<Any?>(context, R.layout.spinner_textview, monthsList as List<Any?>)
        (monthAdapter as ArrayAdapter<Any?>).setDropDownViewResource(R.layout.spinner_textview)

        toAdapter = ArrayAdapter<Any?>(context, R.layout.spinner_textview, toList as List<Any?>)
        (toAdapter as ArrayAdapter<Any?>).setDropDownViewResource(R.layout.spinner_textview)

        fromAdapter = ArrayAdapter<Any?>(context, R.layout.spinner_textview, fromList as List<Any?>)
        (fromAdapter as ArrayAdapter<Any?>).setDropDownViewResource(R.layout.spinner_textview)

        holder.monthSpinner.adapter = monthAdapter
        holder.daySpinner.adapter = dayAdapter
        holder.fromSpinner.adapter = fromAdapter
        holder.toSpinner.adapter = toAdapter

        val timeOff: OffDateTime = timeOffList[position]
        if (timeOff.month != null) {
            var pos = 0
            try {
                pos = timeOff.month.toInt()
            } catch (e: NumberFormatException) {
                e.printStackTrace()
            }
            holder.monthSpinner.setSelection(pos - 1)
        }

        if (timeOff.day != null) {
            val spinnerPosition = (dayAdapter as ArrayAdapter<Any?>).getPosition(timeOff.day)
            holder.daySpinner.setSelection(spinnerPosition)
        }

        if (timeOff.startTime != null) {
            val spinnerPosition = (fromAdapter as ArrayAdapter<Any?>).getPosition(timeOff.startTime)
            holder.fromSpinner.setSelection(spinnerPosition)
        }
        if (timeOff.endTime != null) {
            val spinnerPosition = (toAdapter as ArrayAdapter<Any?>).getPosition(timeOff.endTime)
            holder.toSpinner.setSelection(spinnerPosition)
        }
        if (timeOff.endTime.isEmpty()) {
            holder.toSpinner.setSelection(toList.size - 1)
        }

        holder.monthSpinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View,
                position1: Int,
                id: Long
            ) {
                val pos = position1 + 1
                timeOffList[position].month = pos.toString()
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {}
        }

        holder.daySpinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View,
                position1: Int,
                id: Long
            ) {
                val pos = position1 + 1
                timeOffList[position].day = pos.toString()
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {}
        }

        holder.removeImg.setOnClickListener { v: View? ->
            removeAt(position)
        }

        holder.fromSpinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View,
                position1: Int,
                id: Long
            ) {
                timeOffList[position].startTime = fromList[position1]
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {}
        }

        holder.toSpinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View,
                position1: Int,
                id: Long
            ) {
                timeOffList[position].endTime = toList[position1]
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {}
        }
    }

    private fun removeAt(position: Int) {
        timeOffList.removeAt(position)
        notifyDataSetChanged()
//        notifyItemRangeChanged(position, availabilitySettingsList.size());
    }

    override fun getItemCount(): Int {
        return timeOffList.size
    }
}