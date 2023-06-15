package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Ui.BlogDetailsActivity
import com.app.xtrahelpcaregiver.Utils.Utils

class TransporationMethodAdapter(
    private val context: Context,
    val workMethodOfTransportationList: ArrayList<WorkMethodOfTransportation>,
    val callbacklisten: CallbackListen
) :
    RecyclerView.Adapter<TransporationMethodAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var tvTitle: TextView = view.findViewById(R.id.tvTitle)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TransporationMethodAdapter.ViewHolder {
        var view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_common, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: TransporationMethodAdapter.ViewHolder, position: Int) {
        holder.tvTitle.text = workMethodOfTransportationList[position].name
        holder.itemView.setOnClickListener(View.OnClickListener {
            callbacklisten.clickItem(workMethodOfTransportationList[position].workMethodOfTransportationId)
        })
    }

    interface CallbackListen {
        fun clickItem(id: String)
    }


    override fun getItemCount(): Int {
        return workMethodOfTransportationList.size
    }
}