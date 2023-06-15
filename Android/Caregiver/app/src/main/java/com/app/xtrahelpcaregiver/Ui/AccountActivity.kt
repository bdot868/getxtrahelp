package com.app.xtrahelpcaregiver.Ui

import android.app.Dialog
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.Window
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Adapter.TransactionAdapter
import com.app.xtrahelpcaregiver.CustomView.CustomMarkerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.*
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.github.mikephil.charting.charts.LineChart
import com.github.mikephil.charting.components.XAxis
import com.github.mikephil.charting.components.YAxis
import com.github.mikephil.charting.data.Entry
import com.github.mikephil.charting.data.LineData
import com.github.mikephil.charting.data.LineDataSet
import com.github.mikephil.charting.interfaces.datasets.ILineDataSet
import com.github.mikephil.charting.utils.Utils
import com.whiteelephant.monthpicker.MonthPickerDialog
import kotlinx.android.synthetic.main.activity_account.*
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.*
import kotlin.collections.ArrayList

class AccountActivity : BaseActivity() {
    var xAxisValues: List<String> = ArrayList(
        listOf("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC")
    )

    var amount = java.util.ArrayList<String>()
    var month = java.util.ArrayList<String>()

    var yVals = ArrayList<Entry>()

    lateinit var transactionAdapter: TransactionAdapter
    lateinit var walletAmountResponse: WalletAmountResponse
    var chart: LineChart? = null

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true
    var transactionList: ArrayList<CaregiverTransactionResponse.Data> = ArrayList()

