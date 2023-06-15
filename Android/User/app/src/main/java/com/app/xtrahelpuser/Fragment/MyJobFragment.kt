package com.app.xtrahelpuser.Fragment

import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.EditorInfo
import android.widget.TextView
import androidx.core.content.res.ResourcesCompat
import androidx.viewpager.widget.ViewPager
import androidx.viewpager2.widget.ViewPager2
import com.app.xtrahelpcaregiver.CustomView.DepthPageTransformer
import com.app.xtrahelpuser.Adapter.ViewPagerAdapter1
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Ui.DashboardActivity
import kotlinx.android.synthetic.main.fragment_my_job.*


class MyJobFragment : BaseFragment() {
    var type: String = "1"
    var search: String = ""

    lateinit var upcomingFragment: UpcomingFragment
    lateinit var postedFragment: PostedJobFragment
    lateinit var completeFragment: CompleteJobFragment
    lateinit var substituteFragment: SubstituteJobFragment

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_my_job, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        init()
    }

    private fun init() {
        linearUpcoming.setOnClickListener(this);
        linearPosted.setOnClickListener(this);
        linearComplete.setOnClickListener(this);
        linearSubstitute.setOnClickListener(this);

        upcomingFragment = UpcomingFragment.newInstance("1")
        postedFragment = PostedJobFragment.newInstance("2")
        completeFragment = CompleteJobFragment.newInstance("3")
        substituteFragment = SubstituteJobFragment.newInstance("4")

        var fragmentItems: ArrayList<BaseFragment> = ArrayList()
        fragmentItems.add(upcomingFragment)
        fragmentItems.add(postedFragment)
        fragmentItems.add(completeFragment)
        fragmentItems.add(substituteFragment)


        viewPager.adapter = ViewPagerAdapter1(childFragmentManager, fragmentItems)

        viewPager.setPageTransformer(true, DepthPageTransformer())

        viewPager.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
            override fun onPageScrolled(
                position: Int,
                positionOffset: Float,
                positionOffsetPixels: Int
            ) {
            }

            override fun onPageSelected(position: Int) {
                etSearch.setText("")
                    setSelectedTab(position)
                when (position) {
                    0 -> {
                        type = ""
                    }
                    1 -> {
                        type = "1"
                    }
                    2 -> {
                        type = "2"
                    }
                    3 -> {
                        type = "3"
                    }
                }
            }

            override fun onPageScrollStateChanged(state: Int) {
            }

        })


        etSearch.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable) {
                if (TextUtils.isEmpty(s.toString().trim { it <= ' ' })) {
                    search = ""
                    when (type) {
                        "1" -> {
                            upcomingFragment.callInterface(search)
                        }
                        "2" -> {
                            postedFragment.callInterface(search)
                        }
                        "3" -> {
                            completeFragment.callInterface(search)
                        }
                        "4" -> {
                            substituteFragment.callInterface(search)
                        }
                    }
                }
            }
        })

        etSearch.setOnEditorActionListener(TextView.OnEditorActionListener { v, i, event ->
            if (i == EditorInfo.IME_ACTION_SEARCH) {
                search = etSearch.text.toString().trim()
                utils.hideKeyBoardFromView(activity)
                when (type) {
                    "1" -> {
                        upcomingFragment.callInterface(search)
                    }
                    "2" -> {
                        postedFragment.callInterface(search)
                    }
                    "3" -> {
                        completeFragment.callInterface(search)
                    }
                    "4" -> {
                        substituteFragment.callInterface(search)
                    }
                }
                return@OnEditorActionListener true
            }
            false
        })

        try {
            if (DashboardActivity.toSubstitute) {
                type = "4"
                setSelectedTab(3)
                DashboardActivity.toSubstitute = false
            }
        } catch (e: Exception) {
            Log.e("Exception", "init: $e")
        }

    }

//    var pageChangeCallback: ViewPager2.OnPageChangeCallback =
//        object : ViewPager2.OnPageChangeCallback() {
//            override fun onPageSelected(position: Int) {
//                super.onPageSelected(position)
//                setSelectedTab(position)
//            }
//        }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.linearUpcoming -> {
                setSelectedTab(0)
                type = "1"
            }
            R.id.linearPosted -> {
                setSelectedTab(1)
                type = "2"
            }
            R.id.linearComplete -> {
                setSelectedTab(2)
                type = "3"
            }

            R.id.linearSubstitute -> {
                setSelectedTab(3)
                type = "4"
            }
        }
    }

    private fun setSelectedTab(pos: Int) {
        val semiBold = ResourcesCompat.getFont(activity, R.font.rubik_medium)
        val regular = ResourcesCompat.getFont(activity, R.font.rubik_regular)

        txtUpcoming.setTextColor(
            if (pos == 0) resources.getColor(R.color.txtPurple) else resources.getColor(
                R.color.txtDarkGray
            )
        )
        txtPosted.setTextColor(
            if (pos == 1) resources.getColor(R.color.txtPurple) else resources.getColor(
                R.color.txtDarkGray
            )
        )
        txtComplete.setTextColor(
            if (pos == 2) resources.getColor(R.color.txtPurple) else resources.getColor(
                R.color.txtDarkGray
            )
        )

        txtSubstitute.setTextColor(
            if (pos == 3) resources.getColor(R.color.txtPurple) else resources.getColor(
                R.color.txtDarkGray
            )
        )


        txtUpcoming.typeface = if (pos == 0) semiBold else regular
        txtPosted.typeface = if (pos == 1) semiBold else regular
        txtComplete.typeface = if (pos == 2) semiBold else regular
        txtSubstitute.typeface = if (pos == 3) semiBold else regular

        lineUpcoming.visibility = if (pos == 0) View.VISIBLE else View.GONE
        linePosted.visibility = if (pos == 1) View.VISIBLE else View.GONE
        lineComplete.visibility = if (pos == 2) View.VISIBLE else View.GONE
        lineSubstitute.visibility = if (pos == 3) View.VISIBLE else View.GONE


        viewPager.currentItem = pos

    }
}