package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.CustomView.PhotoFullPopupWindow
import com.app.xtrahelpcaregiver.CustomView.VideoPopupView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.JobDetailResponse
import com.app.xtrahelpcaregiver.Response.Media
import com.bumptech.glide.Glide

class PhotoVideoAdapter(
    private val context: Context,
    val photoVideoList: ArrayList<Media>
) : RecyclerView.Adapter<PhotoVideoAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val img: ImageView = view.findViewById(R.id.img)
        val videoPlay: ImageView = view.findViewById(R.id.videoPlay)
    }


    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): PhotoVideoAdapter.ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_photo_video, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: PhotoVideoAdapter.ViewHolder, position: Int) {
        if (photoVideoList[position].isVideo == "1") {
            holder.videoPlay.visibility = View.VISIBLE
        } else {
            holder.videoPlay.visibility = View.GONE
        }

        Glide.with(context)
            .load(photoVideoList[position].mediaNameThumbUrl)
            .placeholder(R.drawable.main_placeholder)
            .centerCrop()
            .into(holder.img)

        holder.itemView.setOnClickListener { v: View? ->
            if (photoVideoList[position].isVideo == "1") {
                VideoPopupView(context, v, photoVideoList[position].mediaNameUrl)
            } else {
                PhotoFullPopupWindow(
                    context,
                    R.layout.popup_photo_full,
                    v,
                    photoVideoList[position].mediaNameUrl,
                    null
                )
            }
        }
    }

    override fun getItemCount(): Int {
        return photoVideoList.size
    }
}                                                           