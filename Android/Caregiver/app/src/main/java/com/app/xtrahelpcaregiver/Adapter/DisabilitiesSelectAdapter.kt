package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Interface.RemoveClick
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.WorkDisabilitiesWillingType

class DisabilitiesSelectAdapter(
    val context: Context,
    var workDisabilitiesWillingType: ArrayList<WorkDisabilitiesWillingType>,
    var selectedDisabilities: ArrayList<String>
) :
    RecyclerView.Adapter<DisabilitiesSelectAdapter.ViewHolder>() {
    lateinit var removeClick: RemoveClick

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtKeyWord: TextView = view.findViewById(R.id.txtKeyWord)
        val remove: ImageView = view.findViewById(R.id.remove)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view: View =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_filter, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        for (i in workDisabilitiesWillingType.indices) {
            if (selectedDisabilities[position] == workDisabilitiesWillingType[i].workDisabilitiesWillingTypeId) {
                holder.txtKeyWord.setText(workDisabilitiesWillingType[i].name)
            }
        }

            holder.remove.setOnClickListener {
                removeClick.onRemoveDisabilityClick(selectedDisabilities[position])
            }
    }

    override fun getItemCount(): Int {
        return selectedDisabilities.size
    }

    fun removeClick(removeClick: RemoveClick) {
        this.removeClick = removeClick
    }

}