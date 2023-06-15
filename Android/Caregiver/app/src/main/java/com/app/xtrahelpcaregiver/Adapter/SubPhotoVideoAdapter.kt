package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RelativeLayout
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.CustomView.PhotoFullPopupWindow
import com.app.xtrahelpcaregiver.CustomView.VideoPopupView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.FeedListResponse
import com.bumptech.glide.Glide

class SubPhotoVideoAdapter(
    val context: Context,
    val mediaList: ArrayList<FeedListResponse.Data.Media> = ArrayList()
) :
    RecyclerView.Adapter<SubPhotoVideoAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val relativeVideo: RelativeLayout = view.findViewById(R.id.relativeVideo)
        val singleImage: ImageView = view.findViewById(R.id.singleImage)
        val playImg: ImageView = view.findViewById(R.id.playImg)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_sub_photo_video, parent, false)
        return ViewHolder(view)
    }


    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = mediaList[position]
        if (data.isVideo == "0") {
            holder.relativeVideo.visibility = View.GONE
        } else {
            holder.relativeVideo.visibility = View.VISIBLE
        }

        Glide.with(context)
            .load(data.mediaNameUrl)
            .placeholder(R.drawable.main_placeholder)
            .centerCrop()
            .into(holder.singleImage)

        holder.itemView.setOnClickListener { v: View? ->
            if (data.isVideo == "1") {
                VideoPopupView(context, v, data.mediaNameUrl)
            } else {
                PhotoFullPopupWindow(
                    context,
                    R.layout.popup_photo_full,
                    v,
                    data.mediaNameUrl,
                    null
                )
            }
        }

    }

    override fun getItemCount(): Int {
        return mediaList.size
    }
}