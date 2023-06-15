package com.app.xtrahelpcaregiver.Adapter

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.app.xtrahelpcaregiver.Fragment.BaseFragment

open class ViewPagerAdapter(fa: FragmentActivity, private val fragments: ArrayList<BaseFragment>) : FragmentStateAdapter(fa) {

    override fun getItemCount(): Int = fragments.size

    override fun createFragment(position: Int): Fragment = fragments[position]

}

open class ScreenSlidePagerAdapter(fa: Fragment, private val fragments: ArrayList<BaseFragment>) :
    FragmentStateAdapter(fa) {

    override fun getItemCount(): Int = fragments.size

    override fun createFragment(position: Int): Fragment = fragments[position]

}