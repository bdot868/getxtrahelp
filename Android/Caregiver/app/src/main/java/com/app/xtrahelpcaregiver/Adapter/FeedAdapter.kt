package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.appcompat.widget.AppCompatCheckBox
import androidx.appcompat.widget.PopupMenu
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.CustomView.PhotoFullPopupWindow
import com.app.xtrahelpcaregiver.CustomView.VideoPopupView
import com.app.xtrahelpcaregiver.Interface.FeedLikeUnlikeClickListener
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.FeedListResponse
import com.app.xtrahelpcaregiver.Ui.CommentActivity
import com.app.xtrahelpcaregiver.Ui.CreateFeedActivity
import com.app.xtrahelpcaregiver.Ui.LikeListActivity
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.Pref
import com.app.xtrahelpuser.Interface.ReportFeedClickListener
import com.bumptech.glide.Glide
import org.apache.commons.lang3.CharSetUtils.delete
import org.apache.commons.lang3.StringEscapeUtils

class FeedAdapter(private val context: Context) : RecyclerView.Adapter<FeedAdapter.ViewHolder>() {
    var feedList: ArrayList<FeedListResponse.Data> = ArrayList()
    lateinit var subPhotoVideoAdapter: SubPhotoVideoAdapter
    lateinit var pref: Pref
    lateinit var feedLikeUnlikeClickListener: FeedLikeUnlikeClickListener
    lateinit var reportFeedClickListener: ReportFeedClickListener

