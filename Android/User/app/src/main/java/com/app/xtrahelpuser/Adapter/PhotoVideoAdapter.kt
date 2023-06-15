package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.media.Image
import android.view.LayoutInflater
import android.view.View
import android.view.View.GONE
import android.view.View.VISIBLE
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.CustomView.PhotoFullPopupWindow
import com.app.xtrahelpuser.CustomView.VideoPopupView
import com.app.xtrahelpuser.Interface.RemovePhotoVideo
import com.app.xtrahelpuser.Interface.SelectImageVideoClick
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.additionalQuestions
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.media
import com.bumptech.glide.Glide
import com.chauthai.swipereveallayout.ViewBinderHelper
import java.util.ArrayList


class PhotoVideoAdapter(
    private val context: Context
) : RecyclerView.Adapter<PhotoVideoAdapter.ViewHolder>() {

    lateinit var selectImageVideoClick: SelectImageVideoClick
    private val viewBinderHelper = ViewBinderHelper()

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val addImg: ImageView = view.findViewById(R.id.addImg)
        val linear: LinearLayout = view.findViewById(R.id.linear)
        val image: ImageView = view.findViewById(R.id.image)
        val removeImg: ImageView = view.findViewById(R.id.removeImg)
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


        if (media[position].mediaName == "123") {
            holder.addImg.visibility = VISIBLE
            holder.linear.visibility = GONE
        } else {
            holder.addImg.visibility = GONE
            holder.linear.visibility = VISIBLE

            Glide.with(context)
                .load(RetrofitClient.IMAGE_URL + media[position].mediaName)
                .placeholder(R.drawable.main_placeholder)
                .centerCrop()
                .into(holder.image)
        }

        if (media[position].mediaName.contains(".mp4")) {
            holder.videoPlay.visibility = VISIBLE
        } else {
            holder.videoPlay.visibility = GONE
        }

        holder.itemView.setOnClickListener(View.OnClickListener { v: View? ->
            if(media[position].mediaName !="123"){
                if (media[position].mediaName.contains(".mp4")) {
                    VideoPopupView(context, v, RetrofitClient.IMAGE_URL + media[position].mediaName)
                } else {
                    PhotoFullPopupWindow(
                        context,
                        R.layout.popup_photo_full,
                        v,
                        RetrofitClient.IMAGE_URL + media[position].mediaName,
                        null
                    )
                }
            }
        })

        holder.addImg.setOnClickListener {
            selectImageVideoClick.onSelectImageClick(position)
        }

        holder.removeImg.setOnClickListener{
            media.remove(media[position])
            notifyDataSetChanged()
        }
    }

    override fun getItemCount(): Int {
        return media.size
    }

    fun selectImageVideoClick(selectImageVideoClick: SelectImageVideoClick) {
        this.selectImageVideoClick = selectImageVideoClick
    }
}