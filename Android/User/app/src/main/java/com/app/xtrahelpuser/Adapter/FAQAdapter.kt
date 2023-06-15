package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.Faq
import com.app.xtrahelpuser.Ui.FAQsDetailsActivity
import java.util.ArrayList

class FAQAdapter(val context: Context) : RecyclerView.Adapter<FAQAdapter.ViewHolder>() {

    lateinit var subFAQsAdapter: SubFAQsAdapter
    var faqList: ArrayList<Faq> = ArrayList<Faq>()

    @JvmName("setFaqList1")
    fun setFaqList(faqList: ArrayList<Faq>) {
        this.faqList.clear()
        if (faqList != null) this.faqList.addAll(faqList)
        notifyDataSetChanged()
    }

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtTitle: TextView = view.findViewById(R.id.txtTitle)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.adapter_faq, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
//        subFAQsAdapter = SubFAQsAdapter(context)
//        holder.recyclerFaq.layoutManager = LinearLayoutManager(context)
//        holder.recyclerFaq.isNestedScrollingEnabled = false
//        holder.recyclerFaq.adapter = subFAQsAdapter

        holder.txtTitle.text = faqList[position].name
        holder.itemView.setOnClickListener {
            context.startActivity(
                Intent(context, FAQsDetailsActivity::class.java)
                    .putExtra("id", faqList[position].id)
            )
        }
    }

    override fun getItemCount(): Int {
        return faqList.size
    }
}