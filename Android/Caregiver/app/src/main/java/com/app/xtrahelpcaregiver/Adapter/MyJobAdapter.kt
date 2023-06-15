package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.core.content.ContextCompat.startActivity
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Interface.CancelJobClickListener
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.Job
import com.app.xtrahelpcaregiver.Ui.ChattingActivity
import com.app.xtrahelpcaregiver.Ui.JobDetailActivity
import com.app.xtrahelpcaregiver.Utils.Utils
import com.bumptech.glide.Glide


class MyJobAdapter(val context: Context, val type: String?) :
    RecyclerView.Adapter<MyJobAdapter.ViewHolder>() {

    var jobList: ArrayList<Job> = ArrayList()

    lateinit var cancelJobClickListener: CancelJobClickListener
    lateinit var utils: Utils

    @JvmName("setAdapterList")
    fun setAdapterList(list: ArrayList<Job>) {
        this.jobList = ArrayList()
        if (list != null) this.jobList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val viewLine: View = view.findViewById(R.id.viewLine)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val txtJobName: TextView = view.findViewById(R.id.txtJobName)
        val txtDate: TextView = view.findViewById(R.id.txtDate)
        val mapImg: ImageView = view.findViewById(R.id.mapImg)
        val cancelImg: ImageView = view.findViewById(R.id.cancelImg)
        val chatImg: ImageView = view.findViewById(R.id.chatImg)
        val ratingBar: RatingBar = view.findViewById(R.id.ratingBar)
        val linearEnd: LinearLayout = view.findViewById(R.id.linearEnd)
        val relativeEnd: RelativeLayout = view.findViewById(R.id.relativeEnd)
        val phoneIcon: ImageView = view.findViewById(R.id.phoneIcon)

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.adapter_job, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = jobList[position]
        utils = Utils(context)

        holder.txtJobName.text = data.name
        holder.txtUserName.text = data.userFullName
        holder.txtDate.text = data.startDateTime

        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .centerCrop()
            .placeholder(R.drawable.placeholder)
            .into(holder.userImg)

        when (data.jobStatus) {
            "1" -> {
                holder.ratingBar.visibility = View.GONE
                holder.txtDate.visibility = View.VISIBLE
                holder.linearEnd.visibility = View.VISIBLE
                holder.cancelImg.visibility = View.GONE
            }
            "2" -> {
                holder.ratingBar.visibility = View.VISIBLE
                holder.txtDate.visibility = View.GONE
                holder.linearEnd.visibility = View.GONE
                holder.cancelImg.visibility = View.GONE
            }
            "3" -> {
                holder.ratingBar.visibility = View.GONE
                holder.txtDate.visibility = View.VISIBLE
                holder.linearEnd.visibility = View.GONE
                holder.cancelImg.visibility = View.VISIBLE
            }
        }



        holder.cancelImg.setOnClickListener {
            cancelJobClickListener.onCancelJobClick(data.userJobApplyId)
        }

        holder.itemView.setOnClickListener {
            Log.e("sldskdh", "onBindViewHolder: " + data.userJobId)
            context.startActivity(
                Intent(context, JobDetailActivity::class.java)
                    .putExtra(JobDetailActivity.JOBID, data.userJobDetailId)
                    .putExtra(JobDetailActivity.JOBDETAILTYPE, "job")
            )
        }


        holder.chatImg.setOnClickListener {
            context.startActivity(
                Intent(context, ChattingActivity::class.java)
                    .putExtra(ChattingActivity.ID, jobList[position].userId)
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
        return jobList.size
    }

    fun cancelJobClickListener(cancelJobClickListener: CancelJobClickListener) {
        this.cancelJobClickListener = cancelJobClickListener
    }
}