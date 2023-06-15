package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Interface.RemoveClick
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.WorkExperience
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

class WorkExperienceAdapter(
    private val context: Context,
    val workExperienceList: ArrayList<WorkExperience>
) :
    RecyclerView.Adapter<WorkExperienceAdapter.ViewHolder>() {

    val inputFormat: DateFormat = SimpleDateFormat("yyyy-MM-dd")
    val outputFormat: DateFormat = SimpleDateFormat("MM-dd-yyyy")
    lateinit var removeClick: RemoveClick

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var txtWorkPlace: TextView = view.findViewById(R.id.txtWorkPlace)
        var txtStartDate: TextView = view.findViewById(R.id.txtStartDate)
        var txtEndDate: TextView = view.findViewById(R.id.txtEndDate)
        var txtDesc: TextView = view.findViewById(R.id.txtDesc)
        var removeImg: ImageView = view.findViewById(R.id.removeImg)
    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): WorkExperienceAdapter.ViewHolder {
        var view =
            LayoutInflater.from(parent.context)
                .inflate(R.layout.adapter_add_work_experience, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: WorkExperienceAdapter.ViewHolder, position: Int) {
//        val date: Date = inputFormat.parse(workExperienceList[position].startDate)
//        val outputDateStr: String = outputFormat.format(date)
//        holder.txtStartDate.text = outputDateStr

        holder.txtStartDate.text = workExperienceList[position].startDate

//        val date1: Date = inputFormat.parse(workExperienceList[position].endDate)
//        val outputDateStr1: String = outputFormat.format(date1)
//        holder.txtEndDate.text = outputDateStr1

        holder.txtEndDate.text = workExperienceList[position].endDate

        holder.txtWorkPlace.text = workExperienceList[position].workPlace
        holder.txtDesc.text = workExperienceList[position].description

        holder.removeImg.setOnClickListener {
            removeClick.onRemoveClick(position)
        }

    }

    fun onRemoveClick(removeClick: RemoveClick) {
        this.removeClick = removeClick
    }

    override fun getItemCount(): Int {
        return workExperienceList.size
    }
}