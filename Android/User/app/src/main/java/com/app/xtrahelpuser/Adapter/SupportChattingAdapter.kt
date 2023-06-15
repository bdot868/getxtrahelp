package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Utils.Utils
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.CustomView.PhotoFullPopupWindow
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.TicketChatListResponse
import com.app.xtrahelpuser.Ui.AddJobActivity
import com.app.xtrahelpuser.Utils.CustomDialog
import com.bumptech.glide.Glide
import org.apache.commons.lang3.StringEscapeUtils
import java.util.ArrayList

class SupportChattingAdapter(
    val context: Context,
    val chatList: ArrayList<TicketChatListResponse.Data>
) : RecyclerView.Adapter<SupportChattingAdapter.ViewHolder>() {

    var customDialog = CustomDialog(context)

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val linearLeft: LinearLayout = view.findViewById(R.id.linearLeft)
        val leftMsg: TextView = view.findViewById(R.id.leftMsg)
        val leftTime: TextView = view.findViewById(R.id.leftTime)
        val userImgLeft: ImageView = view.findViewById(R.id.userImgLeft)

        val linearRight: LinearLayout = view.findViewById(R.id.linearRight)
        val rightMsg: TextView = view.findViewById(R.id.rightMsg)
        val rightTime: TextView = view.findViewById(R.id.rightTime)
        val userImgRight: ImageView = view.findViewById(R.id.userImgRight)

        val relativeRightImg: RelativeLayout = view.findViewById(R.id.relativeRightImg)
        val imgRightSide: ImageView = view.findViewById(R.id.imgRightSide)
        val rightImgTime: TextView = view.findViewById(R.id.rightImgTime)

        val relativeLeftImg: RelativeLayout = view.findViewById(R.id.relativeLeftImg)
        val imgLeftSide: ImageView = view.findViewById(R.id.imgLeftSide)
        val leftImgTime: TextView = view.findViewById(R.id.leftImgTime)

    }

    fun addMessage() {
//        utils.dismissProgress()
        notifyItemInserted(chatList.size - 1)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SupportChattingAdapter.ViewHolder {
        var view = LayoutInflater.from(parent.context).inflate(R.layout.adapter_chatting, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: SupportChattingAdapter.ViewHolder, position: Int) {

        holder.imgLeftSide.setOnClickListener { view: View? ->
            PhotoFullPopupWindow(
                context,
                R.layout.popup_photo_full,
                view,
                chatList[position].description,
                null
            )
        }

        holder.imgRightSide.setOnClickListener { view: View? ->
            PhotoFullPopupWindow(
                context,
                R.layout.popup_photo_full,
                view,
                chatList[position].description,
                null
            )
        }


        if (chatList[position].forReply=="1") {
            if (chatList[position].replyType=="1") {
                holder.linearRight.visibility = View.GONE
                holder.linearLeft.visibility = View.VISIBLE
                holder.relativeRightImg.visibility = View.GONE
                holder.relativeLeftImg.visibility = View.GONE
                holder.leftMsg.text = StringEscapeUtils.unescapeJava(chatList[position].description)
                holder.leftTime.text = chatList[position].time

                Glide.with(context)
                    .load(chatList[position].thumbprofileimage)
                    .centerCrop()
                    .placeholder(R.drawable.placeholder)
                    .into(holder.userImgLeft)

            } else {
                holder.linearRight.visibility = View.GONE
                holder.linearLeft.visibility = View.GONE
                holder.relativeRightImg.visibility = View.GONE
                holder.relativeLeftImg.visibility = View.VISIBLE
                Glide.with(context)
                    .load(chatList[position].description)
                    .placeholder(R.drawable.main_placeholder)
                    .centerCrop()
                    .into(holder.imgLeftSide)
                holder.leftImgTime.text = chatList[position].createdDate
            }
        } else {
            if (chatList[position].replyType=="1") {
                holder.linearRight.visibility = View.VISIBLE
                holder.linearLeft.visibility = View.GONE
                holder.relativeRightImg.visibility = View.GONE
                holder.relativeLeftImg.visibility = View.GONE
                holder.rightMsg.text =
                    StringEscapeUtils.unescapeJava(chatList[position].description)
                holder.rightTime.text = chatList[position].time

                Glide.with(context)
                    .load(chatList[position].thumbprofileimage)
                    .centerCrop()
                    .placeholder(R.drawable.placeholder)
                    .into(holder.userImgRight)
                
            } else {
                holder.linearRight.visibility = View.GONE
                holder.linearLeft.visibility = View.GONE
                holder.relativeRightImg.visibility = View.VISIBLE
                holder.relativeLeftImg.visibility = View.GONE
                Glide.with(context)
                    .load(chatList[position].description)
                    .placeholder(R.drawable.main_placeholder)
                    .centerCrop()
                    .into(holder.imgRightSide)
                holder.rightImgTime.text = chatList[position].time
            }
        }
    }

    override fun getItemCount(): Int {
        return chatList.size
    }
}