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
import com.app.xtrahelpuser.Response.UserDashboardResponse
import com.app.xtrahelpuser.Ui.CaregiverProfileActivity
import com.bumptech.glide.Glide

class NearestAdapter(
    val context: Context,
    val nearestCaregiverList: ArrayList<UserDashboardResponse.Data.NearestCaregiver> = ArrayList()
) : RecyclerView.Adapter<NearestAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val txtCategory: TextView = view.findViewById(R.id.txtCategory)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): NearestAdapter.ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_nearest, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: NearestAdapter.ViewHolder, position: Int) {
        val data = nearestCaregiverList[position]
        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .centerCrop()
            .placeholder(R.drawable.placeholder)
            .into(holder.userImg)

        holder.txtUserName.text = data.fullName
        holder.txtCategory.text = data.categoryNames

        holder.itemView.setOnClickListener {
            context.startActivity(
                Intent(context, CaregiverProfileActivity::class.java)
                    .putExtra(CaregiverProfileActivity.CAREGIVERID, data.id)
            )
        }
    }

    override fun getItemCount(): Int {
        return nearestCaregiverList.size
    }

}