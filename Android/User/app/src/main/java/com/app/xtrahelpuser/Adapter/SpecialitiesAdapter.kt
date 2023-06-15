package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.appcompat.widget.AppCompatCheckBox
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.LovedSpecialities
import com.app.xtrahelpuser.Interface.SpecialitiesClass
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.LovedOne

class SpecialitiesAdapter(
    val context: Context,
    val lovedSpecialities: ArrayList<LovedSpecialities>,
    val lovedOneList: ArrayList<LovedOne>,
    val lovedHolder: LovedOneAdapter.ViewHolder
) :
    RecyclerView.Adapter<SpecialitiesAdapter.ViewHolder>() {

    var mainPos: Int = 0
    lateinit var specialitiesClass: SpecialitiesClass

    fun specialitiesClass(specialitiesClass: SpecialitiesClass) {
        this.specialitiesClass = specialitiesClass
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val checkbox: AppCompatCheckBox = view.findViewById(R.id.checkbox)
        val aboutImg: ImageView = view.findViewById(R.id.aboutImg)
    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_specialities_categories, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.checkbox.text = lovedSpecialities[position].name
        holder.aboutImg.visibility = View.GONE

        holder.checkbox.isChecked = false
        for (i in lovedOneList[lovedHolder.adapterPosition].lovedSpecialities.indices) {
            if (lovedOneList[lovedHolder.adapterPosition].lovedSpecialities[i] == lovedSpecialities[position].lovedSpecialitiesId) {
                holder.checkbox.isChecked = true
            }
        }

        holder.checkbox.setOnClickListener {
            mainPos= lovedHolder.adapterPosition
            specialitiesClass.onAddSpecialitiesClass(
                mainPos,
                lovedSpecialities[position].lovedSpecialitiesId,
                holder.checkbox.isChecked
            )
        }

    }

    override fun getItemCount(): Int {
        return lovedSpecialities.size
    }

}