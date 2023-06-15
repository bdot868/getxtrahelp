package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.View.GONE
import android.view.View.VISIBLE
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.RatingBar
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.FindCaregiverResponse
import com.app.xtrahelpuser.Ui.CaregiverProfileActivity
import com.bumptech.glide.Glide
import org.w3c.dom.Text

class CaregiverAdapter(val context: Context, val from: String) :
    RecyclerView.Adapter<CaregiverAdapter.ViewHolder>() {

    var caregiverList: ArrayList<FindCaregiverResponse.Data> = ArrayList()

    @JvmName("setAdapterList")
    fun setAdapterList(list: ArrayList<FindCaregiverResponse.Data>) {
        this.caregiverList = ArrayList()
        this.caregiverList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val linearRating: LinearLayout = view.findViewById(R.id.linearRating)
        val linearEnd: LinearLayout = view.findViewById(R.id.linearEnd)
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val txtCaregiverName: TextView = view.findViewById(R.id.txtCaregiverName)
        val txtCategory: TextView = view.findViewById(R.id.txtCategory)
        val txtCompletedJob: TextView = view.findViewById(R.id.txtCompletedJob)
        val txtJob: TextView = view.findViewById(R.id.txtJob)
        val ratingBar: RatingBar = view.findViewById(R.id.ratingBar)
        val txtRating: TextView = view.findViewById(R.id.txtRating)
    }


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_caregiver, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = caregiverList[position]

        if (from.equals("fragment")) {
            holder.linearEnd.visibility = VISIBLE
            holder.linearRating.visibility = GONE
            holder.txtJob.text = data.totalJobWithMe
        } else {
            holder.linearEnd.visibility = GONE
            holder.linearRating.visibility = VISIBLE
            holder.ratingBar.rating = data.ratingAverage.toFloat()
            holder.txtRating.text = data.ratingAverage
            holder.txtJob.text = data.totalJobOngoingWithMe
        }

        holder.txtCaregiverName.text = data.fullName
        holder.txtCategory.text = data.categoryNames
        holder.txtCompletedJob.text = data.totalJobCompleted + " Jobs Completed"
        
        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .centerCrop()
            .placeholder(R.drawable.placeholder)
            .into(holder.userImg)

        holder.itemView.setOnClickListener {
            context.startActivity(
                Intent(context, CaregiverProfileActivity::class.java)
                    .putExtra(CaregiverProfileActivity.CAREGIVERID, data.id)
            )
        }
    }

    override fun getItemCount(): Int {
        return caregiverList.size
    }

}