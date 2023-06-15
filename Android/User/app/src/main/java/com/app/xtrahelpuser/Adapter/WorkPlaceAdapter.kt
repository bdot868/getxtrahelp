package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.CaregiverProfileResponse

class WorkPlaceAdapter(
    val context: Context,
    val workExperienceList: ArrayList<CaregiverProfileResponse.Data.WorkExperienceData> = ArrayList()
) : RecyclerView.Adapter<WorkPlaceAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtWorkPlace: TextView = view.findViewById(R.id.txtWorkPlace)
        val txtStartDate: TextView = view.findViewById(R.id.txtStartDate)
        val txtEndDate: TextView = view.findViewById(R.id.txtEndDate)
        val txtDesc: TextView = view.findViewById(R.id.txtDesc)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_work_place_profile, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = workExperienceList[position]
        holder.txtDesc.text = data.description
        holder.txtEndDate.text = data.endDate
        holder.txtStartDate.text = data.startDate
        holder.txtWorkPlace.text = data.workPlace
    }

    override fun getItemCount(): Int {
        return workExperienceList.size
    }
}