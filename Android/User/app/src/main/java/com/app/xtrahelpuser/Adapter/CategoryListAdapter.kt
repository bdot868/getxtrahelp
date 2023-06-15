package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.text.Html
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.CategoryData
import com.app.xtrahelpcaregiver.Response.SubCategory
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpuser.Interface.CategoryClickListener
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Ui.AddJobActivity
import com.bumptech.glide.Glide
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog

class CategoryListAdapter(
    val context: Context,
    val type: String,
    var categoryDataList: ArrayList<CategoryData>
) :
    RecyclerView.Adapter<CategoryListAdapter.ViewHolder>() {
    lateinit var dialog: BottomSheetDialog
    lateinit var subCategoryAdapter: SubCategoryAdapter
    lateinit var categoryClickListener: CategoryClickListener

    var selectedPos: Int = -1

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtTitle: TextView = view.findViewById(R.id.txtTitle)
        val relativeMain: RelativeLayout = view.findViewById(R.id.relativeMain)
        val recyclerViewSubCategory: RecyclerView = view.findViewById(R.id.recyclerViewSubCategory)
        val greenCheck: ImageView = view.findViewById(R.id.greenCheck)
        val image: ImageView = view.findViewById(R.id.image)
    }


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_categoryies_list, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        if (categoryDataList[position].subCategory != null) {
            subCategoryAdapter = SubCategoryAdapter(context, categoryDataList[position].subCategory)
            holder.recyclerViewSubCategory.layoutManager = GridLayoutManager(context, 2)
            holder.recyclerViewSubCategory.isNestedScrollingEnabled = false
            holder.recyclerViewSubCategory.adapter = subCategoryAdapter
        }

        Glide.with(context)
            .load(categoryDataList[position].imageThumbUrl)
            .centerCrop()
            .placeholder(R.drawable.main_placeholder)
            .into(holder.image)

        holder.txtTitle.text = categoryDataList[position].name

        if (AddJobActivity.categoryId == categoryDataList[position].jobCategoryId) {
            selectedPos = position
        }

        holder.itemView.setOnClickListener {
            if (type == "home" || type == "fromHome") {
                categoryClickListener.onCategoryClick(categoryDataList[position].jobCategoryId)
            } else {
                if (AddJobActivity.categoryId != categoryDataList[position].jobCategoryId) {
                    selectedPos = position
                    AddJobActivity.categoryId = categoryDataList[position].jobCategoryId
                    AddJobActivity.subCategoryIds.clear()
                    notifyDataSetChanged()
                }
            }
        }

        if (selectedPos == position) {
            holder.recyclerViewSubCategory.visibility = View.VISIBLE
            holder.greenCheck.visibility = View.VISIBLE
        } else {
            holder.recyclerViewSubCategory.visibility = View.GONE
            holder.greenCheck.visibility = View.GONE
        }

        if (type == "home") {
            holder.relativeMain.layoutParams.width = 600
        }


        holder.txtTitle.setOnClickListener {
            shoDialog(categoryDataList[position].name,categoryDataList[position].description)
        }
    }

    override fun getItemCount(): Int {
        return categoryDataList.size
    }


    fun setOnCategoryClick(categoryClickListener: CategoryClickListener) {
        this.categoryClickListener = categoryClickListener
    }

    private fun shoDialog(name: String, desc: String) {
        var layoutInflater = LayoutInflater.from(context)
        val dialogView = layoutInflater.inflate(R.layout.info_popup, null)
        dialog = BottomSheetDialog(context, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtDesc = dialog.findViewById<TextView>(R.id.txtDesc)
        val txtTitle = dialog.findViewById<TextView>(R.id.txtTitle)


        txtTitle?.text = name
        txtDesc?.text = desc

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }
        
        dialog.show()
    }
}