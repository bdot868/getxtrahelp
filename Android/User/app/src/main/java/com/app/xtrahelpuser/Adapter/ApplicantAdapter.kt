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
import com.app.xtrahelpuser.Response.PostedJobDetailResponse
import com.app.xtrahelpuser.Ui.CaregiverProfileActivity
import com.bumptech.glide.Glide

class ApplicantAdapter(
    private val context: Context,
    var applicantList: ArrayList<PostedJobDetailResponse.Data.Applicants>
) : RecyclerView.Adapter<ApplicantAdapter.ViewHolder>() {

    var hired: Int = -1;
    var isHire: Boolean = false

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_applicants, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ApplicantAdapter.ViewHolder, position: Int) {
        if (applicantList[position].isHire == "1") {
            isHire = true;
            hired = position
        }

        Glide.with(context)
            .load(applicantList[position].profileImageThumbUrl)
            .centerCrop()
            .placeholder(R.drawable.placeholder)
            .into(holder.userImg)

        holder.txtUserName.text = applicantList[position].userFullName


        holder.itemView.setOnClickListener {
            if (applicantList[position].isHire == "1"){
                context.startActivity(
                    Intent(context, CaregiverProfileActivity::class.java)
                        .putExtra(CaregiverProfileActivity.CAREGIVERID, applicantList[position].userId)
                        .putExtra(CaregiverProfileActivity.JOBID, applicantList[position].jobId)
                        .putExtra(CaregiverProfileActivity.FROMHIRE, true)
                        .putExtra(CaregiverProfileActivity.HIREHIDE,false)
                        .putExtra(CaregiverProfileActivity.HIREENABLE,false)
                )
            } else {
                if (isHire) {
                    context.startActivity(
                        Intent(context, CaregiverProfileActivity::class.java)
                            .putExtra(CaregiverProfileActivity.CAREGIVERID, applicantList[position].userId)
                            .putExtra(CaregiverProfileActivity.JOBID, applicantList[position].jobId)
                            .putExtra(CaregiverProfileActivity.FROMHIRE, true)
                            .putExtra(CaregiverProfileActivity.HIREHIDE,true)
                            .putExtra(CaregiverProfileActivity.HIREENABLE,false)
                    )
                }else {
                    context.startActivity(
                        Intent(context, CaregiverProfileActivity::class.java)
                            .putExtra(CaregiverProfileActivity.CAREGIVERID, applicantList[position].userId)
                            .putExtra(CaregiverProfileActivity.JOBID, applicantList[position].jobId)
                            .putExtra(CaregiverProfileActivity.FROMHIRE, true)
                            .putExtra(CaregiverProfileActivity.HIREHIDE,false)
                            .putExtra(CaregiverProfileActivity.HIREENABLE,true)
                    )
                }
            }
        }
    }

    override fun getItemCount(): Int {
        return applicantList.size
    }
}                                                                                                   