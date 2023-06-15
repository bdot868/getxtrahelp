package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.JobData
import com.app.xtrahelpuser.Response.UserDashboardResponse
import com.app.xtrahelpuser.Ui.JobDetailActivity
import com.bumptech.glide.Glide

class UpcomingAdapter(
    val context: Context,
    val upcomingJobsList: ArrayList<JobData> = ArrayList()
) : RecyclerView.Adapter<UpcomingAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val viewLine: View = view.findViewById(R.id.viewLine)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val txtJobName: TextView = view.findViewById(R.id.txtJobName)
        val txtDate: TextView = view.findViewById(R.id.txtDate)
        val txtOTP: TextView = view.findViewById(R.id.txtOTP)
        val chatIcon: ImageView = view.findViewById(R.id.chatIcon)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): UpcomingAdapter.ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.adapter_job, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: UpcomingAdapter.ViewHolder, position: Int) {
        holder.viewLine.visibility = View.GONE
        val data = upcomingJobsList[position]

        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .centerCrop()
            .placeholder(R.drawable.placeholder)
            .into(holder.userImg)
        holder.txtUserName.text = data.userFullName
        holder.txtJobName.text = data.name
        holder.txtDate.text = data.startDateTime
        holder.txtOTP.text = data.verificationCode

        if (data.verificationCode == "0") {
            holder.txtOTP.visibility=View.GONE
        }else {
            holder.txtOTP.visibility=View.VISIBLE
        }

        holder.itemView.setOnClickListener(View.OnClickListener {
            context.startActivity(Intent(context, JobDetailActivity::class.java))
        })

    }

    override fun getItemCount(): Int {
        return upcomingJobsList.size
    }
}