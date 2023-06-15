package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.CategoryData
import com.app.xtrahelpuser.Interface.FilterCategorySelectClick
import com.app.xtrahelpuser.R
import com.bumptech.glide.Glide


class FilterCategoryAdapter(
    val context: Context,
    val selectedCategory: ArrayList<String>,
    val categoryDataList: ArrayList<CategoryData>
) : RecyclerView.Adapter<FilterCategoryAdapter.ViewHolder>() {
    
    lateinit var filterCategorySelectClick: FilterCategorySelectClick

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtTitle: TextView = view.findViewById(R.id.txtTitle)
        val categoryImg: ImageView = view.findViewById(R.id.categoryImg)
        val relative: RelativeLayout = view.findViewById(R.id.relative)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_filter_category, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.txtTitle.text = categoryDataList[position].name
        holder.relative.background = null
        for (i in selectedCategory.indices) {
            if (selectedCategory[i] == categoryDataList[position].jobCategoryId) {
                holder.relative.background = context.getDrawable(R.drawable.category_select)
            }
        }

        holder.itemView.setOnClickListener {
            if (selectedCategory.contains(categoryDataList[position].jobCategoryId)){
                filterCategorySelectClick.onCategorySelectUnselect(categoryDataList[position].jobCategoryId,false)
            }else {
                filterCategorySelectClick.onCategorySelectUnselect(categoryDataList[position].jobCategoryId,true)
            }

        }

        Glide.with(context)
            .load(categoryDataList[position].imageThumbUrl)
            .placeholder(R.drawable.main_placeholder)
            .centerCrop()
            .into(holder.categoryImg)
    }

    override fun getItemCount(): Int {
        return categoryDataList.size
    }

    fun filterCategorySelectClick(filterCategorySelectClick: FilterCategorySelectClick) {
        this.filterCategorySelectClick = filterCategorySelectClick
    }
}