package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.widget.PopupMenu
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Interface.CommentDeleteReportClickListener
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.CommentListResponse
import com.app.xtrahelpcaregiver.Response.FeedLikeListResponse
import com.app.xtrahelpcaregiver.Ui.CreateFeedActivity
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.Pref
import com.bumptech.glide.Glide
import org.apache.commons.lang3.StringEscapeUtils

class CommentAdapter(private var context: Context) :
    RecyclerView.Adapter<CommentAdapter.ViewHolder>() {

    var commentList: ArrayList<CommentListResponse.Data> = ArrayList()
    lateinit var pref: Pref

    lateinit var commentDeleteReportClickListener: CommentDeleteReportClickListener

    @JvmName("setAdapterList")
    fun setAdapterList(list: ArrayList<CommentListResponse.Data>) {
        this.commentList = ArrayList()
        this.commentList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val moreImg: ImageView = view.findViewById(R.id.moreImg)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val txtTime: TextView = view.findViewById(R.id.txtTime)
        val txtComment: TextView = view.findViewById(R.id.txtComment)

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CommentAdapter.ViewHolder {
        val view: View =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_comment, parent, false)
        return ViewHolder(view);
    }

    override fun onBindViewHolder(holder: CommentAdapter.ViewHolder, position: Int) {
        pref = Pref(context)
        val data = commentList[position]

        holder.txtUserName.text = data.userFullName
        holder.txtTime.text = data.time_ago
        holder.txtComment.text = StringEscapeUtils.unescapeJava(data.comment)

        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .placeholder(R.drawable.main_placeholder)
            .centerCrop()
            .into(holder.userImg)

        holder.moreImg.setOnClickListener { v: View? ->
            if (data.userId == pref.getString(Const.id)) {
                val popup = PopupMenu(context, holder.moreImg)
                popup.menuInflater.inflate(R.menu.delete_comment, popup.menu)
                popup.setOnMenuItemClickListener { item: MenuItem ->
                    if (item.title == context.resources.getString(R.string.delete)) {
                        commentDeleteReportClickListener.deleteCommentClick(data.id, position)
                    }
                    true
                }
                popup.show()
            } else {
                val popup = PopupMenu(context, holder.moreImg)
                popup.menuInflater.inflate(R.menu.post_report, popup.menu)
                popup.setOnMenuItemClickListener { item: MenuItem ->
                    if (item.title == context.resources.getString(R.string.report)) {
                        commentDeleteReportClickListener.reportCommentClick(data.id)
                    }
                    true
                }
                popup.show()
            }
        }
    }

    override fun getItemCount(): Int {
        return commentList.size
    }

    fun onReportDeleteClick(commentDeleteReportClickListener: CommentDeleteReportClickListener) {
        this.commentDeleteReportClickListener = commentDeleteReportClickListener
    }
}