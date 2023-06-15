package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R

class PreferencesAdapter(private val context: Context):RecyclerView.Adapter<PreferencesAdapter.ViewHolder>() {

    
    class ViewHolder(view: View):RecyclerView.ViewHolder(view) {

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PreferencesAdapter.ViewHolder {
        val view= LayoutInflater.from(parent.context).inflate(R.layout.adapter_preferences,parent,false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: PreferencesAdapter.ViewHolder, position: Int) {

    }

    override fun getItemCount(): Int {
       return 3
    }
}