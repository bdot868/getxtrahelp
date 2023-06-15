package com.app.xtrahelpcaregiver.Ui

import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.view.View
import android.view.ViewTreeObserver.OnScrollChangedListener
import android.view.inputmethod.EditorInfo
import android.widget.TextView.OnEditorActionListener
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Adapter.FAQAdapter
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.FaqData
import com.app.xtrahelpcaregiver.Request.FaqRequest
import com.app.xtrahelpcaregiver.Request.LangTokenSearch
import com.app.xtrahelpcaregiver.Request.LangTokenSearchRequest
import com.app.xtrahelpcaregiver.Response.Faq
import com.app.xtrahelpcaregiver.Response.FaqResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import kotlinx.android.synthetic.main.activity_faqs.*
import kotlinx.android.synthetic.main.activity_faqs.relative
import kotlinx.android.synthetic.main.header.*
import kotlinx.android.synthetic.main.header.arrowBack
import kotlinx.android.synthetic.main.header.txtTitle
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.ArrayList

class FAQsActivity : BaseActivity() {

    lateinit var faqAdapter: FAQAdapter

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true

    var faqList: ArrayList<Faq> = ArrayList<Faq>()
    var search = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_faqs)
        txtTitle.text = "FAQs"
        init()
    }

    override fun onResume() {
        super.onResume()
        pageNum = 1
        isClearList = true
        faqApi(search)
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        linearTicket.setOnClickListener(this)
        txtTalkSupport.setOnClickListener(this)

        etSearch.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable) {
                if (TextUtils.isEmpty(s.toString().trim { it <= ' ' })) {
                    faqList.clear()
                    search = ""
                    faqApi(search)
                }
            }
        })

        etSearch.setOnEditorActionListener(OnEditorActionListener { v, i, event ->
            if (i == EditorInfo.IME_ACTION_SEARCH) {
                faqList.clear()
                search = etSearch.text.toString().trim { it <= ' ' }
                faqApi(search)
                utils.hideKeyBoardFromView(activity)
                return@OnEditorActionListener true
            }
            false
        })


        nestedScroll.getViewTreeObserver().addOnScrollChangedListener(OnScrollChangedListener {
            val view = nestedScroll.getChildAt(nestedScroll.getChildCount() - 1) as View
            val diff: Int = view.bottom - (nestedScroll.getHeight() + nestedScroll
                .getScrollY())
            if (diff == 0 && pageNum != totalPage!!.toInt()) {
                pageNum++
                isClearList = false
                faqApi(search)
            }
        })

        faqAdapter = FAQAdapter(activity)
        recyclerFaq.layoutManager = LinearLayoutManager(activity)
        recyclerFaq.isNestedScrollingEnabled = false
        recyclerFaq.adapter = faqAdapter
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.linearTicket -> startActivity(Intent(activity, SupportActivity::class.java))
            R.id.txtTalkSupport -> startActivity(Intent(activity, SupportActivity::class.java))
        }
    }

    private fun faqApi(search: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = FaqRequest(
                FaqData(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    search,
                    "2",
                    pageNum,
                    "15"
                )
            )

            val signUp: Call<FaqResponse?> =
                RetrofitClient.getClient.faq(langTokenRequest)
            signUp.enqueue(object : Callback<FaqResponse?> {
                override fun onResponse(
                    call: Call<FaqResponse?>,
                    response: Response<FaqResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: FaqResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                                recyclerFaq.visibility = View.VISIBLE
                                if (isClearList) {
                                    faqList.clear()
                                }
                                totalPage = response.totalPages
                                lblDataNotFound.visibility = View.GONE

                                faqList.addAll(response.data)
                                faqAdapter.setAdapterList(faqList)
                                faqAdapter.notifyDataSetChanged()

                                if (faqAdapter.itemCount === 0) {
                                    lblDataNotFound.visibility = View.VISIBLE
                                    lblDataNotFound.text = response.message
                                } else {
                                    lblDataNotFound.visibility = View.GONE
                                }

                                if (response.activeSupportTicketCount == "0") {
                                    txtUnreadTicket.visibility = View.GONE
                                } else {
                                    txtUnreadTicket.visibility = View.VISIBLE
                                    txtUnreadTicket.text = response.activeSupportTicketCount
                                }
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
                    call: Call<FaqResponse?>,
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