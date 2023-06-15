package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.Faq
import com.app.xtrahelpuser.Response.GetMyPostedJobResponse
import com.app.xtrahelpuser.Response.JobData
import com.app.xtrahelpuser.Response.UserRelatedJobResponse
import com.app.xtrahelpuser.Ui.ChattingActivity
import com.app.xtrahelpuser.Ui.JobDetailActivity
import com.bumptech.glide.Glide
import java.util.ArrayList

class MyJobAdapter(val context: Context, val type: String?) :
    RecyclerView.Adapter<MyJobAdapter.ViewHolder>() {
    var jobList: ArrayList<JobData> = ArrayList()

    @JvmName("setAdapterList")
    fun setAdapterList(list: ArrayList<JobData>) {
        this.jobList = ArrayList()
        this.jobList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val txtJobName: TextView = view.findViewById(R.id.txtJobName)
        val txtDate: TextView = view.findViewById(R.id.txtDate)
        val txtOTP: TextView = view.findViewById(R.id.txtOTP)
        val linearEnd: LinearLayout = view.findViewById(R.id.linearEnd)
        val viewLine: View = view.findViewById(R.id.viewLine)
        val chatIcon: ImageView = view.findViewById(R.id.chatIcon)
        val phoneIcon: ImageView = view.findViewById(R.id.phoneIcon)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyJobAdapter.ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.adapter_job, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: MyJobAdapter.ViewHolder, position: Int) {
        if (type == "dashboard") {
            holder.viewLine.visibility = View.GONE
        }

        val data = jobList[position]
        if (type == "1" || type == "dashboard") {
            holder.linearEnd.visibility = View.VISIBLE
            if (data.verificationCode == "0") {
                holder.txtOTP.visibility = View.GONE
            } else {
                holder.txtOTP.visibility = View.VISIBLE
            }
        } else {
            holder.linearEnd.visibility = View.GONE
        }

        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .placeholder(R.drawable.placeholder)
            .centerCrop()
            .into(holder.userImg)

        holder.txtUserName.text = data.userFullName
        holder.txtJobName.text = data.name
        holder.txtDate.text = data.startDateTime
        holder.txtOTP.text = "OTP "+data.verificationCode

        holder.itemView.setOnClickListener {
            context.startActivity(
                Intent(context, JobDetailActivity::class.java)
                    .putExtra(JobDetailActivity.JOBID, data.userJobDetailId)
                    .putExtra(JobDetailActivity.ISUSERRELATEDJOB, true)
            )
        }
        holder.chatIcon.setOnClickListener {
            context.startActivity(
                Intent(context, ChattingActivity::class.java)
                    .putExtra(ChattingActivity.ID, data.caregiverId)
                    .putExtra(ChattingActivity.FROMCHATLIST, false)
            )
        }

        if (data.caregiverPhone.isEmpty()) {
            holder.phoneIcon.visibility = View.GONE
        } else {
            holder.phoneIcon.visibility = View.VISIBLE
        }
        holder.phoneIcon.setOnClickListener {
            val phoneNo = data.caregiverPhone
            val intent = Intent(Intent.ACTION_DIAL)
            intent.data = Uri.parse("tel:$phoneNo")
            context.startActivity(intent)
        }
    }

    override fun getItemCount(): Int {
        return jobList.size
    }
}