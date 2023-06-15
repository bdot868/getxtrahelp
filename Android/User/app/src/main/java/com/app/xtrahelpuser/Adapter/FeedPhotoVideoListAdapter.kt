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
import com.app.xtrahelpuser.Interface.RemovePhotoVideo
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.Media
import com.app.xtrahelpuser.Request.SaveFeedRequest
import com.app.xtrahelpuser.Response.PostedJobDetailResponse
import com.app.xtrahelpuser.Ui.AddJobActivity
import com.bumptech.glide.Glide


class FeedPhotoVideoListAdapter(
    private val context: Context,
    val photoVideoList: ArrayList<Media>
) : RecyclerView.Adapter<FeedPhotoVideoListAdapter.ViewHolder>() {
    lateinit var removePhoVideoClick: RemovePhotoVideo

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val img: ImageView = view.findViewById(R.id.img)
        val videoPlay: ImageView = view.findViewById(R.id.videoPlay)
        val removeImg: ImageView = view.findViewById(R.id.removeImg)
    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_photo_video_list, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.removeImg.visibility = View.VISIBLE

        if (photoVideoList[position].videoImage == "") {
            holder.videoPlay.visibility = View.GONE
            Glide.with(context)
                .load(RetrofitClient.IMAGE_URL + photoVideoList[position].mediaName)
                .placeholder(R.drawable.main_placeholder)
                .centerCrop()
                .into(holder.img)
        } else {
            holder.videoPlay.visibility = View.VISIBLE
            Glide.with(context)
                .load(RetrofitClient.IMAGE_URL + photoVideoList[position].videoImage)
                .placeholder(R.drawable.main_placeholder)
                .centerCrop()
                .into(holder.img)
        }

        holder.itemView.setOnClickListener { v: View? ->
            if (photoVideoList[position].videoImage != "") {
                VideoPopupView(
                    context,
                    v,
                    RetrofitClient.IMAGE_URL + photoVideoList[position].mediaName
                )
            } else {
                PhotoFullPopupWindow(
                    context,
                    R.layout.popup_photo_full,
                    v,
                    RetrofitClient.IMAGE_URL + photoVideoList[position].mediaName,
                    null
                )
            }
        }

        holder.removeImg.setOnClickListener {
            removePhoVideoClick.removePhotoVideo(photoVideoList[position])
        }
    }

    override fun getItemCount(): Int {
        return photoVideoList.size
    }

    fun removePhoVideoClick(removePhoVideoClick: RemovePhotoVideo) {
        this.removePhoVideoClick = removePhoVideoClick
    }
}