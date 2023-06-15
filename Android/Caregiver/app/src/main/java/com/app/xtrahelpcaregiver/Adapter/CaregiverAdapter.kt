package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.CaregiverListResponse
import com.app.xtrahelpcaregiver.Response.Job
import com.app.xtrahelpcaregiver.Ui.CaregiverProfileActivity
import com.bumptech.glide.Glide

class CaregiverAdapter(
    val context: Context, var caregiverList: ArrayList<CaregiverListResponse.Data>
) : RecyclerView.Adapter<CaregiverAdapter.ViewHolder>() {

    var selectedPos = -1
    public var caregiverId = ""

    @JvmName("setAdapterList")
    fun setAdapterList(list: ArrayList<CaregiverListResponse.Data>) {
        this.caregiverList = ArrayList()
        this.caregiverList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val selectUnselectImg: ImageView = view.findViewById(R.id.selectUnselectImg)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view: View = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_cargiver_list, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.txtUserName.text =
            caregiverList[position].firstName + " " + caregiverList[position].lastName

        Glide.with(context)
            .load(caregiverList[position].profileImageThumbUrl)
            .centerCrop()
            .placeholder(R.drawable.placeholder)
            .into(holder.userImg)

        holder.selectUnselectImg.setImageResource(R.drawable.radio_unselect)
        if (selectedPos == position) {
            holder.selectUnselectImg.setImageResource(R.drawable.radio_select)
            caregiverId = caregiverList[position].id
        }

        holder.itemView.setOnClickListener {
//            holder.selectUnselectImg.setImageResource(R.drawable.radio_select)
            selectedPos = position
//            caregiverId = caregiverList[position].id
            notifyDataSetChanged()
        }

        holder.userImg.setOnClickListener{
          context.startActivity(Intent(context,CaregiverProfileActivity::class.java)
              .putExtra(CaregiverProfileActivity.CAREGIVERID,caregiverList[position].id))
        }
    }

    override fun getItemCount(): Int {
        return caregiverList.size
    }
}