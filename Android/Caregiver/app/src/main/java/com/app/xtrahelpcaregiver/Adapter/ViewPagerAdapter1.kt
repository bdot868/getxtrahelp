package com.app.xtrahelpcaregiver.Adapter

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter
import com.app.xtrahelpcaregiver.Fragment.BaseFragment
import java.util.ArrayList

class ViewPagerAdapter1(fm: FragmentManager, private val fragments: ArrayList<BaseFragment>) : FragmentPagerAdapter(fm) {

    override fun getCount(): Int {
        return fragments.size
    }

    fun add(fragment: BaseFragment) {
        fragments.add(fragment)
    }

    override fun getItem(position: Int): Fragment {
        return fragments[position]
    }
}