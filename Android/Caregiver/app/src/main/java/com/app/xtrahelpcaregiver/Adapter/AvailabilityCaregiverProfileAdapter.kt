package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.CaregiverAvailabilityResponse

class AvailabilityCaregiverProfileAdapter(
    val context: Context,
    val slotList: ArrayList<CaregiverAvailabilityResponse.Data.Slot>
) : RecyclerView.Adapter<AvailabilityCaregiverProfileAdapter.ViewHolder>() {


    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val card: CardView = view.findViewById(R.id.card)
        val txtTime: TextView = view.findViewById(R.id.txtTime)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.adapter_time, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = slotList[position]

        if (data.isBooked == "0") {
            holder.card.setCardBackgroundColor(context.resources.getColor(R.color.txtPurple))
            holder.txtTime.setTextColor(context.resources.getColor(R.color.white))
        } else {
            holder.card.setCardBackgroundColor(context.resources.getColor(R.color.txtLightPurple))
            holder.txtTime.setTextColor(context.resources.getColor(R.color.lightWhite))
        }

        holder.txtTime.text = data.time

    }

    override fun getItemCount(): Int {
        return slotList.size
    }
}