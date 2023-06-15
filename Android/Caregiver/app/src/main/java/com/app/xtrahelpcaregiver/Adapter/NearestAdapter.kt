package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.DashboardResponse
import com.app.xtrahelpcaregiver.Ui.JobDetailActivity
import com.bumptech.glide.Glide

class NearestAdapter(
    val context: Context,
    var nearestJobList: ArrayList<DashboardResponse.Data.NearestJob> = ArrayList()

) : RecyclerView.Adapter<NearestAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val txtDate: TextView = view.findViewById(R.id.txtDate)
        val txtJobName: TextView = view.findViewById(R.id.txtJobName)
        val txtType: TextView = view.findViewById(R.id.txtType)
        val txtCategoryName: TextView = view.findViewById(R.id.txtCategoryName)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_nearest, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = nearestJobList[position]
        holder.txtUserName.text = data.userFullName
        holder.txtJobName.text = data.name
        holder.txtDate.text = data.startDateTime
        holder.txtCategoryName.text = data.CategoryName

        if (data.isJob == "1") {
            holder.txtType.text = "One Time"
        } else {
            holder.txtType.text = "Recurring"
        }

        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .centerCrop()
            .placeholder(R.drawable.placeholder)
            .into(holder.userImg)
        
        holder.itemView.setOnClickListener {
            context.startActivity(
                Intent(context, JobDetailActivity::class.java)
                    .putExtra(JobDetailActivity.JOBID, data.userJobId)
                    .putExtra(JobDetailActivity.JOBDETAILTYPE,"search")
            )
        }
    }

    override fun getItemCount(): Int {
        return nearestJobList.size
    }
}