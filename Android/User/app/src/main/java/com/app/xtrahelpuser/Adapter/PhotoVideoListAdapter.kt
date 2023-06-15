package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.CustomView.PhotoFullPopupWindow
import com.app.xtrahelpuser.CustomView.VideoPopupView
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.PostedJobDetailResponse
import com.app.xtrahelpuser.Ui.AddJobActivity
import com.bumptech.glide.Glide


class PhotoVideoListAdapter(
    private val context: Context,
    val photoVideoList: ArrayList<PostedJobDetailResponse.Data.Media>
) : RecyclerView.Adapter<PhotoVideoListAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val img: ImageView = view.findViewById(R.id.img)
        val videoPlay: ImageView = view.findViewById(R.id.videoPlay)
    }


    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): PhotoVideoListAdapter.ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_photo_video_list, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: PhotoVideoListAdapter.ViewHolder, position: Int) {
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