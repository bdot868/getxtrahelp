package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.FeedLikeListResponse
import com.bumptech.glide.Glide

class LikeAdapter(private val context: Context) : RecyclerView.Adapter<LikeAdapter.ViewHolder>() {

    var userLikeList: ArrayList<FeedLikeListResponse.Data> = ArrayList()

    @JvmName("setAdapterList")
    fun setAdapterList(list: ArrayList<FeedLikeListResponse.Data>) {
        this.userLikeList = ArrayList()
        this.userLikeList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val userImg: ImageView = view.findViewById(R.id.userImg)

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): LikeAdapter.ViewHolder {
        val view: View =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_like, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: LikeAdapter.ViewHolder, position: Int) {
        holder.txtUserName.text = userLikeList[position].userFullName
        Glide.with(context)
            .load(userLikeList[position].profileImageThumbUrl)
            .placeholder(R.drawable.placeholder)
            .centerCrop()
            .into(holder.userImg)
    }

    override fun getItemCount(): Int {
        return userLikeList.size
    }
}