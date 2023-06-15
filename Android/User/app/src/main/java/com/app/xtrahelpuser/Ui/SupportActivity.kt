package com.app.xtrahelpuser.Ui

import android.os.Bundle
import android.view.View
import android.view.ViewTreeObserver
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.SupportListAdapter
import com.app.xtrahelpuser.Interface.ReopenClicklistner
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.*
import com.app.xtrahelpuser.Response.Ticket
import com.app.xtrahelpuser.Response.TicketResponse
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.android.synthetic.main.activity_support.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.ArrayList

class SupportActivity : BaseActivity() , ReopenClicklistner {

    lateinit var supportListAdapter: SupportListAdapter

    lateinit var dialog: BottomSheetDialog

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true
    lateinit var etName: EditText
    lateinit var etDesc: EditText

    var search = ""
    var supportList: ArrayList<Ticket> = ArrayList<Ticket>()


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_support)
        txtTitle.text = "Help & Support"
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtCreateTicket.setOnClickListener(this)

        nestedScroll.viewTreeObserver
            .addOnScrollChangedListener(ViewTreeObserver.OnScrollChangedListener {
                val view = nestedScroll.getChildAt(nestedScroll.getChildCount() - 1) as View
                val diff: Int = view.bottom - (nestedScroll.getHeight() + nestedScroll
                    .getScrollY())
                if (diff == 0 && pageNum != totalPage!!.toInt()) {
                    pageNum++
                    isClearList = false
                    supportApi()
                }
            })

        supportListAdapter = SupportListAdapter(activity)
        recyclerSupportList.layoutManager = LinearLayoutManager(activity)
        recyclerSupportList.isNestedScrollingEnabled = false
        recyclerSupportList.adapter = supportListAdapter
        supportListAdapter.reopenClicklistner(this)


    }

    override fun onResume() {
        super.onResume()
        pageNum = 1
        isClearList = true
        supportApi()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtCreateTicket -> showAddCardDialog()
        }
    }

    private fun showAddCardDialog() {
        val dialogView = layoutInflater.inflate(R.layout.create_ticket_popup, null)
        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        etName = dialog.findViewById<EditText>(R.id.etName)!!
        etDesc = dialog.findViewById<EditText>(R.id.etDesc)!!
        val txtStartChat = dialog.findViewById<TextView>(R.id.txtStartChat)

        closeImg!!.setOnClickListener { dialog.dismiss() }

        txtStartChat!!.setOnClickListener {
            if (isValid()) {
                setTicketApi()
            }
        }

        dialog.show()
    }

    private fun setTicketApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = SetTicketRequest(
                SetTicketData(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    etName.text.toString().toString(),
                    etDesc.text.toString().toString()
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.setTicket(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                                pageNum = 1
                                isClearList = true
                                supportApi()
                                dialog.dismiss()
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
                    call: Call<CommonResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun supportApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = GetTicketRequest(
                GetTicket(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    pageNum,
                    "10"
                )
            )
            val signUp: Call<TicketResponse?> =
                RetrofitClient.getClient.getTicket(langTokenRequest)
            signUp.enqueue(object : Callback<TicketResponse?> {
                override fun onResponse(
                    call: Call<TicketResponse?>,
                    response: Response<TicketResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: TicketResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                                recyclerSupportList.visibility = View.VISIBLE
                                lblDataNotFound.visibility = View.GONE

                                if (isClearList) {
                                    supportList.clear()
                                }
                                totalPage = response.totalPages

                                supportList.addAll(response.data)
                                supportListAdapter.setPage(supportList)
                                supportListAdapter.notifyDataSetChanged()

                                if (supportListAdapter.itemCount === 0) {
                                    lblDataNotFound.visibility = View.VISIBLE
                                    lblDataNotFound.text = response.message
                                } else {
                                    lblDataNotFound.visibility = View.GONE
                                }
                            }
                            "6" -> {
                                recyclerSupportList.visibility = View.GONE
                                lblDataNotFound.visibility = View.VISIBLE
                                lblDataNotFound.text=response.message
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
                    call: Call<TicketResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun reopenTicketApi(ticketId: String?) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = ReopenRequest(
                ReopenData(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    ticketId.toString()
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.reopenTicket(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                                pageNum = 1
                                isClearList = true
                                supportApi()
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
                    call: Call<CommonResponse?>,
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
        if (etName.text.toString().trim().isEmpty()) {
            message = getString(R.string.enterTitle)
            etName.requestFocus()
        } else if (etDesc.text.toString().trim().isEmpty()) {
            message = getString(R.string.enterDesc)
            etDesc.requestFocus()
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showCustomToast(message)
//            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()                           
    }

    override fun onReopenClick(ticketId: String?) {
        reopenTicketApi(ticketId)
    }
}