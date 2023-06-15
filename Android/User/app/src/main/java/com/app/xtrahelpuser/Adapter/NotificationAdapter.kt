package com.app.xtrahelpuser.Adapter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.NotificationListResponse
import com.app.xtrahelpuser.Ui.DashboardActivity
import com.app.xtrahelpuser.Ui.JobDetailActivity


class NotificationAdapter(private val context: Context) :
    RecyclerView.Adapter<NotificationAdapter.ViewHolder>() {

    var notificationList: ArrayList<NotificationListResponse.Data> = ArrayList()

    @JvmName("setAdapterList")
    fun setAdapterList(list: ArrayList<NotificationListResponse.Data>) {
        this.notificationList = ArrayList()
        this.notificationList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var img: ImageView = view.findViewById(R.id.img)
        var txtTitle: TextView = view.findViewById(R.id.txtTitle)
        var txtTime: TextView = view.findViewById(R.id.txtTime)
    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): NotificationAdapter.ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_notification, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: NotificationAdapter.ViewHolder, position: Int) {
        val data = notificationList[position]
        holder.txtTime.text = data.time
        holder.txtTitle.text = data.desc

        if (data.model == "cancelUpcomingJobByCaregiver"
            || data.model == "applyUserJobByCaregiver"
            || data.model == "caregiverSubstituteJobByCaregiver"
        ) {
            holder.img.setImageResource(R.drawable.noti_calender_icon)
        } else {
            holder.img.setImageResource(R.drawable.noti_money_icon)
        }

        holder.itemView.setOnClickListener {
            if (data.model == "cancelUpcomingJobByCaregiver"
                || data.model == "caregiverSubstituteJobByCaregiver"
                || data.model == "transactionSuccessForJobPayment"
                || data.model == "transactionSuccessForAdditionaHoursJobPayment"
            ) {
                context.startActivity(
                    Intent(context, JobDetailActivity::class.java)
                        .putExtra(JobDetailActivity.JOBID, data.model_id)
                        .putExtra(JobDetailActivity.ISUSERRELATEDJOB, true)
                )
            } else if (data.model == "caregiverSubstituteJobRequestByCaregiverToUser") {
                context.startActivity(Intent(context, DashboardActivity::class.java)
                    .putExtra(DashboardActivity.FROMSUBSTITUTE,true))
                (context as Activity).finish()
                
            } else {
                context.startActivity(
                    Intent(context, JobDetailActivity::class.java)
                        .putExtra(JobDetailActivity.JOBID, data.model_id)
                        .putExtra(JobDetailActivity.ISUSERRELATEDJOB, false)
                )
            }
        }
    }

    override fun getItemCount(): Int {
        return notificationList.size
    }
}