    private var startMonth = -1
    private var startYear: Int = -1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_account)
        txtTitle.text = "Accounts"
        init()
    }


    private fun init() {
        arrowBack.setOnClickListener(this)
        txtWithdraw.setOnClickListener(this)
        txtUpdateBankDetail.setOnClickListener(this)
        txtYear.setOnClickListener(this)
        txtYear.text = Calendar.getInstance().get(Calendar.YEAR).toString()

        chart = findViewById(R.id.chart)

        transactionAdapter = TransactionAdapter(activity)
        recyclerTransaction.layoutManager = LinearLayoutManager(activity)
        recyclerTransaction.isNestedScrollingEnabled = false
        recyclerTransaction.adapter = transactionAdapter

//        setData(30,180)
        initJobLineChartView()
        nestedScroll.viewTreeObserver
            .addOnScrollChangedListener {
                val view = nestedScroll.getChildAt(nestedScroll.childCount - 1) as View
                val diff: Int = view.bottom - (nestedScroll.height + nestedScroll
                    .scrollY)
                if (diff == 0 && pageNum != totalPage!!.toInt()) {
                    pageNum++
                    isClearList = false
                    getTransactionApi()
                }
            }
    }

    override fun onResume() {
        super.onResume()
        pageNum = 1
        isClearList = true
        getTransactionApi()

        getUserDetailsApi()
        getWalletAmountApi()
        getGraphDataApi("")
    }

    private fun initJobLineChartView() {
        val finalDataSet: ArrayList<ILineDataSet> = java.util.ArrayList()

        val jobDataSet = LineDataSet(yVals, "Job Earning")
        jobDataSet.lineWidth = 0.0f
        jobDataSet.setDrawCircles(false)
        jobDataSet.setDrawValues(false)
        jobDataSet.setDrawFilled(true)
        jobDataSet.setDrawCircleHole(true)
        val drawable = ContextCompat.getDrawable(this, R.drawable.fade_red)
        jobDataSet.fillDrawable = drawable
        //        jobDataSet.setDrawHighlightIndicators(false);
//        val face = Typeface.createFromAsset(assets, "poppins_regular.ttf")
        finalDataSet.add(jobDataSet)
        val leftAxis: YAxis = chart?.axisLeft!!
        leftAxis.setDrawGridLines(false)
        leftAxis.setDrawAxisLine(false)
        leftAxis.setDrawLabels(true)
        leftAxis.isEnabled = true
//        leftAxis.typeface = face
        leftAxis.textColor = ContextCompat.getColor(activity, R.color.black)
        leftAxis.setPosition(YAxis.YAxisLabelPosition.INSIDE_CHART)

        var rightAxis: YAxis = chart?.axisRight!!
        rightAxis.isEnabled = false
//        rightAxis.typeface = face
        rightAxis.setDrawGridLines(false)
        rightAxis.setDrawAxisLine(false)
        rightAxis.setDrawLabels(false)
        rightAxis.textColor = ContextCompat.getColor(activity, R.color.txtLightPurple)
        rightAxis.setPosition(YAxis.YAxisLabelPosition.INSIDE_CHART)
        val xAxis: XAxis = chart?.xAxis!!
        xAxis.setDrawGridLines(false)
        xAxis.position = XAxis.XAxisPosition.BOTTOM_INSIDE
        val labels = java.util.ArrayList<String>()
//        val labels: ArrayList<ILineDataSet> = java.util.ArrayList()

        for (k in xAxisValues.indices) {
            val year = "2020"
            val day = "Fri"

            //            labels.add(month + "/" + day + "/" + year);
            labels.add(xAxisValues[k].toUpperCase() + " ")
        }
        val mv = CustomMarkerView(this, R.layout.custom_marker, labels)
        chart?.markerView = mv
        val set1: LineDataSet

        chart?.setTouchEnabled(true)
        chart?.setDrawGridBackground(false)
        chart?.setDrawBorders(false)
        chart?.setDrawBorders(false)
        chart?.data = (LineData(labels, finalDataSet))
        chart!!.setDescription("")
        chart?.legend?.isEnabled = false
        chart?.animateXY(2000, 2000)
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtUpdateBankDetail -> {
                startActivity(Intent(activity, BankDetailActivity::class.java))
            }
            R.id.txtWithdraw -> {
                if (pref.getString(Const.isStripeConnect) == "0" || pref.getString(Const.isStripeConnect) == "") {
                    connectStripe()
                } else if (pref.getString(Const.isBankDetail) == "0" || pref.getString(Const.isBankDetail) == "") {
                    startActivity(Intent(activity, BankDetailActivity::class.java))
                } else {
                    withdrawPopup()
                }
            }
            R.id.txtYear -> {
                yearDatePicker()
            }
        }
    }

    private fun yearDatePicker() {
        val today = Calendar.getInstance()
        val builder = MonthPickerDialog.Builder(
            this,
            { selectedMonth: Int, selectedYear: Int ->
                startYear = selectedYear
                startMonth = selectedMonth + 1
                txtYear.text = selectedYear.toString() + ""
                getGraphDataApi(selectedYear.toString() + "")
            },
            if (startYear == -1) today[Calendar.YEAR] else startYear,
            if (startMonth == -1) today[Calendar.MONTH] else startMonth - 1
        )
        builder.setActivatedYear(if (startYear == -1) today[Calendar.YEAR] else startYear)
            .setTitle("Select Year")
            .showYearOnly()
            .build().show()
    }


    private fun connectStripe() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString()
                )
            )
            val signUp: Call<ConnectStripeResponse?> =
                RetrofitClient.getClient.connectStripe(langTokenRequest)
            signUp.enqueue(object : Callback<ConnectStripeResponse?> {
                override fun onResponse(
                    call: Call<ConnectStripeResponse?>,
                    response: Response<ConnectStripeResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: ConnectStripeResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                startActivityForResult(
                                    Intent(activity, StripConnectActivity::class.java)
                                        .putExtra(
                                            StripConnectActivity.URLS, response.url
                                        ), 1234
                                )
                                finish()
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<ConnectStripeResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getUserDetailsApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<LoginResponse?> =
                RetrofitClient.getClient.getUserInfo(langTokenRequest)
            signUp.enqueue(object : Callback<LoginResponse?> {
                override fun onResponse(
                    call: Call<LoginResponse?>, response: Response<LoginResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: LoginResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                pref.setString(
                                    Const.isStripeConnect,
                                    loginResponse.data.isStripeConnect
                                )
                                pref.setString(Const.isBankDetail, loginResponse.data.isBankDetail)
                            }
                            "6" -> {
                                utils.showCustomToast(loginResponse.message)
                            }
                            else -> {
                                checkStatus(relative, loginResponse.status, loginResponse.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<LoginResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getWalletAmountApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString()
                )
            )
            val signUp: Call<WalletAmountResponse?> =
                RetrofitClient.getClient.getWalletAmount(langTokenRequest)
            signUp.enqueue(object : Callback<WalletAmountResponse?> {
                override fun onResponse(
                    call: Call<WalletAmountResponse?>,
                    response: Response<WalletAmountResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        walletAmountResponse = response.body()!!

                        when (walletAmountResponse.status) {

                            "1" -> {
                                val data = walletAmountResponse.data
                                txtAmount.text = data.walletAmountFormat

                                txtTotalAmount.text = data.walletAmountInFormat
                                txtWithdrawAmount.text = data.walletAmountOutFormat
                            }
                            else -> {
//                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<WalletAmountResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun withdrawPopup() {
        val alertDialog = Dialog(activity)
        alertDialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        alertDialog.setCanceledOnTouchOutside(false)
        alertDialog.setCancelable(false)
        alertDialog.window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        alertDialog.setContentView(R.layout.withdraw_popup)
        val etAmount = alertDialog.findViewById<EditText>(R.id.etAmount)
        val close = alertDialog.findViewById<ImageView>(R.id.close)
        val txtWithdraw = alertDialog.findViewById<TextView>(R.id.txtWithdraw)

        txtWithdraw.setOnClickListener { v: View? ->
            if (etAmount.text.toString().isNotEmpty()) {
                var amount: String
                amount = walletAmountResponse.data.walletAmount
                amount = amount.replace(",", "")

                val enteredAmount = etAmount.text.toString().toFloat()
                val totalAmount = amount.toFloat()

                if (enteredAmount > totalAmount) {
                    utils.showCustomToast("Your withdrawal amount exceeds the total amount")
                } else if (enteredAmount <= 0) {
                    utils.showCustomToast("Amount should be $1 or more")
                } else {
                    withdrawApi(enteredAmount)
                    alertDialog.dismiss()
                }
            }
        }
        close.setOnClickListener { v: View? -> alertDialog.dismiss() }
        alertDialog.show()
    }

    private fun withdrawApi(enteredAmount: Float) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = WithdrawMoneyRequest(
                WithdrawMoneyRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    enteredAmount.toString()
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.withdrawMoney(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>, response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: CommonResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                utils.customToast(activity, loginResponse.message)
                                getTransactionApi()

                                getUserDetailsApi()
                                getWalletAmountApi()
                                getGraphDataApi("")
//                                finish()
                            }
                            "6" -> {
//                                utils.showCustomToast(loginResponse.message)
                            }
                            else -> {
                                checkStatus(relative, loginResponse.status, loginResponse.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<CommonResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getTransactionApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CaregiverTransactionRequest(
                CaregiverTransactionRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    pageNum,
                    "10",
                )
            )

            val signUp: Call<CaregiverTransactionResponse?> =
                RetrofitClient.getClient.caregiverAccountTransaction(langTokenRequest)
            signUp.enqueue(object : Callback<CaregiverTransactionResponse?> {
                override fun onResponse(
                    call: Call<CaregiverTransactionResponse?>,
                    response: Response<CaregiverTransactionResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CaregiverTransactionResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                linearTransaction.visibility = View.VISIBLE
                                if (isClearList) {
                                    transactionList.clear()
                                }
                                totalPage = response.totalPages

                                transactionList.addAll(response.data)
                                transactionAdapter?.setAdapterList(transactionList)
                                transactionAdapter?.notifyDataSetChanged()

                            }
                            "6" -> {
                                linearTransaction.visibility = View.GONE
                            }

                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<CaregiverTransactionResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getGraphDataApi(year:String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = AccountChartDataRequest(
                AccountChartDataRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    year,
                )
            )

            val signUp: Call<AccountChartDataResponse?> =
                RetrofitClient.getClient.getAccountChartData(langTokenRequest)
            signUp.enqueue(object : Callback<AccountChartDataResponse?> {
                override fun onResponse(
                    call: Call<AccountChartDataResponse?>,
                    response: Response<AccountChartDataResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: AccountChartDataResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                yVals = ArrayList<Entry>()

                                for (i in response.data.indices) {
                                    yVals.add(Entry(response.data[i].amount.toFloat(), i))
                                }
                                initJobLineChartView()
//                                setData(30,180)

                            }
                            "6" -> {
                                linearTransaction.visibility = View.GONE
                            }

                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<AccountChartDataResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }
}