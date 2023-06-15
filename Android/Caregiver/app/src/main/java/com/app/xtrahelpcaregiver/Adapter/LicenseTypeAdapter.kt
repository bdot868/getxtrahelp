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
import com.app.xtrahelpcaregiver.Response.LicenceType
import com.app.xtrahelpcaregiver.Ui.BlogDetailsActivity
import com.app.xtrahelpcaregiver.Utils.Utils

class LicenseTypeAdapter(
    private val context: Context,
    val licenceTypeList: ArrayList<LicenceType>,
    val callbacklisten: CallbackListen
) :
    RecyclerView.Adapter<LicenseTypeAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var tvTitle: TextView = view.findViewById(R.id.tvTitle)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): LicenseTypeAdapter.ViewHolder {
        var view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_common, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: LicenseTypeAdapter.ViewHolder, position: Int) {
        holder.tvTitle.text = licenceTypeList[position].name
        holder.itemView.setOnClickListener(View.OnClickListener {
            callbacklisten.clickItem(licenceTypeList[position].licenceTypeId)
        })
    }

    interface CallbackListen {
        fun clickItem(id: String)
    }


    override fun getItemCount(): Int {
        return licenceTypeList.size
    }
}