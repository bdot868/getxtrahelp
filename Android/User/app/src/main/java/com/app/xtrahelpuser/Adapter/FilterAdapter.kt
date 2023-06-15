package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R

class FilterAdapter(private val context: Context):RecyclerView.Adapter<FilterAdapter.ViewHolder>() {


    class ViewHolder(view: View): RecyclerView.ViewHolder(view) {

    }


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): FilterAdapter.ViewHolder {
        var view:View = LayoutInflater.from(parent.context).inflate(R.layout.adapter_filter,parent,false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: FilterAdapter.ViewHolder, position: Int) {

    }

    override fun getItemCount(): Int {
        return 5
    }
}