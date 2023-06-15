package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.CustomView.PhotoFullPopupWindow
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.ChatListResponse
import com.app.xtrahelpcaregiver.Ui.CaregiverProfileActivity
import com.app.xtrahelpcaregiver.Ui.FileOpenActivity
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.Pref
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.bumptech.glide.Glide
import com.google.gson.Gson
import com.google.gson.JsonElement
import org.apache.commons.lang3.StringEscapeUtils
import org.json.JSONObject
import org.json.JSONTokener


class ChattingAdapter(
    val context: Context, val chatList: ArrayList<ChatListResponse.Data> = ArrayList()
) : RecyclerView.Adapter<ChattingAdapter.ViewHolder>() {

    fun addMessage() {
        notifyDataSetChanged()
//        notifyItemInserted(chatList.size - 1)
    }

    val pref = Pref(context)

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

        val relativeRightFile: RelativeLayout = view.findViewById(R.id.relativeRightFile)
        val txtDocName: TextView = view.findViewById(R.id.txtDocName)
        val txtAttachTimeRight: TextView = view.findViewById(R.id.txtAttachTimeRight)

        val relativeRightCaregiver: RelativeLayout = view.findViewById(R.id.relativeRightCaregiver)
        val txtNameRight: TextView = view.findViewById(R.id.txtNameRight)
        val txtCategoryRight: TextView = view.findViewById(R.id.txtCategoryRight)
        val txtJobCompleteRight: TextView = view.findViewById(R.id.txtJobCompleteRight)
        val txtAvailableTimeRight: TextView = view.findViewById(R.id.txtAvailableTimeRight)
        val txtReferTimeRight: TextView = view.findViewById(R.id.txtReferTimeRight)
        val caregiverImgRight: ImageView = view.findViewById(R.id.caregiverImgRight)
        val ratingBarRight: RatingBar = view.findViewById(R.id.ratingBarRight)
        val userImageRightImage: ImageView = view.findViewById(R.id.userImageRightImage)
        val userImgLeftImage: ImageView = view.findViewById(R.id.userImgLeftImage)
        val userImgRefer: ImageView = view.findViewById(R.id.userImgRefer)
        val userImgAttach: ImageView = view.findViewById(R.id.userImgAttach)
    }


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        var view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_chatting, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.relativeRightFile.setOnClickListener {
//            val browserIntent = Intent(
//                Intent.ACTION_VIEW,
//                Uri.parse(RetrofitClient.IMAGE_URL + chatList[position].message)
//            )
//            startActivity(context, browserIntent, null)

            context.startActivity(
                Intent(context, FileOpenActivity::class.java)
                    .putExtra(
                        FileOpenActivity.EXTRA_FILE_URL,
                        RetrofitClient.IMAGE_URL + chatList[position].message
                    )
                    .putExtra(FileOpenActivity.EXTRA_FILE_NAME, chatList[position].message)
            )
        }

        holder.imgLeftSide.setOnClickListener { view: View? ->
            PhotoFullPopupWindow(
                context,
                R.layout.popup_photo_full,
                view,
                RetrofitClient.IMAGE_URL + chatList[position].message,
                null
            )
        }

        holder.imgRightSide.setOnClickListener { view: View? ->
            PhotoFullPopupWindow(
                context,
                R.layout.popup_photo_full,
                view,
                RetrofitClient.IMAGE_URL + chatList[position].message,
                null
            )
        }


        if (chatList[position].sender == pref.getString(Const.id)) {
            if (chatList[position].type == "1") {
                holder.relativeRightFile.visibility = View.GONE
                holder.relativeRightCaregiver.visibility = View.GONE
                holder.linearRight.visibility = View.VISIBLE
                holder.linearLeft.visibility = View.GONE
                holder.relativeLeftImg.visibility = View.GONE
                holder.relativeRightImg.visibility = View.GONE
                holder.rightMsg.text = StringEscapeUtils.unescapeJava(chatList[position].message)
//                holder.rightTime.setText(GetTimeAgo.getTimeAgo(arrayChatList.get(position).getCreatedDate().toLong()))
                holder.rightTime.text = chatList[position].time

                Glide.with(context)
                    .load(chatList[position].senderImage)
                    .centerCrop()
                    .placeholder(R.drawable.main_placeholder)
                    .into(holder.userImgRight)

            } else if (chatList[position].type == "2") {
                holder.relativeRightFile.visibility = View.GONE
                holder.relativeRightCaregiver.visibility = View.GONE
                holder.linearRight.visibility = View.GONE
                holder.linearLeft.visibility = View.GONE
                holder.relativeLeftImg.visibility = View.GONE
                holder.relativeRightImg.visibility = View.VISIBLE

                Glide.with(context)
                    .load(RetrofitClient.IMAGE_URL + chatList[position].message)
                    .centerCrop()
                    .placeholder(R.drawable.main_placeholder)
                    .into(holder.imgRightSide)

                Glide.with(context)
                    .load(chatList[position].senderImage)
                    .centerCrop()
                    .placeholder(R.drawable.main_placeholder)
                    .into(holder.userImageRightImage)

//                    holder.rightImgTime.setText(GetTimeAgo.getTimeAgo(arrayChatList.get(position).getCreatedDate().toLong()))
                holder.rightImgTime.text = chatList[position].time

            } else if (chatList[position].type == "4") {
                holder.relativeRightFile.visibility = View.GONE
                holder.relativeRightCaregiver.visibility = View.VISIBLE
                holder.linearRight.visibility = View.GONE
                holder.linearLeft.visibility = View.GONE
                holder.relativeLeftImg.visibility = View.GONE
                holder.relativeRightImg.visibility = View.GONE

                holder.txtReferTimeRight.text = chatList[position].time

                Glide.with(context)
                    .load(chatList[position].senderImage)
                    .placeholder(R.drawable.placeholder)
                    .centerCrop()
                    .into(holder.userImgRefer)

                val invitedUser: JsonElement = chatList[position].suggestedProvider
                var json: Any? = null

                try {
                    json = JSONTokener(invitedUser.toString()).nextValue()
                    if (json is JSONObject) {
                        val extraDataString = Gson().toJson(json)
                        val cargiverDetail: ChatListResponse.suggestedProvider = Gson().fromJson(
                            json.toString(),
                            ChatListResponse.suggestedProvider::class.java
                        )
                        holder.txtNameRight.text = cargiverDetail.fullName
                        holder.txtCategoryRight.text = cargiverDetail.categoryNames
                        holder.ratingBarRight.rating = cargiverDetail.ratingAverage.toFloat()
                        holder.txtJobCompleteRight.text = cargiverDetail.totalJobCompleted + " Jobs"

                        holder.relativeRightCaregiver.setOnClickListener {
                            context.startActivity(
                                Intent(context, CaregiverProfileActivity::class.java)
                                    .putExtra(CaregiverProfileActivity.CAREGIVERID, cargiverDetail.id)
                            )
                        }
                        
                        Glide.with(context)
                            .load(cargiverDetail.profileImageThumbUrl)
                            .placeholder(R.drawable.placeholder)
                            .centerCrop()
                            .into(holder.caregiverImgRight)

                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            } else if (chatList[position].type == "5") {
                holder.relativeRightCaregiver.visibility = View.GONE
                holder.relativeRightFile.visibility = View.VISIBLE
                holder.linearRight.visibility = View.GONE
                holder.linearLeft.visibility = View.GONE
                holder.relativeLeftImg.visibility = View.GONE
                holder.relativeRightImg.visibility = View.GONE

                holder.txtDocName.text = chatList[position].attachmentRealName
                holder.txtAttachTimeRight.text = chatList[position].time

                Glide.with(context)
                    .load(chatList[position].senderImage)
                    .placeholder(R.drawable.placeholder)
                    .centerCrop()
                    .into(holder.userImgAttach)

            }
        } else {
            if (chatList[position].type == "1") {
                holder.relativeRightFile.visibility = View.GONE
                holder.relativeRightCaregiver.visibility = View.GONE
                holder.linearRight.visibility = View.GONE
                holder.linearLeft.visibility = View.VISIBLE
                holder.relativeLeftImg.visibility = View.GONE
                holder.relativeRightImg.visibility = View.GONE

                holder.leftMsg.text =
                    StringEscapeUtils.unescapeJava(chatList[position].message)
                holder.leftTime.text = chatList[position].time
//                holder.leftTime.setText(GetTimeAgo.getTimeAgo(arrayChatList.get(position).getCreatedDate().toLong()))

                Glide.with(context)
                    .load(chatList[position].senderImage)
                    .centerCrop()
                    .placeholder(R.drawable.main_placeholder)
                    .into(holder.userImgLeft)

            } else if (chatList[position].type == "2") {
                holder.relativeRightFile.visibility = View.GONE
                holder.relativeRightCaregiver.visibility = View.GONE
                holder.linearRight.visibility = View.GONE
                holder.linearLeft.visibility = View.GONE
                holder.relativeLeftImg.visibility = View.VISIBLE
                holder.relativeRightImg.visibility = View.GONE

                Glide.with(context)
                    .load(RetrofitClient.IMAGE_URL + chatList[position].message)
                    .centerCrop()
                    .placeholder(R.drawable.main_placeholder)
                    .into(holder.imgLeftSide)

                Glide.with(context)
                    .load(chatList[position].senderImage)
                    .centerCrop()
                    .placeholder(R.drawable.main_placeholder)
                    .into(holder.userImgLeftImage)

                holder.leftImgTime.text = chatList[position].time
            }
        }

    }

    override fun getItemCount(): Int {
        return chatList.size
    }
}