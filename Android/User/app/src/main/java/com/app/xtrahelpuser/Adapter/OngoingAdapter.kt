package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.content.Intent
import android.media.Image
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.UserDashboardResponse
import com.app.xtrahelpuser.Ui.ChattingActivity
import com.app.xtrahelpuser.Ui.JobDetailActivity
import com.bumptech.glide.Glide

class OngoingAdapter(
    val context: Context,
    val ongoingJobsList: ArrayList<UserDashboardResponse.Data.OnGoing> = ArrayList()
) : RecyclerView.Adapter<OngoingAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val chatIcon: ImageView = view.findViewById(R.id.chatIcon)
        val txtCaregiverName: TextView = view.findViewById(R.id.txtCaregiverName)
        val txtJobName: TextView = view.findViewById(R.id.txtJobName)
        val txtTimeLeft: TextView = view.findViewById(R.id.txtTimeLeft)

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): OngoingAdapter.ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_ongoing, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: OngoingAdapter.ViewHolder, position: Int) {
        val data = ongoingJobsList[position]
        holder.txtCaregiverName.text = data.userFullName
        holder.txtJobName.text = data.name
        holder.txtTimeLeft.text = data.leftTime

        
            Glide.with(context)
                .load(data.profileImageThumbUrl)
                .placeholder(R.drawable.placeholder)
                .centerCrop()
                .into(holder.userImg)

        holder.chatIcon.setOnClickListener {
            context.startActivity(
                Intent(context, ChattingActivity::class.java)
                    .putExtra(ChattingActivity.ID, data.userId)
                    .putExtra(ChattingActivity.FROMCHATLIST, false)
            )
        }

        holder.itemView.setOnClickListener {
            context.startActivity(
                Intent(context, JobDetailActivity::class.java)
                    .putExtra(JobDetailActivity.JOBID, data.userJobDetailId)
                    .putExtra(JobDetailActivity.ISUSERRELATEDJOB, true)
            )
        }
    }

    override fun getItemCount(): Int {
        return ongoingJobsList.size
    }
}