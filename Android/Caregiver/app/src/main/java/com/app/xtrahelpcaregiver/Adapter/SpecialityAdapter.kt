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
import com.app.xtrahelpcaregiver.Response.WorkSpeciality
import com.app.xtrahelpcaregiver.Ui.BlogDetailsActivity
import com.app.xtrahelpcaregiver.Utils.Utils

class SpecialityAdapter(
    private val context: Context,
    val workSpecialityList: ArrayList<WorkSpeciality>,
    val callbacklisten: CallbackListen
) :
    RecyclerView.Adapter<SpecialityAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var tvTitle: TextView = view.findViewById(R.id.tvTitle)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SpecialityAdapter.ViewHolder {
        var view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_common, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: SpecialityAdapter.ViewHolder, position: Int) {
        holder.tvTitle.text = workSpecialityList[position].name
        holder.itemView.setOnClickListener(View.OnClickListener {
            callbacklisten.clickItem(workSpecialityList[position].workSpecialityId)
        })
    }

    interface CallbackListen {
        fun clickItem(id: String)
    }


    override fun getItemCount(): Int {
        return workSpecialityList.size
    }
}