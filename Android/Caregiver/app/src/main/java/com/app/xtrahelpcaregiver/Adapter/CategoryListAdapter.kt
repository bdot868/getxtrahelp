package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Interface.CategoryClickListener
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.SelectedCategory
import com.app.xtrahelpcaregiver.Response.CategoryData
import com.app.xtrahelpcaregiver.Utils.Const
import com.bumptech.glide.Glide

class CategoryListAdapter(
    private val context: Context,
    private val type: String,
    val categoryDataList: ArrayList<CategoryData>
) : RecyclerView.Adapter<CategoryListAdapter.ViewHolder>() {

    lateinit var categoryClickListener: CategoryClickListener

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtTitle: TextView = view.findViewById(R.id.txtTitle)
        val relativeMain: RelativeLayout = view.findViewById(R.id.relativeMain)
        val categoryImg: ImageView = view.findViewById(R.id.categoryImg)
        val imgSelect: ImageView = view.findViewById(R.id.imgSelect)
    }


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_categoryies_list, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        if (type == "home") {
            holder.relativeMain.layoutParams.width = 600
        }
//        else {
//            Glide.with(context)
//                .load(categoryDataList[position].imageUrl)
//                .centerCrop()
//                .placeholder(R.drawable.main_placeholder)
//                .into(holder.categoryImg)
//
//            holder.txtTitle.text = categoryDataList[position].name
//
//            if (categoryDataList[position].isSelect) {
//                holder.imgSelect.visibility = View.VISIBLE
//            } else {
//                holder.imgSelect.visibility = View.GONE
//            }
//        }

        Glide.with(context)
            .load(categoryDataList[position].imageUrl)
            .centerCrop()
            .placeholder(R.drawable.main_placeholder)
            .into(holder.categoryImg)

        holder.txtTitle.text = categoryDataList[position].name

        if (categoryDataList[position].isSelect) {
            holder.imgSelect.visibility = View.VISIBLE
        } else {
            holder.imgSelect.visibility = View.GONE
        }

        holder.itemView.setOnClickListener {
            if (type == "home" || type == "viewAll") {
                categoryClickListener.onCategoryClick(categoryDataList[position].jobCategoryId)
            } else {
                if (categoryDataList[position].isSelect) {
                    if (Const.selectedCategory.isNotEmpty()) {
                        for (i in Const.selectedCategory.indices) {
                            Const.selectedCategory.remove(categoryDataList[position].jobCategoryId)
                            categoryDataList[position].isSelect = false
                        }
                    }
                } else {
                    Const.selectedCategory.add(categoryDataList[position].jobCategoryId)
                    categoryDataList[position].isSelect = true
                }
                notifyDataSetChanged()
            }
        }

    }

    override fun getItemCount(): Int {
        return categoryDataList.size
    }

    fun setOnCategoryClick(categoryClickListener: CategoryClickListener) {
        this.categoryClickListener = categoryClickListener
    }
}