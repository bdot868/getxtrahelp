package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpuser.R

class RecipientsAdapter(
    private val context: Context,
    val experienceYear: ArrayList<String>,
    val callbacklisten: CallbackListen
) :
    RecyclerView.Adapter<RecipientsAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var tvTitle: TextView = view.findViewById(R.id.tvTitle)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecipientsAdapter.ViewHolder {
        var view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_common, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: RecipientsAdapter.ViewHolder, position: Int) {
        holder.tvTitle.text = experienceYear[position]
        holder.itemView.setOnClickListener(View.OnClickListener {
            callbacklisten.clickItem(experienceYear[position])
        })
    }

    interface CallbackListen {
        fun clickItem(id: String)
    }


    override fun getItemCount(): Int {
        return experienceYear.size
    }
}