package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.CaregiverTransactionResponse
import com.app.xtrahelpcaregiver.Response.Job

class TransactionAdapter(val context: Context) :
    RecyclerView.Adapter<TransactionAdapter.ViewHolder>() {

    var transactionList: ArrayList<CaregiverTransactionResponse.Data> = ArrayList()

    @JvmName("setAdapterList")
    fun setAdapterList(list: ArrayList<CaregiverTransactionResponse.Data>) {
        this.transactionList = ArrayList()
        this.transactionList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtTitle: TextView = view.findViewById(R.id.txtTitle)
        val txtAmount: TextView = view.findViewById(R.id.txtAmount)
        val txtDesc: TextView = view.findViewById(R.id.txtDesc)
        val txtTime: TextView = view.findViewById(R.id.txtTime)

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_transaction, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val data = transactionList[position]

        holder.txtAmount.text = data.amountFormatted
        holder.txtTitle.text = data.jobName
        holder.txtTime.text=data.userTransactionTime
        holder.txtDesc.text=data.caregiverName

    }

    override fun getItemCount(): Int {
        return transactionList.size
    }
}