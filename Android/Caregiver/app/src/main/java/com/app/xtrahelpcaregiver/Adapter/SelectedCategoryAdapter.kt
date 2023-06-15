package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.CategoryData
import com.app.xtrahelpcaregiver.Utils.Const

class SelectedCategoryAdapter(
    private val context: Context,
    val categoryDataList: ArrayList<CategoryData>
) : RecyclerView.Adapter<SelectedCategoryAdapter.ViewHolder>() {


    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var txtKeyWord: TextView = view.findViewById(R.id.txtKeyWord)
        var remove: ImageView = view.findViewById(R.id.remove)
    }


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int
    ): SelectedCategoryAdapter.ViewHolder {
        var view: View = LayoutInflater.from(parent.context).inflate(R.layout.adapter_filter, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: SelectedCategoryAdapter.ViewHolder, position: Int) {
        for (i in categoryDataList.indices) {
            if (categoryDataList[i].jobCategoryId == Const.selectedCategory[position]){
                holder.txtKeyWord.text = categoryDataList[i].name
            }
        }

        holder.remove.setOnClickListener{
            Const.selectedCategory.remove( Const.selectedCategory[position])
            notifyDataSetChanged()
        }
    }

    override fun getItemCount(): Int {
        return Const.selectedCategory.size
    }
}