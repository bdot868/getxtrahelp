package com.app.xtrahelpuser.Ui

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Request.LangTokenSearch
import com.app.xtrahelpcaregiver.Request.LangTokenSearchRequest
import com.app.xtrahelpcaregiver.Response.CategoryData
import com.app.xtrahelpcaregiver.Response.GetJobCategoryListResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.CategoryListAdapter
import com.app.xtrahelpuser.Interface.CategoryClickListener
import com.app.xtrahelpuser.R
import kotlinx.android.synthetic.main.activity_category_list.*
import kotlinx.android.synthetic.main.header.*
import kotlinx.android.synthetic.main.header.txtTitle
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class CategoryListActivity : BaseActivity(),CategoryClickListener {

    lateinit var categoryListAdapter: CategoryListAdapter;
    var categoryDataList: ArrayList<CategoryData> = ArrayList()

    companion object {
        val FROMHOME = "fromHome"
    }

    var fromHome = false
    var type = ""
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_category_list)
        txtTitle.text = "Categories"
        fromHome = intent.getBooleanExtra(FROMHOME, false)
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        getCategoryList()
        if (fromHome) {
            type = "fromHome"
        }
        categoryListAdapter = CategoryListAdapter(activity, type, categoryDataList)
        recyclerCategory.layoutManager = LinearLayoutManager(activity)
        recyclerCategory.isNestedScrollingEnabled = false
        recyclerCategory.adapter = categoryListAdapter
        categoryListAdapter.setOnCategoryClick(this)
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }

    private fun getCategoryList() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenSearchRequest(
                LangTokenSearch(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    ""
                )
            )
            val signUp: Call<GetJobCategoryListResponse?> =
                RetrofitClient.getClient.getJobCategoryList(langTokenRequest)
            signUp.enqueue(object : Callback<GetJobCategoryListResponse?> {
                override fun onResponse(
                    call: Call<GetJobCategoryListResponse?>,
                    response: Response<GetJobCategoryListResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val getJobCategoruListResponse: GetJobCategoryListResponse =
                            response.body()!!
                        when (getJobCategoruListResponse.status) {
                            "1" -> {
                                recyclerCategory.visibility = View.VISIBLE
                                txtDataNotFound.visibility = View.GONE
                                categoryDataList.clear()
                                categoryDataList.addAll(getJobCategoruListResponse.data)
                                categoryListAdapter.notifyDataSetChanged()
                            }
                            "6" -> {
                                recyclerCategory.visibility = View.GONE
                                txtDataNotFound.visibility = View.VISIBLE
                                txtDataNotFound.setText(getJobCategoruListResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    getJobCategoruListResponse.status,
                                    getJobCategoruListResponse.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<GetJobCategoryListResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    override fun onCategoryClick(categoryId: String) {
        startActivity(
            Intent(activity, SearchActivity::class.java)
                .putExtra(SearchActivity.CATEGORYID, categoryId)
        )
    }
}