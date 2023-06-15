package com.app.xtrahelpuser.Ui

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Request.CommonData
import com.app.xtrahelpcaregiver.Request.CommonDataRequest
import com.app.xtrahelpcaregiver.Request.LangToken
import com.app.xtrahelpcaregiver.Request.LangTokenRequest
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.DisabilitiesTypeAdapter
import com.app.xtrahelpuser.Adapter.LovedOneAdapter
import com.app.xtrahelpuser.Adapter.RecipientsAdapter
import com.app.xtrahelpuser.Interface.AddCategoryInClass
import com.app.xtrahelpuser.Interface.SelectBehaviorVerbalClick
import com.app.xtrahelpuser.Interface.SelectDisabilitiesClick
import com.app.xtrahelpuser.Interface.SpecialitiesClass
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.AboutLoveData
import com.app.xtrahelpuser.Request.LovedOne
import com.app.xtrahelpuser.Request.SaveAboutLovedRequest
import com.app.xtrahelpuser.Response.GetLovedOneResponse
import com.bumptech.glide.Glide
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.gson.Gson
import kotlinx.android.synthetic.main.activity_about_loved_one.*
import kotlinx.android.synthetic.main.activity_about_loved_one.arrowBack
import kotlinx.android.synthetic.main.activity_about_loved_one.relative
import kotlinx.android.synthetic.main.activity_about_loved_one.txtNext
import kotlinx.android.synthetic.main.activity_personal_detail.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.*
import kotlin.collections.ArrayList

