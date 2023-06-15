package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.CommonDataResponse
import com.app.xtrahelpcaregiver.Response.HearAboutUs
import com.app.xtrahelpcaregiver.Response.InsuranceType
import com.app.xtrahelpcaregiver.Response.LicenceType
import com.app.xtrahelpcaregiver.Ui.BlogDetailsActivity
import com.app.xtrahelpcaregiver.Utils.Utils

class InsuranceTypeAdapter(
    private val context: Context,
    val insuranceTypeList: ArrayList<InsuranceType>,
    val callbacklisten: CallbackListen
) :
    RecyclerView.Adapter<InsuranceTypeAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var tvTitle: TextView = view.findViewById(R.id.tvTitle)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): InsuranceTypeAdapter.ViewHolder {
        var view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_common, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: InsuranceTypeAdapter.ViewHolder, position: Int) {
        holder.tvTitle.text = insuranceTypeList[position].name
        holder.itemView.setOnClickListener(View.OnClickListener {
            callbacklisten.clickItem(insuranceTypeList[position].insuranceTypeId)
        })
    }

    interface CallbackListen {
        fun clickItem(id: String)
    }


    override fun getItemCount(): Int {
        return insuranceTypeList.size
    }
}