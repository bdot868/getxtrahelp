package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.Resource
import com.app.xtrahelpuser.Response.UserDashboardResponse
import com.app.xtrahelpuser.Ui.BlogDetailsActivity
import com.bumptech.glide.Glide

class ResourceBlogAdapter(val context: Context) :
    RecyclerView.Adapter<ResourceBlogAdapter.ViewHolder>() {

    var resourceList: ArrayList<Resource> = ArrayList()

    @JvmName("setAdapterList")
    fun setAdapterList(list: java.util.ArrayList<Resource>) {
        this.resourceList = ArrayList()
        this.resourceList.addAll(list)
        notifyDataSetChanged()
    }


    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val img: ImageView = view.findViewById(R.id.img)
        val txtTitle: TextView = view.findViewById(R.id.txtTitle)
        val txtCategory: TextView = view.findViewById(R.id.txtCategory)
        val txtDate: TextView = view.findViewById(R.id.txtDate)
        val txtDesc: TextView = view.findViewById(R.id.txtDesc)
    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ResourceBlogAdapter.ViewHolder {
        var view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_resource_blog, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ResourceBlogAdapter.ViewHolder, position: Int) {
        holder.txtTitle.text = resourceList[position].title
        holder.txtCategory.text = resourceList[position].categoryName
        holder.txtDate.text = resourceList[position].createdDateFormat
        holder.txtDesc.text = resourceList[position].description

        Glide.with(context)
            .load(resourceList[position].thumbImageUrl)
            .centerCrop()
            .placeholder(R.drawable.main_placeholder)
            .into(holder.img)

        holder.itemView.setOnClickListener {
            context.startActivity(
                Intent(context, BlogDetailsActivity::class.java)
                    .putExtra("blogId", resourceList[position].resourceId)
            )
        }
    }

    override fun getItemCount(): Int {
        return resourceList.size
    }
}