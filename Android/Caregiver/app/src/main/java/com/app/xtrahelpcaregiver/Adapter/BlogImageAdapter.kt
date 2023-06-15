package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Ui.BlogDetailsActivity

class BlogImageAdapter(private val context: Context):RecyclerView.Adapter<BlogImageAdapter.ViewHolder>() {

    class ViewHolder(view: View):RecyclerView.ViewHolder(view) {
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): BlogImageAdapter.ViewHolder {
        var view =LayoutInflater.from(parent.context).inflate(R.layout.adapter_blog_image,parent,false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: BlogImageAdapter.ViewHolder, position: Int) {
        holder.itemView.setOnClickListener {
            context.startActivity(Intent(context, BlogDetailsActivity::class.java))
        }
    }

    override fun getItemCount(): Int {
        return 5
    }
}