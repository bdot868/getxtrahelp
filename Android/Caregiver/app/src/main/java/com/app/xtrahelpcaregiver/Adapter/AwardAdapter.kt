package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Interface.AcceptRejectSubJobClickListener
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.AwardListResponse
import com.app.xtrahelpcaregiver.Response.SubstituteListResponse
import com.app.xtrahelpcaregiver.Ui.JobDetailActivity
import com.bumptech.glide.Glide
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import java.util.ArrayList

class AwardAdapter(val context: Context) :
    RecyclerView.Adapter<AwardAdapter.ViewHolder>() {
    var jobList: ArrayList<AwardListResponse.Data> = ArrayList()

    lateinit var acceptRejectSubJobClickListener: AcceptRejectSubJobClickListener

    @JvmName("setAdapterList")
    fun setAdapterList(list: ArrayList<AwardListResponse.Data>) {
        this.jobList = ArrayList()
        this.jobList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val txtJobName: TextView = view.findViewById(R.id.txtJobName)
        val txtDate: TextView = view.findViewById(R.id.txtDate)
        val linearEnd: LinearLayout = view.findViewById(R.id.linearEnd)
        val viewLine: View = view.findViewById(R.id.viewLine)
        val acceptImg: ImageView = view.findViewById(R.id.acceptImg)
        val decline: ImageView = view.findViewById(R.id.decline)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): AwardAdapter.ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.adapter_substitute, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: AwardAdapter.ViewHolder, position: Int) {
        val data = jobList[position]


        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .placeholder(R.drawable.placeholder)
            .centerCrop()
            .into(holder.userImg)

        holder.txtUserName.text = data.userFullName
        holder.txtJobName.text = data.jobName
        holder.txtDate.text = data.startDateTime

//        holder.itemView.setOnClickListener {
//            context.startActivity(
//                Intent(context, JobDetailActivity::class.java)
//                    .putExtra(JobDetailActivity.JOBID, data.jobId                                                                                                )
//                    .putExtra(JobDetailActivity.JOBDETAILTYPE, "job")
//            )
//        }

        holder.acceptImg.setOnClickListener {
            popup(true, position)
        }

        holder.decline.setOnClickListener {
            popup(false, position)
        }

    }

    private fun popup(isAccept: Boolean, position: Int) {
        var message = ""
        message = if (isAccept) {
            "Are you sure want to accept this award job request?"
        } else {
            "Are you sure want to reject this award job request?"
        }
        MaterialAlertDialogBuilder(context)
            .setCancelable(false)
            .setMessage(message)
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int ->
                if (isAccept) {
                    acceptRejectSubJobClickListener.onSubClick(
                        jobList[position].userJobAwardId,
                        true
                    )
                } else {
                    acceptRejectSubJobClickListener.onSubClick(
                        jobList[position].userJobAwardId,
                        false
                    )
                }
            }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }

    
    override fun getItemCount(): Int {
        return jobList.size
    }

    fun onSubClick(acceptRejectSubJobClickListener: AcceptRejectSubJobClickListener) {
        this.acceptRejectSubJobClickListener = acceptRejectSubJobClickListener
    }
}