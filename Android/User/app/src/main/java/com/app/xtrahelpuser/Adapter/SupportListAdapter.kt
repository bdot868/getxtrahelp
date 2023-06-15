package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.Interface.ReopenClicklistner
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.Ticket
import com.app.xtrahelpuser.Ui.SupportChatActivity
import java.util.ArrayList

class SupportListAdapter(val context: Context) :
    RecyclerView.Adapter<SupportListAdapter.ViewHolder>() {

    var supportList: ArrayList<Ticket> = ArrayList<Ticket>()

    lateinit var reopenClicklistner: ReopenClicklistner

    @JvmName("setFaqList1")
    fun setPage(arrayList: ArrayList<Ticket>) {
        this.supportList = ArrayList()
        this.supportList.addAll(arrayList)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtTitle: TextView = view.findViewById(R.id.txtTitle)
        val txtDesc: TextView = view.findViewById(R.id.txtDesc)
        val txtTime: TextView = view.findViewById(R.id.txtTime)
        val txtReopen: TextView = view.findViewById(R.id.txtReopen)
        val dot: ImageView = view.findViewById(R.id.dot)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_support_list, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.txtTitle.text = supportList[position].title
        holder.txtDesc.text = supportList[position].description
        holder.txtTime.text = supportList[position].lastMsgTime

        if (supportList[position].status == "0") {
            holder.dot.setImageDrawable(context.resources.getDrawable(R.drawable.red_dot))
            holder.txtReopen.visibility = View.VISIBLE
        } else {
            holder.dot.setImageDrawable(context.resources.getDrawable(R.drawable.green_dot))
            holder.txtReopen.visibility = View.GONE
        }

        holder.itemView.setOnClickListener(View.OnClickListener {
            context.startActivity(Intent(context, SupportChatActivity::class.java)
                .putExtra(SupportChatActivity.TICKET_ID, supportList[position].id)
            )
        })

        holder.txtReopen.setOnClickListener {
            reopenClicklistner.onReopenClick(supportList[position].id)
        }
    }

    override fun getItemCount(): Int {
        return supportList.size
    }

    fun reopenClicklistner(reopenClicklistner: ReopenClicklistner) {
        this.reopenClicklistner = reopenClicklistner
    }
}