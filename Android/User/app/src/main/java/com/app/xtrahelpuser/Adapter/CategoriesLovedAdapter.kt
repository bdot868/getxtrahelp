package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.widget.AppCompatCheckBox
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.LovedCategory
import com.app.xtrahelpuser.Interface.LovedCategoryClick
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.LovedOne
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog

class CategoriesLovedAdapter(
    val context: Context,
    val lovedCategoryList: ArrayList<LovedCategory>,
    var selectedCategoryList: ArrayList<String>,
    val lovedOneList: ArrayList<LovedOne>,
    val lovedHolder: LovedOneAdapter.ViewHolder
) :
    RecyclerView.Adapter<CategoriesLovedAdapter.ViewHolder>() {

    lateinit var dialog: BottomSheetDialog

    lateinit var lovedCategoryClick: LovedCategoryClick

    //    lateinit var clickPosition: ClickPosition
    var mainPos: Int = 0

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val checkbox: AppCompatCheckBox = view.findViewById(R.id.checkbox)
        val aboutImg: ImageView = view.findViewById(R.id.aboutImg)
    }

    override fun onCreateViewHolder(
        parent: ViewGroup, viewType: Int
    ): CategoriesLovedAdapter.ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_specialities_categories, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: CategoriesLovedAdapter.ViewHolder, position: Int) {
        holder.checkbox.text = lovedCategoryList[position].name
//        selectedCategoryList = lovedOneList[lovedHolder.adapterPosition].lovedCategory

        if (lovedCategoryList[position].name == "Other") {
            holder.aboutImg.visibility = View.GONE
        } else {
            holder.aboutImg.visibility = View.VISIBLE
        }

        holder.checkbox.isChecked = false
        for (i in lovedOneList[lovedHolder.adapterPosition].lovedCategory.indices) {
            if (lovedOneList[lovedHolder.adapterPosition].lovedCategory[i] == lovedCategoryList[position].lovedCategoryId) {
                holder.checkbox.isChecked = true
            }
        }

        holder.checkbox.setOnClickListener {
            mainPos= lovedHolder.adapterPosition
            lovedCategoryClick.onLovedCategoryClick(
                position,
                mainPos,
                lovedCategoryList[position].lovedCategoryId,
                holder.checkbox.isChecked
            )
        }

        holder.aboutImg.setOnClickListener {
            showTypeDialog(
                lovedCategoryList[position].name,
                lovedCategoryList[position].description
            )
        }
    }

    override fun getItemCount(): Int {
        return lovedCategoryList.size
    }

    fun lovedCategoryClick(lovedCategoryClick: LovedCategoryClick) {
        this.lovedCategoryClick = lovedCategoryClick
    }

    private fun showTypeDialog(title: String, desc: String) {
        val layoutInflater = LayoutInflater.from(context)
        val dialogView = layoutInflater.inflate(R.layout.category_detail_popup, null)

        dialog = BottomSheetDialog(context, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtTitlePopup = dialog.findViewById<TextView>(R.id.txtTitlePopup)
        val txtDesc = dialog.findViewById<TextView>(R.id.txtDesc)

        txtTitlePopup?.text = title
        txtDesc?.text = desc

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        dialog.show()
    }


    override fun getItemViewType(position: Int): Int {
        return position
    }


    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

}

