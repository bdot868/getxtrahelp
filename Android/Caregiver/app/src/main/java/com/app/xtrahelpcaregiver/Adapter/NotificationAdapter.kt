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
import com.app.xtrahelpcaregiver.Response.NotificationListResponse
import com.app.xtrahelpcaregiver.Ui.DashboardActivity
import com.app.xtrahelpcaregiver.Ui.JobDetailActivity

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
    ): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_notification, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = notificationList[position]
        holder.txtTime.text = data.time
        holder.txtTitle.text = data.desc

        if (data.model == "acceptJobRequestByUser" || data.model == "rejectJobRequestByUser") {
            holder.img.setImageResource(R.drawable.noti_calender_icon)
        } else {
            holder.img.setImageResource(R.drawable.noti_money_icon)
        }

        holder.itemView.setOnClickListener {
            if (data.model == "acceptJobRequestByUser"
                || data.model == "addMoneyInYourWalletForUserJobPayment"
                || data.model == "transactionSuccessForJobPayment" ||
                data.model == "alertUserMessageBeforeStartjobOf30Mint"
            ) {
                context.startActivity(
                    Intent(context, JobDetailActivity::class.java)
                        .putExtra(JobDetailActivity.JOBID, data.model_id)
                        .putExtra(JobDetailActivity.JOBDETAILTYPE, "job")
                )
            } else if (data.model == "sendAwardJobRequestByUser") {
                context.startActivity(
                    Intent(context, DashboardActivity::class.java)
                        .putExtra(DashboardActivity.FROMAWARD,true)
                )
            } else {
                context.startActivity(
                    Intent(context, JobDetailActivity::class.java)
                        .putExtra(JobDetailActivity.JOBID, data.model_id)
                        .putExtra(JobDetailActivity.JOBDETAILTYPE, "")
                )
            }
        }
    }

    override fun getItemCount(): Int {
        return notificationList.size
    }
}