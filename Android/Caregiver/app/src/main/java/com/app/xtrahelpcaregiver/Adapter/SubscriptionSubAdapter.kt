package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R

class SubscriptionSubAdapter(val context: Context): RecyclerView.Adapter<SubscriptionSubAdapter.ViewHolder>() {

    class ViewHolder(view: View):RecyclerView.ViewHolder(view) {

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SubscriptionSubAdapter.ViewHolder {
        var view = LayoutInflater.from(parent.context).inflate(R.layout.adapter_subscriptionsub,parent,false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: SubscriptionSubAdapter.ViewHolder, position: Int) {

    }

    override fun getItemCount(): Int {
        return 5
    }
}