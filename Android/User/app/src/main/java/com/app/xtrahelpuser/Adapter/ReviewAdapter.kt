package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.CaregiverProfileResponse
import com.app.xtrahelpuser.Ui.SupportChatActivity
import com.bumptech.glide.Glide

class ReviewAdapter(
    val context: Context,
    val reviewList: ArrayList<CaregiverProfileResponse.Data.ReviewData>
) :
    RecyclerView.Adapter<ReviewAdapter.ViewHolder>() {


    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val txtDate: TextView = view.findViewById(R.id.txtDate)
        val txtDesc: TextView = view.findViewById(R.id.txtDesc)
        val ratingBar: RatingBar = view.findViewById(R.id.ratingBar)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_review, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = reviewList[position]

        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .placeholder(R.drawable.placeholder)
            .centerCrop()
            .into(holder.userImg)

        holder.txtUserName.text = data.userFullName
        holder.txtDesc.text = data.feedback
        holder.txtDate.text = data.reviewDate
        holder.ratingBar.rating = data.rating.toFloat()
    }

    override fun getItemCount(): Int {
        return reviewList.size
    }
}