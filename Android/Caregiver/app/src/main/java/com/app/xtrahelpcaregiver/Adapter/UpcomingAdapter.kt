package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.Job
import com.app.xtrahelpcaregiver.Ui.ChattingActivity
import com.app.xtrahelpcaregiver.Ui.JobDetailActivity
import com.app.xtrahelpcaregiver.Utils.Utils
import com.bumptech.glide.Glide


class UpcomingAdapter(
    val context: Context,
    val upcomingJobList: ArrayList<Job> = ArrayList()
) : RecyclerView.Adapter<UpcomingAdapter.ViewHolder>() {
    lateinit var utils: Utils

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val viewLine: View = view.findViewById(R.id.viewLine)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val txtJobName: TextView = view.findViewById(R.id.txtJobName)
        val txtDate: TextView = view.findViewById(R.id.txtDate)
        val mapImg: ImageView = view.findViewById(R.id.mapImg)
        val cancelImg: ImageView = view.findViewById(R.id.cancelImg)
        val chatImg: ImageView = view.findViewById(R.id.chatImg)
        val phoneIcon: ImageView = view.findViewById(R.id.phoneIcon)
        val ratingBar: RatingBar = view.findViewById(R.id.ratingBar)
        val linearEnd: LinearLayout = view.findViewById(R.id.linearEnd)
        val relativeEnd: RelativeLayout = view.findViewById(R.id.relativeEnd)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): UpcomingAdapter.ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.adapter_job, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: UpcomingAdapter.ViewHolder, position: Int) {
        holder.viewLine.visibility = View.GONE
        utils = Utils(context)
        val data = upcomingJobList[position]

        holder.txtJobName.text = data.name
        holder.txtUserName.text = data.userFullName
        holder.txtDate.text = data.startDateTime

        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .centerCrop()
            .placeholder(R.drawable.placeholder)
            .into(holder.userImg)

        holder.ratingBar.visibility = View.GONE
        holder.txtDate.visibility = View.VISIBLE
        holder.linearEnd.visibility = View.VISIBLE
        holder.cancelImg.visibility = View.GONE

        holder.itemView.setOnClickListener {
            context.startActivity(
                Intent(context, JobDetailActivity::class.java)
                    .putExtra(JobDetailActivity.JOBID, data.userJobDetailId)
                    .putExtra(JobDetailActivity.JOBDETAILTYPE, "job")
            )
        }

        holder.chatImg.setOnClickListener {
            context.startActivity(
                Intent(context, ChattingActivity::class.java)
                    .putExtra(ChattingActivity.ID, data.userId)
                    .putExtra(ChattingActivity.FROMCHATLIST, false)
            )
        }

        holder.mapImg.setOnClickListener {
            utils.showMap(context, data.latitude, data.longitude)
        }

        if (data.userPhone.isEmpty()) {
            holder.phoneIcon.visibility = View.GONE
        } else {
            holder.phoneIcon.visibility = View.VISIBLE
        }
        
        holder.phoneIcon.setOnClickListener {
            val phoneNo = data.userPhone
            val intent = Intent(Intent.ACTION_DIAL)
            intent.data = Uri.parse("tel:$phoneNo")
            context.startActivity(intent)
        }
    }

    override fun getItemCount(): Int {
        return upcomingJobList.size
    }
}