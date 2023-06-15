package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.HearAboutUs
import com.app.xtrahelpuser.R

class HereAboutAdapter(
    private val context: Context,
    val hearAboutUs: ArrayList<HearAboutUs>,
    val callbacklisten: CallbackListen
) :
    RecyclerView.Adapter<HereAboutAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var tvTitle: TextView = view.findViewById(R.id.tvTitle)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): HereAboutAdapter.ViewHolder {
        var view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_common, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: HereAboutAdapter.ViewHolder, position: Int) {
        holder.tvTitle.text = hearAboutUs[position].name
        holder.itemView.setOnClickListener(View.OnClickListener {
            callbacklisten.clickItem(hearAboutUs[position].hearAboutUsId)
        })
    }

    interface CallbackListen {
        fun clickItem(id: String)
    }


    override fun getItemCount(): Int {
        return hearAboutUs.size
    }
}