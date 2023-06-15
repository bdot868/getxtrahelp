package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R

class PreferencesListAdapter(private val context: Context):RecyclerView.Adapter<PreferencesListAdapter.ViewHolder>() {

    
    class ViewHolder(view: View):RecyclerView.ViewHolder(view) {

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PreferencesListAdapter.ViewHolder {
        val view= LayoutInflater.from(parent.context).inflate(R.layout.adapter_preferences_list,parent,false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: PreferencesListAdapter.ViewHolder, position: Int) {

    }

    override fun getItemCount(): Int {
       return 3
    }
}