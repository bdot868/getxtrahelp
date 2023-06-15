package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.widget.PopupMenu
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.GetUserJobResponse
import com.app.xtrahelpcaregiver.Ui.JobDetailActivity
import com.bumptech.glide.Glide
import java.util.ArrayList

class SearchResultsAdapter(
    private val context: Context
) : RecyclerView.Adapter<SearchResultsAdapter.ViewHolder>() {
    var jobList: ArrayList<GetUserJobResponse.Data> = ArrayList()

    @JvmName("setFaqList1")
    fun setAdapterList(list: ArrayList<GetUserJobResponse.Data>) {
        this.jobList=ArrayList()
        if (list != null) this.jobList.addAll(list)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val userImg: ImageView = view.findViewById(R.id.userImg)
        val txtUserName: TextView = view.findViewById(R.id.txtUserName)
        val txtJobName: TextView = view.findViewById(R.id.txtJobName)
        val txtDate: TextView = view.findViewById(R.id.txtDate)
        val txtJobType: TextView = view.findViewById(R.id.txtJobType)
        val txtCategoryName: TextView = view.findViewById(R.id.txtCategoryName)
        val txtPrice: TextView = view.findViewById(R.id.txtPrice)
        val txtMiles: TextView = view.findViewById(R.id.txtMiles)

    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): SearchResultsAdapter.ViewHolder {
        val view: View = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_search_results, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: SearchResultsAdapter.ViewHolder, position: Int) {
        val data: GetUserJobResponse.Data = jobList[position]
        holder.txtUserName.text = data.userFullName
        holder.txtCategoryName.text = data.CategoryName
        holder.txtJobName.text = data.name
        holder.txtPrice.text = data.formatedPrice+"/hr"
        holder.txtDate.text = data.startDateTime
        holder.txtMiles.text = data.distance+"ml"

        if (data.isJob == "1") {
            holder.txtJobType.text = "One Time"
        } else {
            holder.txtJobType.text = "Recurring"
        }

        Glide.with(context)
            .load(data.profileImageThumbUrl)
            .placeholder(R.drawable.placeholder)
            .centerCrop()
            .into(holder.userImg)

        holder.itemView.setOnClickListener {
            context.startActivity(
                Intent(context, JobDetailActivity::class.java)
                    .putExtra(JobDetailActivity.JOBID, data.userJobId)
                    .putExtra(JobDetailActivity.JOBDETAILTYPE,"search")
            )
        }
    }

    override fun getItemCount(): Int {
        return jobList.size
    }

}