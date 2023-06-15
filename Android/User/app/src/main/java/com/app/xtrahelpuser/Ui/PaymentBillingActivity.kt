package com.app.xtrahelpuser.Ui

import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Request.LangToken
import com.app.xtrahelpcaregiver.Request.LangTokenRequest
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.CardAdapter
import com.app.xtrahelpuser.Adapter.TransactionAdapter
import com.app.xtrahelpuser.CustomView.CardType
import com.app.xtrahelpuser.CustomView.CreditCardFormattingTextWatcher
import com.app.xtrahelpuser.Interface.CardDeleteClickListner
import com.app.xtrahelpuser.Interface.CardTypeDetect
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.RemoveCardRequest
import com.app.xtrahelpuser.Request.SaveCardRequest
import com.app.xtrahelpuser.Response.GetCardListResponse
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.android.synthetic.main.activity_applicants_list.*
import kotlinx.android.synthetic.main.activity_payment_billing.*
import kotlinx.android.synthetic.main.activity_payment_billing.relative
import kotlinx.android.synthetic.main.header.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*


class PaymentBillingActivity : BaseActivity(), CardTypeDetect, CardDeleteClickListner {

    companion object {
        val FROMJOB = "fromJob"
    }

    lateinit var cardAdapter: CardAdapter
    lateinit var transactionAdapter: TransactionAdapter
    lateinit var replaceCardNumber: String
    lateinit var mLastInput: String
    lateinit var exMonth: kotlin.String
    lateinit var exYear: kotlin.String

    var cardList: ArrayList<GetCardListResponse.Data> = ArrayList()
    var totalCardNumber = 0

    lateinit var card: ImageView
    lateinit var etName: EditText
    lateinit var etCardNumber: EditText
    lateinit var etExDate: EditText
    lateinit var etCVV: EditText
    lateinit var dialog: BottomSheetDialog

