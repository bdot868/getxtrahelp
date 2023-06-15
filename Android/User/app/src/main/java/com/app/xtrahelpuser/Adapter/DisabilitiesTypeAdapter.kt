package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.LicenceType
import com.app.xtrahelpcaregiver.Response.LovedDisabilitiesType
import com.app.xtrahelpuser.R


class DisabilitiesTypeAdapter(
    private val context: Context,
    val lovedDisabilitiesTypeList: ArrayList<LovedDisabilitiesType>,
    val callbacklisten: CallbackListen
) :
    RecyclerView.Adapter<DisabilitiesTypeAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var tvTitle: TextView = view.findViewById(R.id.tvTitle)
    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): DisabilitiesTypeAdapter.ViewHolder {
        var view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_common, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: DisabilitiesTypeAdapter.ViewHolder, position: Int) {
        holder.tvTitle.text = lovedDisabilitiesTypeList[position].name
        holder.itemView.setOnClickListener(View.OnClickListener {
            callbacklisten.clickItem(lovedDisabilitiesTypeList[position].lovedDisabilitiesTypeId)
        })
    }

    interface CallbackListen {
        fun clickItem(id: String)
    }


    override fun getItemCount(): Int {
        return lovedDisabilitiesTypeList.size
    }
}