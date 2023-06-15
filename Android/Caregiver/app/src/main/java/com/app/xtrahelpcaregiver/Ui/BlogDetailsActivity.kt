package com.app.xtrahelpcaregiver.Ui

import android.os.Bundle
import android.view.View
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.GetResourceRequest
import com.app.xtrahelpcaregiver.Request.ResourceDetailRequest
import com.app.xtrahelpcaregiver.Request.ResourceRequest
import com.app.xtrahelpcaregiver.Response.ResourceDetailResponse
import com.app.xtrahelpcaregiver.Response.ResourceResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.bumptech.glide.Glide
import kotlinx.android.synthetic.main.activity_blog_details.*
import kotlinx.android.synthetic.main.activity_blog_details.relative
import kotlinx.android.synthetic.main.activity_blog_list.*
import kotlinx.android.synthetic.main.fragment_home.*
import kotlinx.android.synthetic.main.fragment_home.recyclerBlog
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class BlogDetailsActivity : BaseActivity() {

    var blogId: String = ""
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_blog_details)
        blogId = intent.getStringExtra("blogId").toString();
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)

        getBlogDetailApi()
    }


    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }

    private fun getBlogDetailApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = ResourceDetailRequest(
                ResourceDetailRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString() ,
                    blogId
                )
            )

            val signUp: Call<ResourceDetailResponse?> =
                RetrofitClient.getClient.getResourceDetail(langTokenRequest)
            signUp.enqueue(object : Callback<ResourceDetailResponse?> {
                override fun onResponse(
                    call: Call<ResourceDetailResponse?>,
                    response: Response<ResourceDetailResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: ResourceDetailResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                            Glide.with(activity)
                                .load(response.data.thumbImageUrl)
                                .centerCrop()
                                .placeholder(R.drawable.main_placeholder)
                                .into(image)

                                txtBlogTitle.text=response.data.title
                                txtDesc.text=response.data.description
                                txtCategory.text=response.data.categoryName

                            }
                            "6" -> {
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
                    call: Call<ResourceDetailResponse?>,
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