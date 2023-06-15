package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.SearchHistoryResponse
import com.app.xtrahelpcaregiver.Interface.RemoveSearchHistoryClick
import java.util.ArrayList

class SearchHistoryAdapter(
    private val context: Context,
    var searchHistoryList: ArrayList<SearchHistoryResponse.Data>
) : RecyclerView.Adapter<SearchHistoryAdapter.ViewHolder>() {

    lateinit var removeSearchHistoryClick: RemoveSearchHistoryClick

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtKeyWord: TextView = view.findViewById(R.id.txtKeyWord)
        val remove: ImageView = view.findViewById(R.id.remove)
    }


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int
    ): SearchHistoryAdapter.ViewHolder {
        var view: View = LayoutInflater.from(parent.context).inflate(R.layout.adapter_filter, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: SearchHistoryAdapter.ViewHolder, position: Int) {
        holder.txtKeyWord.text = searchHistoryList[position].keyword

        holder.remove.setOnClickListener {
            removeSearchHistoryClick.removeSearchClick(searchHistoryList[position].userSearchHistoryId,true)
        }

        holder.itemView.setOnClickListener {
            removeSearchHistoryClick.removeSearchClick(searchHistoryList[position].keyword,false)
        }
    }

    override fun getItemCount(): Int {
        return searchHistoryList.size
    }

    fun removeSearchHistoryClick(removeSearchHistoryClick: RemoveSearchHistoryClick) {
        this.removeSearchHistoryClick = removeSearchHistoryClick;
    }
}