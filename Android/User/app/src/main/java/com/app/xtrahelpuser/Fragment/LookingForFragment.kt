package com.app.xtrahelpuser.Fragment

import android.content.Intent
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Request.LangTokenSearch
import com.app.xtrahelpcaregiver.Request.LangTokenSearchRequest
import com.app.xtrahelpcaregiver.Response.CategoryData
import com.app.xtrahelpcaregiver.Response.GetJobCategoryListResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.CategoryListAdapter
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Ui.AddJobActivity
import com.app.xtrahelpuser.Ui.FAQsActivity
import kotlinx.android.synthetic.main.fragment_looking_for.*
import kotlinx.android.synthetic.main.fragment_looking_for.relative
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class LookingForFragment : BaseFragment() {

    lateinit var categoryListAdapter: CategoryListAdapter
    var categoryDataList: ArrayList<CategoryData> = ArrayList()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_looking_for, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        init()
        getCategoryList()
    }

    private fun init() {
        faqImg.setOnClickListener(this)
        relativeNext.setOnClickListener(this)
        relativeBack.setOnClickListener(this)

        categoryListAdapter = CategoryListAdapter(activity, "job", categoryDataList)
        recyclerCategories.layoutManager = LinearLayoutManager(activity)
        recyclerCategories.isNestedScrollingEnabled = false
        recyclerCategories.adapter = categoryListAdapter

    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.faqImg -> startActivity(Intent(activity, FAQsActivity::class.java))
            R.id.relativeNext -> {
                if (isValid()) {
                    (getActivity() as AddJobActivity?)?.replaceFragment(PreferencesFragment())
                }
            }
            R.id.relativeBack -> {
                (getActivity() as AddJobActivity?)?.backFragment()
//                (getActivity() as AddJobActivity?)?.replaceFragment(PreferencesFragment())
            }
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
                                recyclerCategories.visibility = View.VISIBLE
                                txtDataNotFound.visibility = View.GONE
                                categoryDataList.clear()
                                categoryDataList.addAll(getJobCategoruListResponse.data)
                                categoryListAdapter.notifyDataSetChanged()
                            }
                            "6" -> {
                                recyclerCategories.visibility = View.GONE
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

    private fun isValid(): Boolean {
        var message: String
        message = ""
        if (AddJobActivity.categoryId.isEmpty()) {
            message = getString(R.string.selectCategory)
        } else if (AddJobActivity.subCategoryIds.isEmpty()) {
            message = getString(R.string.selectSubCategory)
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }
}