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
import com.app.xtrahelpuser.Response.Faq
import com.app.xtrahelpuser.Response.GetMyPostedJobResponse
import com.app.xtrahelpuser.Ui.JobDetailActivity
import java.util.ArrayList

class PostedJobAdapter(private val context: Context, private val activity: String?) :
    RecyclerView.Adapter<PostedJobAdapter.ViewHolder>() {
    var myJobList: ArrayList<GetMyPostedJobResponse.Data> = ArrayList()

    @JvmName("setFaqList1")
    fun setAdapterList(list: ArrayList<GetMyPostedJobResponse.Data>) {
        this.myJobList.clear()
        this.myJobList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val txtJobName: TextView = view.findViewById(R.id.txtJobName)
        val txtDate: TextView = view.findViewById(R.id.txtDate)
        val txtApplications: TextView = view.findViewById(R.id.txtApplications)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PostedJobAdapter.ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_posted_job, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: PostedJobAdapter.ViewHolder, position: Int) {
        holder.txtJobName.text = myJobList[position].name
        holder.txtDate.text = myJobList[position].startDateTime
        holder.txtApplications.text = myJobList[position].totalApplication

        holder.itemView.setOnClickListener {
            context.startActivity(
                Intent(context, JobDetailActivity::class.java)
                    .putExtra(JobDetailActivity.JOBID, myJobList[position].userJobId)
            )
        }
    }

    override fun getItemCount(): Int {
        return myJobList.size
    }
}