    @JvmName("setAdapterList")
    fun setAdapterList(list: ArrayList<FeedListResponse.Data>) {
        this.feedList = ArrayList()
        this.feedList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var linearComment: LinearLayout = view.findViewById(R.id.linearComment)
        var txtLike: TextView = view.findViewById(R.id.txtLike)
        var txtUserName: TextView = view.findViewById(R.id.txtUserName)
        var txtTime: TextView = view.findViewById(R.id.txtTime)
        var userImg: ImageView = view.findViewById(R.id.userImg)
        var recyclerPhotoVideo: RecyclerView = view.findViewById(R.id.recyclerPhotoVideo)
        var singleImage: ImageView = view.findViewById(R.id.singleImage)
        var txtComment: TextView = view.findViewById(R.id.txtComment)
        var checkLike: AppCompatCheckBox = view.findViewById(R.id.checkLike)
        var moreImg: ImageView = view.findViewById(R.id.moreImg)
        var txtDesc: TextView = view.findViewById(R.id.txtDesc)
        var relativeMedia: RelativeLayout = view.findViewById(R.id.relativeMedia)
        var relativeSingleVideo: RelativeLayout = view.findViewById(R.id.relativeSingleVideo)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.adapter_feed, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        pref = Pref(context)
        val data = feedList[position]

        if (data.media.isEmpty()) {
            holder.relativeMedia.visibility = View.GONE
            holder.relativeSingleVideo.visibility = View.GONE
            holder.recyclerPhotoVideo.visibility = View.GONE
        } else if (data.media.size > 1) {
            holder.relativeMedia.visibility = View.VISIBLE
            holder.singleImage.visibility = View.GONE
            holder.recyclerPhotoVideo.visibility = View.VISIBLE
            holder.relativeSingleVideo.visibility = View.GONE

            subPhotoVideoAdapter = SubPhotoVideoAdapter(context, data.media)
            holder.recyclerPhotoVideo.layoutManager =
                LinearLayoutManager(context, RecyclerView.HORIZONTAL, false)
            holder.recyclerPhotoVideo.isNestedScrollingEnabled = false
            holder.recyclerPhotoVideo.adapter = subPhotoVideoAdapter
        } else {
            holder.relativeMedia.visibility = View.VISIBLE
            holder.recyclerPhotoVideo.visibility = View.GONE
            holder.singleImage.visibility = View.VISIBLE

            Glide.with(context)
                .load(data.media[0].mediaNameUrl)
                .placeholder(R.drawable.main_placeholder)
                .centerCrop()
                .into(holder.singleImage)

            if (data.media[0].isVideo == "0") {
                holder.relativeSingleVideo.visibility = View.GONE
            } else {
                holder.relativeSingleVideo.visibility = View.VISIBLE
            }
        }

        holder.txtDesc.text = StringEscapeUtils.unescapeJava(data.description)
        holder.txtComment.text = data.totalFeedComment
        holder.txtLike.text = data.totalFeedLike
        holder.txtUserName.text = data.userFullName
        holder.txtTime.text = data.createdTime

        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .placeholder(R.drawable.main_placeholder)
            .centerCrop()
            .into(holder.userImg)

        holder.checkLike.isChecked = data.isLike == "1"

        holder.linearComment.setOnClickListener(View.OnClickListener {
            context.startActivity(Intent(context, CommentActivity::class.java)
                .putExtra(CommentActivity.USERFEEDID,data.userFeedId))
        })

        holder.txtLike.setOnClickListener(View.OnClickListener {
            context.startActivity(
                Intent(context, LikeListActivity::class.java)
                    .putExtra(LikeListActivity.FEEDID, data.userFeedId)
            )
        })

        holder.singleImage.setOnClickListener { v: View? ->
            if (data.media[0].isVideo == "1") {
                VideoPopupView(context, v, data.media[0].mediaNameUrl)
            } else {
                PhotoFullPopupWindow(
                    context,
                    R.layout.popup_photo_full,
                    v,
                    data.media[0].mediaNameUrl,
                    null
                )
            }
        }

        holder.moreImg.setOnClickListener { v: View? ->
            if (feedList[position].userId == pref.getString(Const.id)) {
                val popup = PopupMenu(context, holder.moreImg)
                popup.menuInflater.inflate(R.menu.post_job_more_option, popup.menu)
                popup.setOnMenuItemClickListener { item: MenuItem ->
                    if (item.title == context.resources.getString(R.string.edit)) {
                        context.startActivity(
                            Intent(context, CreateFeedActivity::class.java)
                                .putExtra(CreateFeedActivity.IS_EDIT, true)
                                .putExtra(CreateFeedActivity.FEEDID, feedList[position].userFeedId)
                                .putExtra(CreateFeedActivity.DESCRIPTION, feedList[position].description)
                                .putParcelableArrayListExtra("mediaList", ArrayList(data.media))
                        )
                    } else if (item.title == context.resources
                            .getString(R.string.delete)
                    ) {
                        reportFeedClickListener.deleteFeedClick(feedList[position].userFeedId,position)
                    }
                    true
                }
                popup.show()
            } else {
                val popup = PopupMenu(context, holder.moreImg)
                popup.menuInflater.inflate(R.menu.post_report, popup.menu)
                popup.setOnMenuItemClickListener { item: MenuItem ->
                    if (item.title == context.resources.getString(R.string.report)) {
                        reportFeedClickListener.reportClick(feedList[position].userFeedId)
                    }
                    true
                }
                popup.show()
            }
        }

        holder.checkLike.setOnClickListener {
            if (holder.checkLike.isChecked) {
                feedLikeUnlikeClickListener.onFeedLikeUnlikeClick(data.userFeedId, position, true)
            } else {
                feedLikeUnlikeClickListener.onFeedLikeUnlikeClick(data.userFeedId, position, false)
            }
        }
    }


    override fun getItemCount(): Int {
        return feedList.size
    }

    fun feedLikeUnlikeClickListener(feedLikeUnlikeClickListener: FeedLikeUnlikeClickListener) {
        this.feedLikeUnlikeClickListener = feedLikeUnlikeClickListener
    }

    fun reportFeedClickListener(reportFeedClickListener: ReportFeedClickListener) {
        this.reportFeedClickListener = reportFeedClickListener;
    }
}