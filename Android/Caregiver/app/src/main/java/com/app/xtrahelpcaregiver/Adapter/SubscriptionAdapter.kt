package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RelativeLayout
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.viewpager.widget.PagerAdapter
import com.app.xtrahelpcaregiver.R
import androidx.viewpager.widget.ViewPager

class SubscriptionAdapter(val context: Context) : PagerAdapter() {
    var layoutInflater = context.getSystemService(android.content.Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater?
    lateinit var subscriptionSubAdapter: SubscriptionSubAdapter

    override fun getCount(): Int {
        return 3
    }


    override fun isViewFromObject(view: View, `object`: Any): Boolean {
        return view === `object`
    }


    override fun instantiateItem(container: ViewGroup, position: Int): Any {
        val itemView: View? = layoutInflater?.inflate(R.layout.adapter_subscription, container, false)
        val recycler = itemView?.findViewById<View>(R.id.recycler) as RecyclerView

        subscriptionSubAdapter=SubscriptionSubAdapter(context)
        recycler.layoutManager=LinearLayoutManager(context)
        recycler.isNestedScrollingEnabled=false
        recycler.adapter=subscriptionSubAdapter
        
        container.addView(itemView)
        return itemView
    }

    override fun destroyItem (container:ViewGroup, position:Int, obj:Any) {
        (container as ViewPager).removeView(obj as RelativeLayout?)
    }
}