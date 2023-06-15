package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.widget.AppCompatCheckBox
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Interface.DisabilitiesClickListener
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Ui.BlogDetailsActivity
import com.app.xtrahelpcaregiver.Utils.Utils

class DisabilitiesAdapter(
    private val context: Context,
    val workDisabilitiesWillingType: ArrayList<WorkDisabilitiesWillingType>,
    val selectedDisabilities: ArrayList<String>,
    val callbacklisten: CallbackListen
) :
    RecyclerView.Adapter<DisabilitiesAdapter.ViewHolder>() {
    lateinit var disabilitiesClickListener: DisabilitiesClickListener

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var checkbox: AppCompatCheckBox = view.findViewById(R.id.checkbox)
    }

    override fun onCreateViewHolder(
        parent: ViewGroup, viewType: Int
    ): DisabilitiesAdapter.ViewHolder {
        var view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_disability_popup, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: DisabilitiesAdapter.ViewHolder, position: Int) {
        holder.checkbox.text = workDisabilitiesWillingType[position].name
        holder.checkbox.isChecked = false
        
        for (i in selectedDisabilities.indices) {
            if (workDisabilitiesWillingType[position].workDisabilitiesWillingTypeId == selectedDisabilities[i]) {
                holder.checkbox.isChecked = true
            }
        }
        holder.checkbox.setOnClickListener {
            if (holder.checkbox.isChecked) {
                disabilitiesClickListener.onDisabilityClick(
                    workDisabilitiesWillingType[position].workDisabilitiesWillingTypeId,
                    true
                )
            } else {
                disabilitiesClickListener.onDisabilityClick(
                    workDisabilitiesWillingType[position].workDisabilitiesWillingTypeId,
                    false
                )

            }
        }

//        holder.itemView.setOnClickListener(View.OnClickListener {
//            callbacklisten.clickItem(workDisabilitiesWillingType[position].workDisabilitiesWillingTypeId)
//        })
    }

    interface CallbackListen {
        fun clickItem(id: String)
    }


    override fun getItemCount(): Int {
        return workDisabilitiesWillingType.size
    }

    fun disabilitiesClickListener(disabilitiesClickListener: DisabilitiesClickListener) {
        this.disabilitiesClickListener = disabilitiesClickListener
    }
}