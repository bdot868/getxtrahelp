package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.CommentListResponse
import com.app.xtrahelpcaregiver.Response.MyReviewListResponse
import com.bumptech.glide.Glide

class MyReviewAdapter(val context: Context) : RecyclerView.Adapter<MyReviewAdapter.ViewHolder>() {
    var reviewList: ArrayList<MyReviewListResponse.Data> = ArrayList()

    @JvmName("setAdapterList")
    fun setAdapterList(list: ArrayList<MyReviewListResponse.Data>) {
        this.reviewList = ArrayList()
        this.reviewList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val txtTime: TextView = view.findViewById(R.id.txtTime)
        val ratingBar: RatingBar = view.findViewById(R.id.ratingBar)
        val txtDesc: TextView = view.findViewById(R.id.txtDesc)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_my_review, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = reviewList[position]

        holder.txtUserName.text = data.userFullName
        holder.txtTime.text = data.reviewDate
        holder.txtDesc.text = data.feedback

        holder.ratingBar.rating = data.rating.toFloat()

        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .centerCrop()
            .placeholder(R.drawable.placeholder)
            .into(holder.userImg)
    }

    override fun getItemCount(): Int {
        return reviewList.size
    }
}