class AboutLovedOneActivity : BaseActivity(),
    AddCategoryInClass, SpecialitiesClass, SelectBehaviorVerbalClick, SelectDisabilitiesClick {

    lateinit var recipientsAdapter: RecipientsAdapter
    lateinit var lovedOneAdapter: LovedOneAdapter
    lateinit var disabilitiesTypeAdapter: DisabilitiesTypeAdapter

    companion object {
        var lovedOneList: ArrayList<LovedOne> = ArrayList()
    }

    val lovedDisabilitiesTypeList: ArrayList<LovedDisabilitiesType> = ArrayList()
    val lovedCategoryList: ArrayList<LovedCategory> = ArrayList()
    val lovedSpecialitiesList: ArrayList<LovedSpecialities> = ArrayList()

    var recipientsList: ArrayList<String> = ArrayList()
    lateinit var dialog: BottomSheetDialog

    val selectedLovedCategory: ArrayList<String> = ArrayList()
    val selectedLovedSpecialities: ArrayList<String> = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_about_loved_one)
        init()

    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtNext.setOnClickListener(this)
        txtNumOfRecipients.setOnClickListener(this)

        for (i in 0..9) {
            recipientsList.add((i + 1).toString())
        }


        getCommonDataApi()
        lovedOneList.clear()

        lovedOneAdapter =
            LovedOneAdapter(
                activity,
                lovedOneList,
                lovedDisabilitiesTypeList,
                lovedCategoryList,
                lovedSpecialitiesList
            )

        recyclerLovedOne.layoutManager = LinearLayoutManager(activity)
        recyclerLovedOne.isNestedScrollingEnabled = false
        recyclerLovedOne.adapter = lovedOneAdapter
        lovedOneAdapter.selectDisabilitiesClick(this)
        lovedOneAdapter.selectBehaviorVerbalClick(this)
        lovedOneAdapter.addCategoryInClass(this)
        lovedOneAdapter.specialitiesClass(this)

        getAboutLovedApi()
    }

    override fun onBackPressed() {
        super.onBackPressed()
        startActivity(Intent(activity, PersonalDetailActivity::class.java))
        finish()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
//            R.id.txtBehavioral -> selectBehavioral(txtBehavioral)
//            R.id.txtNonBehavioral -> selectBehavioral(txtNonBehavioral)
//            R.id.txtVerbal -> selectVerbal(txtVerbal)
//            R.id.txtNonVerbal -> selectVerbal(txtNonVerbal)
            R.id.txtNumOfRecipients -> showSelectRecipientsDialog()
            R.id.txtNext -> {
                if (txtNumOfRecipients.text.toString().isEmpty()) {
                    utils.showSnackBar(
                        relative,
                        activity,
                        "Please select atleast one recipient",
                        Const.alert,
                        Const.successDuration
                    )
                } else {
                    if (isValid()) {
                        saveAboutLovedOneApi()
                    }
                }

            }

        }
    }

    fun saveAboutLovedOneApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val savePersonalDetailRequest = SaveAboutLovedRequest(
                AboutLoveData(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    "3",
                    lovedOneList
                )
            )

            val signUp: Call<LoginResponse?> =
                RetrofitClient.getClient.saveAboutLoved(savePersonalDetailRequest)
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
                                    Const.profileStatus,
                                    loginResponse.data.profileStatus
                                )
                                loginActivity()
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


    private fun getAboutLovedApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<GetLovedOneResponse?> =
                RetrofitClient.getClient.getAboutLoved(langTokenRequest)
            signUp.enqueue(object : Callback<GetLovedOneResponse?> {
                override fun onResponse(
                    call: Call<GetLovedOneResponse?>, response: Response<GetLovedOneResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: GetLovedOneResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                lovedOneList.clear()
                                txtNumOfRecipients.text = response.data.size.toString()

                                for (i in response.data.indices) {
                                    var categoryIds: ArrayList<String> = ArrayList()
                                    var specialitiesIds: ArrayList<String> = ArrayList()

                                    for (c in response.data[i].lovedCategoryData.indices) {
                                        categoryIds.add(response.data[i].lovedCategoryData[c].lovedCategoryId)
                                    }

                                    for (s in response.data[i].loveSpecialitiesData.indices) {
                                        specialitiesIds.add(response.data[i].loveSpecialitiesData[s].lovedSpecialitiesId)
                                    }

                                    if (response.data[i].lovedOtherCategoryText.isNotEmpty()) {
                                        categoryIds.add("")
                                    }
                                    var isAllergies = false
                                    isAllergies = response.data[i].allergies != ""

                                    var lovedOne = LovedOne(
                                        response.data[i].lovedDisabilitiesTypeId,
                                        response.data[i].lovedAboutDesc,
                                        response.data[i].lovedOtherCategoryText,
                                        response.data[i].lovedBehavioral,
                                        response.data[i].lovedVerbal,
                                        response.data[i].allergies,
                                        categoryIds,
                                        specialitiesIds,
                                        isAllergies
                                    )
                                    lovedOneList.add(lovedOne)

                                    if (specialitiesIds.isNotEmpty()) {
                                        specialitiesMultiArrayList.add(specialitiesIds)
                                    } else {
                                        specialitiesMultiArrayList.add(ArrayList())
                                    }

                                    if (categoryIds.isNotEmpty()) {
                                        lovedCategoryMultiArrayList.add(categoryIds)
                                    } else {
                                        lovedCategoryMultiArrayList.add(ArrayList())
                                    }

//                                    specialitiesMultiArrayList.add(ArrayList())
                                }

                                lovedOneAdapter.notifyDataSetChanged()

                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<GetLovedOneResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }


    private fun getCommonDataApi() {
        if (utils.isNetworkAvailable()) {
//            utils.showProgress(activity)
            val commonDataRequest = CommonDataRequest(
                CommonData(
                    Const.langType,
                )
            )

            val signUp: Call<CommonDataResponse?> =
                RetrofitClient.getClient.getCommonData(commonDataRequest)
            signUp.enqueue(object : Callback<CommonDataResponse?> {
                override fun onResponse(
                    call: Call<CommonDataResponse?>, response: Response<CommonDataResponse?>
                ) {
//                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val commonDataResponse: CommonDataResponse = response.body()!!
                        when (commonDataResponse.status) {
                            "1" -> {
                                lovedDisabilitiesTypeList.clear()
                                lovedDisabilitiesTypeList.addAll(commonDataResponse.data.lovedDisabilitiesType)

                                lovedCategoryList.clear()
                                lovedCategoryList.addAll(commonDataResponse.data.lovedCategory)

                                val lovedCategory = LovedCategory("", "Other", "")
                                lovedCategoryList.add(lovedCategory)

                                lovedSpecialitiesList.clear()
                                lovedSpecialitiesList.addAll(
                                    commonDataResponse.data.lovedSpecialities
                                )

                                lovedOneAdapter.notifyDataSetChanged()
                            }
                            "6" -> {
                                utils.showCustomToast(commonDataResponse.message)
//                                getUserDetailsApi()
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    commonDataResponse.status,
                                    commonDataResponse.status
                                )
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<CommonDataResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun showSelectRecipientsDialog() {
        val layoutInflater = LayoutInflater.from(activity)
        val dialogView = layoutInflater.inflate(R.layout.common_popup, null)

        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtTitlePopup = dialog.findViewById<TextView>(R.id.txtTitlePopup)

        txtTitlePopup?.text = "Number of recipients needing care"

        val recyclerView: RecyclerView = dialog.findViewById(R.id.recyclerView)!!
        val txtDataNotFoundPopup: TextView = dialog.findViewById(R.id.txtDataNotFoundPopup)!!
        recyclerView.layoutManager = LinearLayoutManager(activity)

        recipientsAdapter = RecipientsAdapter(activity, recipientsList, object :
            RecipientsAdapter.CallbackListen {
            override fun clickItem(id: String) {
                txtNumOfRecipients.text = id
                calculation(id)
                dialog.dismiss()
            }
        })

        recyclerView.adapter = recipientsAdapter
        recipientsAdapter.notifyDataSetChanged()

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        dialog.show()
    }

    private fun calculation(id: String) {
        val size = id.toInt()
        when {
            size < lovedOneList.size -> {
                for (i in lovedOneList.size downTo size + 1) {
                    lovedOneList.removeAt(i - 1)
                    lovedCategoryMultiArrayList.removeAt(i - 1)
                    specialitiesMultiArrayList.removeAt(i - 1)
                }
                lovedOneAdapter.notifyDataSetChanged()
            }

            size > lovedOneList.size -> {
                for (i in lovedOneList.size until size) {
                    Log.e("TAG", "calculation: $i")
                    var lovedOne = LovedOne(
                        "",
                        "",
                        "",
                        "1",
                        "1",
                        "",
                        selectedLovedCategory,
                        selectedLovedSpecialities,
                        true
                    )
                    lovedOneList.add(i, lovedOne)
                    lovedCategoryMultiArrayList.add(ArrayList())
                    specialitiesMultiArrayList.add(ArrayList())
                }
                lovedOneAdapter.notifyDataSetChanged()
            }
        }
    }

    private fun isValid(): Boolean {
        var message: String
        message = ""

        for (i in lovedOneAdapter.lovedOneList.indices) {
            val count = i + 1
            if (lovedOneAdapter.lovedOneList[i].lovedDisabilitiesTypeId == "") {
                message = "Please select disabilities at recipient $count"
                break
            } else if (lovedOneAdapter.lovedOneList[i].lovedAboutDesc == "") {
                message = "Please enter description at recipient $count"
                break
            } else if (lovedOneAdapter.lovedOneList[i].lovedCategory.isEmpty()) {
                message = "Please select categories at recipient $count"
                break
            } else if (lovedOneAdapter.lovedOneList[i].lovedCategory.contains("") && lovedOneAdapter.lovedOneList[i].lovedOtherCategoryText.isEmpty()) {
                message = "Please enter other category type at recipient $count"
                break
            } else if (lovedOneAdapter.lovedOneList[i].isLovedOne && lovedOneAdapter.lovedOneList[i].allergies.isEmpty()) {
                message = "Please enter allergies at recipient $count"
                break
            } else if (lovedOneAdapter.lovedOneList[i].lovedSpecialities.isEmpty()) {
                message = "Please select Specialities at recipient $count"
                break
            }
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }

    override fun onDisabilitiesClick(pos: Int) {
        showTypeDialog(pos)
    }

    private fun showTypeDialog(position: Int) {
        val layoutInflater = LayoutInflater.from(activity)
        val dialogView = layoutInflater.inflate(R.layout.common_popup, null)

        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtTitlePopup = dialog.findViewById<TextView>(R.id.txtTitlePopup)

        txtTitlePopup?.text = "Select Type"

        val recyclerView: RecyclerView = dialog.findViewById(R.id.recyclerView)!!
        val txtDataNotFoundPopup: TextView = dialog.findViewById(R.id.txtDataNotFoundPopup)!!
        recyclerView.layoutManager = LinearLayoutManager(activity)

        disabilitiesTypeAdapter =
            DisabilitiesTypeAdapter(activity, lovedDisabilitiesTypeList, object :
                DisabilitiesTypeAdapter.CallbackListen {
                override fun clickItem(id: String) {
                    for (i in lovedDisabilitiesTypeList.indices) {
                        if (lovedDisabilitiesTypeList[i].lovedDisabilitiesTypeId == id) {
                            lovedOneList[position].lovedDisabilitiesTypeId =
                                lovedDisabilitiesTypeList[i].lovedDisabilitiesTypeId
                            lovedOneAdapter.notifyDataSetChanged()
                            dialog.dismiss()
                        }
                    }
                }
            })
        recyclerView.adapter = disabilitiesTypeAdapter
        disabilitiesTypeAdapter.notifyDataSetChanged()

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        dialog.show()
    }

    override fun behaviorVerbalClick(pos: Int, type: String, isFirst: Boolean) {
        if (type == "behavioral") {
            if (isFirst) {
                lovedOneList[pos].lovedBehavioral = "1"
            } else {
                lovedOneList[pos].lovedBehavioral = "2"
            }
        } else {
            if (isFirst) {
                lovedOneList[pos].lovedVerbal = "1"
            } else {
                lovedOneList[pos].lovedVerbal = "2"
            }
        }
        lovedOneAdapter.notifyDataSetChanged()
    }

    val lovedCategoryMultiArrayList = ArrayList<ArrayList<String>>()
    val specialitiesMultiArrayList = ArrayList<ArrayList<String>>()

    override fun onAddCategoryClass(
        mainPos: Int,
        selectedCategory: String?,
        isAdd: Boolean,
        otherString: String
    ) {

        if (selectedCategory != null) {
            if (isAdd) {
                if (!lovedCategoryMultiArrayList[mainPos].contains(selectedCategory))
                    lovedCategoryMultiArrayList[mainPos].add(selectedCategory)
            } else {
                lovedCategoryMultiArrayList[mainPos].remove(selectedCategory)
            }
            for (i in lovedCategoryMultiArrayList.indices) {
                lovedOneList[i].lovedCategory = ArrayList()
                lovedOneList[i].lovedCategory.addAll(lovedCategoryMultiArrayList[i])
            }
            Log.e("djsdhshdkhs", Gson().toJson(lovedOneList))
            lovedOneAdapter.notifyDataSetChanged()
        }
    }

    private var songs: Array<String> = arrayOf()
    fun add(input: String) {
        songs += input
    }

    override fun onAddSpecialitiesClass(mainPos: Int, selectedCategory: String?, isAdd: Boolean) {
        if (selectedCategory != null) {
            if (isAdd) {
                if (!specialitiesMultiArrayList[mainPos].contains(selectedCategory))
                    specialitiesMultiArrayList[mainPos].add(selectedCategory)
            } else {
                specialitiesMultiArrayList[mainPos].remove(selectedCategory)
            }

            for (i in specialitiesMultiArrayList.indices) {
                lovedOneList[i].lovedSpecialities = ArrayList()
                lovedOneList[i].lovedSpecialities.addAll(specialitiesMultiArrayList[i])
            }
            Log.e("djsdhshdkhs", Gson().toJson(lovedOneList))

            lovedOneAdapter.notifyDataSetChanged()

        }
    }
}