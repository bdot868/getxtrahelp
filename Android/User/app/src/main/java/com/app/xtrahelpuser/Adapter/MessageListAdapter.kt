package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.Interface.RemoveClick
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.ChatInBoxResponse
import com.app.xtrahelpuser.Ui.ChattingActivity
import com.bumptech.glide.Glide
import com.chauthai.swipereveallayout.SwipeRevealLayout
import com.chauthai.swipereveallayout.ViewBinderHelper
import org.apache.commons.lang3.StringEscapeUtils

class MessageListAdapter(
    val context: Context,
    val chatInBoxList: ArrayList<ChatInBoxResponse.Data>
) :
    RecyclerView.Adapter<MessageListAdapter.ViewHolder>() {
    lateinit var removeClick: RemoveClick
    private val viewBinderHelper = ViewBinderHelper()

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val cardView: CardView = view.findViewById(R.id.cardView)
        val swipeReveal: SwipeRevealLayout = view.findViewById(R.id.swipeReveal)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val txtMessage: TextView = view.findViewById(R.id.txtMessage)
        val txtTime: TextView = view.findViewById(R.id.txtTime)
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val caredDelete: CardView = view.findViewById(R.id.caredDelete)
        val yellowDot: ImageView = view.findViewById(R.id.yellowDot)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_message, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.cardView.setOnClickListener {
            context.startActivity(
                Intent(context, ChattingActivity::class.java)
                    .putExtra(ChattingActivity.ID, chatInBoxList[position].id)
                    .putExtra(ChattingActivity.FROMCHATLIST, true)
            )
        }

        viewBinderHelper.setOpenOnlyOne(true)
        viewBinderHelper.bind(holder.swipeReveal, chatInBoxList[position].id);

        holder.txtUserName.text = chatInBoxList[position].name
        holder.txtMessage.text = StringEscapeUtils.unescapeJava(chatInBoxList[position].message)
        holder.txtTime.text = chatInBoxList[position].time
        Glide.with(context)
            .load(chatInBoxList[position].thumbImage)
            .centerCrop()
            .placeholder(R.drawable.placeholder)
            .into(holder.userImg)

        if (chatInBoxList[position].unreadMessages.isEmpty()) {
            holder.yellowDot.visibility = View.GONE
        } else {
            holder.yellowDot.visibility = View.VISIBLE
        }
        
        holder.caredDelete.setOnClickListener {
            removeClick.onRemoveDisabilityClick(chatInBoxList[position].id)
        }
    }

    override fun getItemCount(): Int {
        return chatInBoxList.size
    }

    fun setOnRemoveClick(removeClick: RemoveClick) {
        this.removeClick = removeClick
    }
}