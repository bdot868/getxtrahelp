package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.ImageView
import android.widget.Spinner
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.Availability
import java.util.*

class AvailabilityAdapter(
    val context: Context,
    val availabilitySettingsList: ArrayList<Availability>,
    val windowList: ArrayList<String> = ArrayList(),
    val fromList: ArrayList<String> = ArrayList<String>(),
    val toList: ArrayList<String> = ArrayList<String>()
) : RecyclerView.Adapter<AvailabilityAdapter.ViewHolder>() {


    var windowAdapter: ArrayAdapter<*>? = null
    var fromAdapter: ArrayAdapter<*>? = null
    var toAdapter: ArrayAdapter<*>? = null

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val availabilityWindowSpinner: Spinner = view.findViewById(R.id.availabilityWindowSpinner)
        val fromSpinner: Spinner = view.findViewById(R.id.fromSpinner)
        val toSpinner: Spinner = view.findViewById(R.id.toSpinner)
        val removeImg: ImageView = view.findViewById(R.id.removeImg)
    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_availability, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        windowAdapter =
            ArrayAdapter<Any?>(context, R.layout.spinner_textview, windowList as List<Any?>)
        (windowAdapter as ArrayAdapter<Any?>).setDropDownViewResource(R.layout.spinner_textview)

        fromAdapter = ArrayAdapter<Any?>(context, R.layout.spinner_textview, fromList as List<Any?>)
        (fromAdapter as ArrayAdapter<Any?>).setDropDownViewResource(R.layout.spinner_textview)
        toAdapter = ArrayAdapter<Any?>(context, R.layout.spinner_textview, toList as List<Any?>)
        (toAdapter as ArrayAdapter<Any?>).setDropDownViewResource(R.layout.spinner_textview)

        holder.availabilityWindowSpinner.adapter = windowAdapter
        holder.fromSpinner.adapter = fromAdapter
        holder.toSpinner.adapter = toAdapter

        val availabilitySetting: Availability = availabilitySettingsList[position]

        if (availabilitySetting.type == "1") {
            holder.availabilityWindowSpinner.setSelection(0)
        } else if (availabilitySetting.type == "2") {
            holder.availabilityWindowSpinner.setSelection(1)
        } else if (availabilitySetting.type == "3") {
            if (availabilitySetting.day == "1") {
                holder.availabilityWindowSpinner.setSelection(2)
            } else if (availabilitySetting.day == "2") {
                holder.availabilityWindowSpinner.setSelection(3)
            } else if (availabilitySetting.day == "3") {
                holder.availabilityWindowSpinner.setSelection(4)
            } else if (availabilitySetting.day == "4") {
                holder.availabilityWindowSpinner.setSelection(5)
            } else if (availabilitySetting.day == "5") {
                holder.availabilityWindowSpinner.setSelection(6)
            } else if (availabilitySetting.day == "6") {
                holder.availabilityWindowSpinner.setSelection(7)
            } else if (availabilitySetting.day == "7") {
                holder.availabilityWindowSpinner.setSelection(8)
            }
        }

        if (availabilitySetting.startTime != null) {
            val spinnerPosition =
                (fromAdapter as ArrayAdapter<Any?>).getPosition(availabilitySetting.startTime)
            holder.fromSpinner.setSelection(spinnerPosition)
        }
        if (availabilitySetting.endTime != null) {
            val spinnerPosition =
                (toAdapter as ArrayAdapter<Any?>).getPosition(availabilitySetting.endTime)
            holder.toSpinner.setSelection(spinnerPosition)
        }
        if (availabilitySetting.endTime.isEmpty()) {
            holder.toSpinner.setSelection(toList.size - 1)
        }

        holder.availabilityWindowSpinner.onItemSelectedListener =
            object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(
                    parent: AdapterView<*>?,
                    view: View,
                    position1: Int,
                    id: Long
                ) {
                    if (position1 == 0) {
                        availabilitySettingsList[position].day = "0"
                        availabilitySettingsList[position].type = "1"
                    } else if (position1 == 1) {
                        availabilitySettingsList[position].day = "0"
                        availabilitySettingsList[position].type = "2"
                    } else if (position1 == 2) {
                        availabilitySettingsList[position].day = "1"
                        availabilitySettingsList[position].type = "3"
                    } else if (position1 == 3) {
                        availabilitySettingsList[position].day = "2"
                        availabilitySettingsList[position].type = "3"
                    } else if (position1 == 4) {
                        availabilitySettingsList[position].day = "3"
                        availabilitySettingsList[position].type = "3"
                    } else if (position1 == 5) {
                        availabilitySettingsList[position].day = "4"
                        availabilitySettingsList[position].type = "3"
                    } else if (position1 == 6) {
                        availabilitySettingsList[position].day = "5"
                        availabilitySettingsList[position].type = "3"
                    } else if (position1 == 7) {
                        availabilitySettingsList[position].day = "6"
                        availabilitySettingsList[position].type = "3"
                    } else if (position1 == 8) {
                        availabilitySettingsList[position].day = "7"
                        availabilitySettingsList[position].type = "3"
                    }
                }

                override fun onNothingSelected(parent: AdapterView<*>?) {}
            }

        holder.fromSpinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View,
                position1: Int,
                id: Long
            ) {
                availabilitySettingsList[position].startTime = fromList[position1]
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
                availabilitySettingsList[position].endTime = toList[position1]
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {}
        }

        holder.removeImg.setOnClickListener { v: View? ->
            removeAt(
                position
            )
//            if (availabilitySettingsList.size == 1) {
//            } else {
//                removeAt(position);
//            }
        }
    }

    private fun removeAt(position: Int) {
        availabilitySettingsList.removeAt(position)
        notifyDataSetChanged()
//        notifyItemRangeChanged(position, availabilitySettingsList.size());
    }

    override fun getItemCount(): Int {
        return availabilitySettingsList.size
    }
}