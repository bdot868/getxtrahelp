package com.app.xtrahelpcaregiver.Ui

import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.view.View
import android.view.ViewTreeObserver
import android.view.inputmethod.EditorInfo
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.BlogImageAdapter
import com.app.xtrahelpcaregiver.Adapter.ResourceBlogAdapter
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.GetResourceRequest
import com.app.xtrahelpcaregiver.Request.ResourceRequest
import com.app.xtrahelpcaregiver.Response.Resource
import com.app.xtrahelpcaregiver.Response.ResourceResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import kotlinx.android.synthetic.main.activity_blog_list.*
import kotlinx.android.synthetic.main.fragment_home.recyclerBlog
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class BlogListActivity : BaseActivity() {
    lateinit var resourceBlogAdapter: ResourceBlogAdapter
//    lateinit var blogImageAdapter: BlogImageAdapter

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true
    var search = ""

    var resourceList:ArrayList<Resource> = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_blog_list)
        init()
    }

    private fun init() {
        txtTitle.text = "Browse Article"

        etSearch.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable) {
                if (TextUtils.isEmpty(s.toString().trim { it <= ' ' })) {
                    resourceList.clear()
                    search = ""
                    getResorceApi(search)
                }
            }
        })

        etSearch.setOnEditorActionListener(TextView.OnEditorActionListener { v, i, event ->
            if (i == EditorInfo.IME_ACTION_SEARCH) {
                resourceList.clear()
                search = etSearch.text.toString().trim { it <= ' ' }
                getResorceApi(search)
                utils.hideKeyBoardFromView(activity)
                return@OnEditorActionListener true
            }
            false
        })


        nestedScroll.viewTreeObserver.addOnScrollChangedListener(ViewTreeObserver.OnScrollChangedListener {
            val view = nestedScroll.getChildAt(nestedScroll.childCount - 1) as View
            val diff: Int = view.bottom - (nestedScroll.height + nestedScroll
                .scrollY)
            if (diff == 0 && pageNum != totalPage!!.toInt()) {
                pageNum++
                isClearList = false
                getResorceApi(search)
            }
        })


        arrowBack.setOnClickListener(this)
        resourceBlogAdapter = ResourceBlogAdapter(activity)
        recyclerBlog.layoutManager = LinearLayoutManager(activity)
        recyclerBlog.isNestedScrollingEnabled = false
        recyclerBlog.adapter = resourceBlogAdapter

//        blogImageAdapter = BlogImageAdapter(activity)
//        recyclerImg.layoutManager = LinearLayoutManager(activity,RecyclerView.HORIZONTAL,false)
//        recyclerImg.isNestedScrollingEnabled = false
//        recyclerImg.adapter = blogImageAdapter

    }

    override fun onResume() {
        super.onResume()
        pageNum = 1
        isClearList = true
        getResorceApi(search)
    }
    
    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }

    private fun getResorceApi(search: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = GetResourceRequest(
                ResourceRequest(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    "",
                    search,
                    pageNum,
                    "15"
                )
            )

            val signUp: Call<ResourceResponse?> =
                RetrofitClient.getClient.getResource(langTokenRequest)
            signUp.enqueue(object : Callback<ResourceResponse?> {
                override fun onResponse(
                    call: Call<ResourceResponse?>,
                    response: Response<ResourceResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: ResourceResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                                recyclerBlog.visibility = View.VISIBLE
                                if (isClearList) {
                                    resourceList.clear()
                                }
                                totalPage = response.totalPages
                                txtDataNotFound.visibility = View.GONE

                                resourceList.addAll(response.data)
                                resourceBlogAdapter.setAdapterList(resourceList)
                                resourceBlogAdapter.notifyDataSetChanged()

                                if (resourceBlogAdapter.itemCount === 0) {
                                    txtDataNotFound.visibility = View.VISIBLE
                                    txtDataNotFound.text = response.message
                                } else {
                                    txtDataNotFound.visibility = View.GONE
                                }
                            }
                            "6" -> {
                                txtDataNotFound.visibility = View.VISIBLE
                                recyclerBlog.visibility = View.GONE
                                txtDataNotFound.setText(response.message)
//                                utils.showCustomToast(getCertificationsLicensesResponse.message)

                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    response.status,
                                    response.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<ResourceResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }

    }
}