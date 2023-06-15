package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.CategoryDatas
import com.app.xtrahelpcaregiver.Response.GetCaregiverMyProfileResponse

class CategoryProfileAdapter(
    val context: Context,
    val categoryList: ArrayList<GetCaregiverMyProfileResponse.Data.CategoryData> = ArrayList()
) : RecyclerView.Adapter<CategoryProfileAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtName: TextView = view.findViewById(R.id.txtName)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_specialities, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.txtName.text = categoryList[position].name
    }

    override fun getItemCount(): Int {
        return categoryList.size
    }
}