    var fromJob = ""
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_payment_billing)
        txtTitle.text = "Billing and payments"
        fromJob = intent.getStringExtra(FROMJOB).toString()
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtAddCard.setOnClickListener(this)

        getCardListApi()

        cardAdapter = CardAdapter(activity, cardList, fromJob)
        recyclerCard.layoutManager = LinearLayoutManager(activity)
        recyclerCard.isNestedScrollingEnabled = false
        recyclerCard.adapter = cardAdapter
        cardAdapter.cardDeleteClickListner(this)

        transactionAdapter = TransactionAdapter(activity)
        recyclerTransaction.layoutManager = LinearLayoutManager(activity)
        recyclerTransaction.isNestedScrollingEnabled = false
        recyclerTransaction.adapter = transactionAdapter

    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtAddCard -> showAddCardDialog()
        }
    }


    private fun showAddCardDialog() {
        val dialogView = layoutInflater.inflate(R.layout.add_card_popup, null)
        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        etName = dialog.findViewById(R.id.etName)!!
        etCardNumber = dialog.findViewById(R.id.etCardNumber)!!
        etExDate = dialog.findViewById(R.id.etExDate)!!
        etCVV = dialog.findViewById(R.id.etCVV)!!
        card = dialog.findViewById(R.id.card)!!
        val txtAddCard: TextView = dialog.findViewById(R.id.txtAddCard)!!

        val formatter = SimpleDateFormat("MM/yy", Locale.GERMANY)
        val expiryDateDate = Calendar.getInstance()
        etCardNumber!!.addTextChangedListener(CreditCardFormattingTextWatcher(etCardNumber))

        try {
            expiryDateDate.time = formatter.parse(etExDate!!.text.toString())
        } catch (e: ParseException) {
        }

        etCardNumber?.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                Log.d("DEBUG", "beforeTextChanged : $s")
                //                CardType.detect(etCardNumber.getText().toString().trim());
                CardType.fromCardNumber(etCardNumber.text.toString().trim())
                CardType.setCardTypeDetect(this@PaymentBillingActivity)

                if (etCardNumber.text.toString() == "") {
                    card.setImageResource(R.drawable.card)
                }
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {}
        })

        etExDate!!.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable) {
                mLastInput = etExDate!!.text.toString()
                var input = s.toString()
                val formatter = SimpleDateFormat("MM/yy", Locale.US)
                val expiryDateDate = Calendar.getInstance()
                try {
                    expiryDateDate.time = formatter.parse(input)
                } catch (e: ParseException) {
                    if (s.length == 2 && !mLastInput.endsWith("/")) {
                        val month = input.toInt()
                        if (month <= 12) {
                            etExDate.setText(etExDate.text.toString() + "/")
                            etExDate.setSelection(etExDate.text.toString().length)
                        }
                    } else if (s.length == 2 && mLastInput.endsWith("/")) {
                        input = input.replace("/", "")
                        val month = input.toInt()
                        if (month <= 12) {
                            etExDate.setText(etExDate.text.toString().substring(0, 1))
                            etExDate.setSelection(etExDate.text.toString().length)
                        } else {
                            etExDate.setText("")
                            etExDate.setSelection(etExDate.text.toString().length)
                            Toast.makeText(
                                applicationContext,
                                "Enter a valid month",
                                Toast.LENGTH_LONG
                            ).show()
                        }
                    } else if (s.length == 1) {
                        val month = input.toInt()
                        if (month > 1) {
                            etExDate.setText("0" + etExDate.text.toString() + "/")
                            etExDate.setSelection(etExDate.text.toString().length)
                        }
                    } else {
                    }
                    mLastInput = etExDate.text.toString()
                    return
                }
            }
        })

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        txtAddCard.setOnClickListener {
            if (isValid()) {
                saveUserCardApi()
            }
        }
        dialog.show()
    }

    private fun getCardListApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<GetCardListResponse?> =
                RetrofitClient.getClient.getUserCardList(langTokenRequest)
            signUp.enqueue(object : Callback<GetCardListResponse?> {
                override fun onResponse(
                    call: Call<GetCardListResponse?>,
                    response: Response<GetCardListResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: GetCardListResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                recyclerCard.visibility = View.VISIBLE
                                txtCardNotFound.visibility = View.GONE

                                cardList.clear()
                                cardList.addAll(response.data)
                                cardAdapter.notifyDataSetChanged()

                            }
                            "6" -> {
                                recyclerCard.visibility = View.GONE
                                txtCardNotFound.visibility = View.VISIBLE
                                txtCardNotFound.text = response.message
//                                utils.showCustomToast(response.message)
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<GetCardListResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    override fun cardType(type: String?) {
        when {
            type.equals("VISA", ignoreCase = true) -> {
                card.setImageResource(R.drawable.visa)
                totalCardNumber = 16
            }
            type.equals("MASTERCARD", ignoreCase = true) -> {
                card.setImageResource(R.drawable.master)
                totalCardNumber = 16
            }
            type.equals("JCB", ignoreCase = true) -> {
                card.setImageResource(R.drawable.jcb)
                totalCardNumber = 16
            }
            type.equals("MAESTRO", ignoreCase = true) -> {
                card.setImageResource(R.drawable.maestro)
                totalCardNumber = 16
            }
            type.equals("DISCOVER", ignoreCase = true) -> {
                card.setImageResource(R.drawable.dicover)
                totalCardNumber = 16
            }
            type.equals("AMEX", ignoreCase = true) -> {
                card.setImageResource(R.drawable.american_express)
                totalCardNumber = 15
            }
            type.equals("DINERSCLUB", ignoreCase = true) -> {
                card.setImageResource(R.drawable.diners)
                totalCardNumber = 16
            }
            type.equals("UNION", ignoreCase = true) -> {
                card.setImageResource(R.drawable.union)
                totalCardNumber = 16
            }
            type.equals("", ignoreCase = true) -> {
                card.setImageResource(R.drawable.card)
            }
        }
    }

    private fun saveUserCardApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val expiry =
                etExDate.text.toString().trim { it <= ' ' }.split("/".toRegex()).toTypedArray()
            exMonth = expiry[0]
            exYear = expiry[1]

            val langTokenRequest = SaveCardRequest(
                SaveCardRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    etName.text.toString().trim(),
                    etCardNumber.text.toString().trim(),
                    exMonth,
                    exYear,
                    etCVV.text.toString()
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.saveUserCard(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                utils.showCustomToast(response.message)
                                dialog.dismiss()
                                getCardListApi()
                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                            }
                            "0" -> {
                                utils.showCustomToast(response.message)
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
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

    private fun deleteCardApi(cardId: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = RemoveCardRequest(
                RemoveCardRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    cardId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.removeUserCard(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CommonResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                utils.showCustomToast(response.message)
                                getCardListApi()
                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                            }
                            "0" -> {
                                utils.showCustomToast(response.message)
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
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

    private fun isValid(): Boolean {
        var message = ""
        replaceCardNumber = etCardNumber.getText().toString().trim { it <= ' ' }
        replaceCardNumber = replaceCardNumber.replace("-", "")

        if (etName.text.toString() == "") {
            message = resources.getString(R.string.enter_card_holder_name)
            etName.requestFocus()
        } else if (TextUtils.isEmpty(replaceCardNumber) || etCardNumber.text.toString() == "") {
            message = resources.getString(R.string.enter_card_number)
            etCardNumber.requestFocus()
        } else if (TextUtils.isEmpty(replaceCardNumber) || replaceCardNumber.length != totalCardNumber) {
            message = resources.getString(R.string.enter_card_valid_number)
            etCardNumber.requestFocus()
        } else if (etExDate.text.toString().trim() == "" || etExDate.text.toString().length != 5) {
            message = resources.getString(R.string.enter_expiry)
            etExDate.requestFocus()
        } else if (etCVV.text.toString().trim() == "") {
            message = resources.getString(R.string.enter_cvv)
            etCVV.requestFocus()
        }
        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView(this)
            utils.showCustomToast(message)
        }
        return message.isEmpty()
    }

    override fun onCardDeleteClick(cardId: String) {
        deleteCardPopup(cardId)
    }

    override fun onCheckClick(cardId: String) {
        val returnIntent = Intent()
        returnIntent.putExtra("result", cardId)
        setResult(RESULT_OK, returnIntent)
        finish()
    }

    private fun deleteCardPopup(cardId: String) {
        MaterialAlertDialogBuilder(this)
            .setCancelable(false)
            .setMessage("Are you sure want to delete this card?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int ->
                deleteCardApi(cardId)
            }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }

}