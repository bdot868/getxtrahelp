package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.CheckBox
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.SubCategory
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Ui.AddJobActivity

class SubCategoryAdapter(
    val context: Context,
    var subCategoryList: ArrayList<SubCategory>
) : RecyclerView.Adapter<SubCategoryAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val checkbox: CheckBox = view.findViewById(R.id.checkbox)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_specialities_categories, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.checkbox.text = subCategoryList[position].name

        holder.checkbox.isChecked = false
        for (i in AddJobActivity.subCategoryIds.indices) {
            if (AddJobActivity.subCategoryIds[i] == subCategoryList[position].jobSubCategoryId) {
                holder.checkbox.isChecked = true
            }
        }

        holder.checkbox.setOnClickListener {
            if (AddJobActivity.categoryId == subCategoryList[position].jobCategoryId) {
                if (holder.checkbox.isChecked) {
                    AddJobActivity.subCategoryIds.add(subCategoryList[position].jobSubCategoryId)
                } else {
                    AddJobActivity.subCategoryIds.remove(subCategoryList[position].jobSubCategoryId)
                }
            }
            Log.e("dkjsds sdkjs", "onBindViewHolder: " + AddJobActivity.subCategoryIds)
            notifyDataSetChanged()
        }
    }

    override fun getItemCount(): Int {
        return subCategoryList.size
    }
}