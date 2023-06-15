package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RelativeLayout
import androidx.viewpager.widget.PagerAdapter
import androidx.viewpager.widget.ViewPager
import com.app.xtrahelpuser.R


class WelcomeAdapter(
    val context: Context,
    var images: IntArray
) : PagerAdapter() {
    var layoutInflater = context.getSystemService(android.content.Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater?
//    var layoutInflater: LayoutInflater? = null
//    var context: Context? = null
//    lateinit var images: IntArray
//    var layoutInflater: LayoutInflater? = null


    override fun getCount(): Int {
        return images.size
    }


    override fun isViewFromObject(view: View, `object`: Any): Boolean {
        return view === `object`
    }


    override fun instantiateItem(container: ViewGroup, position: Int): Any {
        val itemView: View? = layoutInflater?.inflate(R.layout.adapter_tutorial, container, false)
        val Img = itemView?.findViewById<View>(R.id.img) as ImageView
        Img.setImageResource(images[position])
        container.addView(itemView)
        return itemView
    }

    override fun destroyItem (container:ViewGroup, position:Int, obj:Any) {
        (container as ViewPager).removeView(obj as RelativeLayout?)
    }
}