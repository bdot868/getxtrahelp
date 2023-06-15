package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.RatingBar
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.Interface.AcceptDeclineRequestClick
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.PostedJobAplicantResponse
import com.bumptech.glide.Glide

class ApplicantListAdapter(
    private val context: Context,
    var applicantList: ArrayList<PostedJobAplicantResponse.Data>
) : RecyclerView.Adapter<ApplicantListAdapter.ViewHolder>() {
    var hired: Int = -1;
    var isHire: Boolean = false
    lateinit var acceptDeclineRequestClick: AcceptDeclineRequestClick

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtHired: TextView = view.findViewById(R.id.txtHired)
        val txtCategory: TextView = view.findViewById(R.id.txtCategory)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val ratingBar: RatingBar = view.findViewById(R.id.ratingBar)
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val acceptImg: ImageView = view.findViewById(R.id.acceptImg)
        val decline: ImageView = view.findViewById(R.id.decline)
        val linearEnd: LinearLayout = view.findViewById(R.id.linearEnd)

    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_applicants_list, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        if (applicantList[position].isHire == "1") {
            isHire = true
            hired = position
        }

        if (hired == position) {
            holder.linearEnd.visibility = View.GONE
            holder.txtHired.visibility = View.VISIBLE
        } else {
            holder.linearEnd.visibility = View.VISIBLE
            holder.txtHired.visibility = View.GONE
        }

        if (isHire) {
            if (hired == position) {
                holder.linearEnd.visibility = View.GONE
                holder.txtHired.visibility = View.VISIBLE
            } else {
                holder.linearEnd.visibility = View.GONE
                holder.txtHired.visibility = View.GONE
            }
        }

        holder.txtCategory.text = applicantList[position].categoryNames
        holder.txtUserName.text = applicantList[position].userFullName
        holder.ratingBar.rating = applicantList[position].caregiverRatingAverage.toFloat()

        Glide.with(context)
            .load(applicantList[position].profileImageThumbUrl)
            .placeholder(R.drawable.placeholder)
            .centerCrop()
            .into(holder.userImg)

        holder.acceptImg.setOnClickListener {
            acceptDeclineRequestClick.onAcceptDeclineClick(applicantList[position].userId, "accept")
        }

        holder.decline.setOnClickListener {
            acceptDeclineRequestClick.onAcceptDeclineClick(
                applicantList[position].userId,
                "decline"
            )
        }

        holder.userImg.setOnClickListener {
            acceptDeclineRequestClick.onAnswerClick(
                applicantList[position].jobId,
                applicantList[position].userId,
                applicantList[position].userFullName
            )
        }
    }

    override fun getItemCount(): Int {
        return applicantList.size
    }

    fun acceptDeclineRequestClick(acceptDeclineRequestClick: AcceptDeclineRequestClick) {
        this.acceptDeclineRequestClick = acceptDeclineRequestClick;
    }

}