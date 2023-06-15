package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.widget.AppCompatCheckBox
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Interface.FilterCategorySelectClick
import com.app.xtrahelpcaregiver.Interface.FilterSpecialitiesSelectClick
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.WorkSpeciality

class SpecialitiesFilterAdapter(
    val context: Context,
    val workSpecialityList: ArrayList<WorkSpeciality>,
    var selectedSpeciality: ArrayList<String>
) :
    RecyclerView.Adapter<SpecialitiesFilterAdapter.ViewHolder>() {

    lateinit var filterSpecialitiesSelectClick: FilterSpecialitiesSelectClick

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val checkbox: AppCompatCheckBox = view.findViewById(R.id.checkbox)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_specialities_filter, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.checkbox.text = workSpecialityList[position].name

        for (i in selectedSpeciality.indices) {
            if (selectedSpeciality[i] == workSpecialityList[position].workSpecialityId) {
                holder.checkbox.isChecked = true
            }
        }

        holder.checkbox.setOnClickListener {
            if (selectedSpeciality.contains(workSpecialityList[position].workSpecialityId)){
                filterSpecialitiesSelectClick.onSpecialitiesSelectUnselect(workSpecialityList[position].workSpecialityId,false)
            }else {
                filterSpecialitiesSelectClick.onSpecialitiesSelectUnselect(workSpecialityList[position].workSpecialityId,true)
            }
        }

    }

    override fun getItemCount(): Int {
        return workSpecialityList.size
    }

    fun filterSpecialitiesSelectClick(filterSpecialitiesSelectClick: FilterSpecialitiesSelectClick) {
        this.filterSpecialitiesSelectClick = filterSpecialitiesSelectClick
    }
}