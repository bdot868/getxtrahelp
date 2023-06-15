package com.app.xtrahelpcaregiver.Ui

import android.app.DatePickerDialog
import android.content.DialogInterface
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.InsuranceAdapter
import com.app.xtrahelpcaregiver.Adapter.InsuranceTypeAdapter
import com.app.xtrahelpcaregiver.Interface.SelectClick
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.*
import com.app.xtrahelpcaregiver.Request.CommonData
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.FileUtils
import com.app.xtrahelpcaregiver.Utils.PermissionUtils
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.theartofdev.edmodo.cropper.CropImage
import kotlinx.android.synthetic.main.activity_insurance.*
import kotlinx.android.synthetic.main.activity_insurance.arrowBack
import kotlinx.android.synthetic.main.activity_insurance.linear
import kotlinx.android.synthetic.main.activity_insurance.relative
import kotlinx.android.synthetic.main.activity_insurance.txtAddMore
import kotlinx.android.synthetic.main.activity_insurance.txtNext
import kotlinx.android.synthetic.main.activity_insurance.txtNo
import kotlinx.android.synthetic.main.activity_insurance.txtSave
import kotlinx.android.synthetic.main.activity_insurance.txtYes
import kotlinx.android.synthetic.main.activity_personal_detail.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File
import java.util.*
import kotlin.collections.ArrayList

class InsuranceActivity : BaseActivity(), SelectClick, PermissionUtils.PermissionSettingsListener {

    var insurance = "2"
    lateinit var insuranceList: ArrayList<Insurance>
    lateinit var typeList: ArrayList<InsuranceType>

    lateinit var insuranceAdapter: InsuranceAdapter
    lateinit var insuranceTypeAdapter: InsuranceTypeAdapter

    var pos: Int = -1
    var datepicker: DatePickerDialog? = null
    lateinit var dialog: BottomSheetDialog

    companion object {
        val FROMEDIT = "fromEdit"
    }

    var fromEdit = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_insurance)
        fromEdit = intent.getBooleanExtra(EditProfileActivity.FROMEDIT, false)
        init()
    }


    private fun init() {
        if (fromEdit) {
            txtSave.visibility = View.VISIBLE
            txtNext.text = resources.getString(R.string.save_next)
        } else {
            txtSave.visibility = View.GONE
            txtNext.text = "Next"
        }

        arrowBack.setOnClickListener(this)
        txtNo.setOnClickListener(this)
        txtNext.setOnClickListener(this)
        txtYes.setOnClickListener(this)
        txtAddMore.setOnClickListener(this)
        txtSave.setOnClickListener(this)

        insuranceList = ArrayList()
        typeList = ArrayList()
        getCommonDataApi()

        insuranceAdapter = InsuranceAdapter(activity, insuranceList, typeList)
        recyclerInsurance.layoutManager = LinearLayoutManager(activity)
        recyclerInsurance.isNestedScrollingEnabled = false
        recyclerInsurance.adapter = insuranceAdapter
        insuranceAdapter.selectDateClick(this)


    }


    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtSave -> {
                if (insurance == "1") {
                    if (isValid()) {
                        saveInsurance(true)
                    }
                } else {
                    insuranceList.clear()
                    saveInsurance(true)
                }

//                startActivity(Intent(activity, SetAvailabilityActivity::class.java))
//                finish()
            }
            R.id.txtNext -> {
                if (insurance == "1") {
                    if (isValid()) {
                        saveInsurance(false)
                    }
                } else {
                    insuranceList.clear()
                    saveInsurance(false)
                }

//                startActivity(Intent(activity, SetAvailabilityActivity::class.java))
//                finish()
            }
            R.id.txtYes -> {
                insurance = "1"
                linear.visibility = View.VISIBLE
                setYesNo(txtYes)
            }
            R.id.txtNo -> {
                insurance = "2"
                linear.visibility = View.GONE
                setYesNo(txtNo)
            }

            R.id.txtAddMore -> addMore()
        }
    }

    private fun getInsuranceApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<GetInsuranceResponse?> =
                RetrofitClient.getClient.getInsurance(langTokenRequest)
            signUp.enqueue(object : Callback<GetInsuranceResponse?> {
                override fun onResponse(
                    call: Call<GetInsuranceResponse?>, response: Response<GetInsuranceResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: GetInsuranceResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                if (response.data.isEmpty()) {
                                    addMore()
                                } else {
                                    insurance = "1"
                                    linear.visibility = View.VISIBLE
                                    setYesNo(txtYes)
                                    for (i in response.data.indices) {
                                        val insuranceClass = Insurance(
                                            response.data[i].insuranceTypeId,
                                            response.data[i].insuranceName,
                                            response.data[i].insuranceNumber,
                                            response.data[i].expireDate,
                                            response.data[i].insuranceImageName,
                                        )
                                        insuranceList.add(insuranceClass)
                                    }
                                }
                                insuranceAdapter.notifyDataSetChanged()

                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                                insurance = "2"
                                linear.visibility = View.GONE
                                setYesNo(txtNo)
                                addMore()
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<GetInsuranceResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun saveInsurance(fromSave: Boolean) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            var profileStatus = ""
            if (!fromEdit) {
                profileStatus = "6"
            }
            val saveInsurance = SaveInsuranceRequest(
                SaveInsurance(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    insurance,
                    profileStatus,
                    insuranceList
                )
            )

            val signUp: Call<LoginResponse?> =
                RetrofitClient.getClient.saveInsurance(saveInsurance)
            signUp.enqueue(object : Callback<LoginResponse?> {
                override fun onResponse(
                    call: Call<LoginResponse?>, response: retrofit2.Response<LoginResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: LoginResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                Const.selectedCategory.clear()
                                pref.setString(
                                    Const.profileStatus,
                                    loginResponse.data.profileStatus
                                )
                                if (fromEdit) {
                                    if (fromSave) {
                                        finish()
                                    } else {
                                        startActivity(
                                            Intent(activity, SetAvailabilityActivity::class.java)
                                                .putExtra(SetAvailabilityActivity.FROMEDIT, true)
                                        )
                                        finish()
                                    }
                                } else {
                                    loginActivity()
                                }
                            }
                            "6" -> {
                                utils.showCustomToast(loginResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    loginResponse.status,
                                    loginResponse.message
                                )
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

    override fun onBackPressed() {
        super.onBackPressed()
        if (!fromEdit){
            startActivity(
                Intent(
                    activity,
                    WorkDetailsActivity::class.java
                ).putExtra(WorkDetailsActivity.FROMEDIT, fromEdit)
            )
        }
        finish()
    }

    private fun setYesNo(txt1: TextView) {
        txtYes.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtYes.background = resources.getDrawable(R.drawable.unselect_bg)
        txtNo.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtNo.background = resources.getDrawable(R.drawable.unselect_bg)

        txt1.setTextColor(resources.getColor(R.color.txtOrange))
        txt1.background = resources.getDrawable(R.drawable.select_bg)
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
                                typeList.clear()
                                typeList.addAll(commonDataResponse.data.insuranceType)
                                getInsuranceApi()
                            }
                            "6" -> {
                                utils.showCustomToast(commonDataResponse.message)
                                getInsuranceApi()
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

    private fun addMore() {
        val insurance = Insurance("", "", "", "", "")
        insuranceList.add(insurance)
        insuranceAdapter.notifyDataSetChanged()

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

        insuranceTypeAdapter = InsuranceTypeAdapter(activity, typeList, object :
            InsuranceTypeAdapter.CallbackListen {
            override fun clickItem(id: String) {
                for (i in typeList.indices) {
                    if (typeList[i].insuranceTypeId == id) {
                        insuranceList[position].insuranceTypeId = typeList[i].insuranceTypeId
                        insuranceAdapter.notifyDataSetChanged()
                        dialog.dismiss()
                    }
                }
            }
        })
        recyclerView.adapter = insuranceTypeAdapter
        insuranceTypeAdapter.notifyDataSetChanged()

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        dialog.show()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == RESULT_CANCELED) {
            return
        }

        if (requestCode == 123) {
            utils.showCustomToast(getString(R.string.connected))
        }
        if (requestCode == GALLERY) {
            if (data != null) {
                val contentURI = data.data
                fileImage = File(FileUtils.getPath(this, contentURI))
                //                uploadMedia();
                beginCrop(contentURI)
            }
        } else if (requestCode == CAMERA && resultCode == RESULT_OK) {
            val image: File = File(path)
            val bmOptions = BitmapFactory.Options()
            val photo = BitmapFactory.decodeFile(image.absolutePath, bmOptions)
            val tempUri = Uri.fromFile(File(path))
            //            Uri tempUri = getImageUri(this, photo);
            fileImage = File(FileUtils.getPath(this, tempUri))
            //            uploadMedia();
            beginCrop(tempUri)
        }
        if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {
            val result = CropImage.getActivityResult(data)
            if (resultCode == RESULT_OK) {
                val resultUri = result.uri
                fileImage = File(resultUri.path)
                uploadGalleryMedia()
            } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
                val error = result.error
                utils.showCustomToast(error.localizedMessage)
            }
        }
        if (requestCode == 123) {
            utils.showCustomToast(getString(R.string.connected))
        }

    }

    private fun uploadGalleryMedia() {
        if (fileImage != null) {
            val requestBody = RequestBody.create("*/*".toMediaTypeOrNull(), fileImage!!)
            Log.e("file name", "uploadMedia: $fileImage")
            val body: MultipartBody.Part =
                MultipartBody.Part.createFormData("files", fileImage!!.name, requestBody)
            val langType = RequestBody.create("text/plain".toMediaTypeOrNull(), "1")
            try {
                utils.showProgress(activity)
                val call: Call<MediaUploadResponse?>? =
                    RetrofitClient.getClient.mediaUpload(langType, body)
                call?.enqueue(object : Callback<MediaUploadResponse?> {
                    override fun onResponse(
                        call: Call<MediaUploadResponse?>,
                        response: Response<MediaUploadResponse?>
                    ) {
                        utils.dismissProgress()
                        if (response.isSuccessful) {
                            val mediaUploadResponse: MediaUploadResponse = response.body()!!
                            when (mediaUploadResponse.status) {
                                "1" -> {
                                    imageName = mediaUploadResponse.data[0].mediaName
                                    Log.e("TAG", "onResponse: $imageName")

                                    insuranceList[pos].insuranceImage =
                                        mediaUploadResponse.data[0].mediaName
                                    insuranceAdapter.notifyDataSetChanged()

                                }
                                "6" -> {
                                    utils.showCustomToast(mediaUploadResponse.message)
                                }
                                else -> {
                                    checkStatus(
                                        relative,
                                        mediaUploadResponse.status,
                                        mediaUploadResponse.message
                                    )
                                }
                            }
                        }
                    }

                    override fun onFailure(call: Call<MediaUploadResponse?>, t: Throwable) {
                        utils.dismissProgress()
                        utils.showCustomToast(resources.getString(R.string.server_not_responding))
                    }
                })
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun removePopup(pos: Int) {
        MaterialAlertDialogBuilder(this)
            .setCancelable(false)
            .setMessage("Are you sure want to remove this insurance?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int ->
                insuranceList.removeAt(pos)
                insuranceAdapter.notifyDataSetChanged()
            }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }

    private fun selectDate(position: Int) {
        val year: Int
        val month: Int
        val dayOfMonth: Int
        val calendar: Calendar = Calendar.getInstance()
        year = calendar[Calendar.YEAR]
        month = calendar[Calendar.MONTH]
        dayOfMonth = calendar[Calendar.DAY_OF_MONTH]

        datepicker = DatePickerDialog(
            activity,
            { view, year, monthOfYear, dayOfMonth ->
                var monthOfYear = monthOfYear
                var strMonth = ""
                var strDay = ""
                monthOfYear = monthOfYear + 1
                strDay = if (dayOfMonth < 10) {
                    "0$dayOfMonth"
                } else {
                    "" + dayOfMonth
                }
                strMonth = if (monthOfYear < 10) {
                    "0$monthOfYear"
                } else {
                    "" + monthOfYear
                }
                insuranceList[position].expireDate = "$year-$strMonth-$strDay"
                insuranceAdapter.notifyDataSetChanged()

            }, year, month, dayOfMonth
        )
        datepicker!!.datePicker.minDate = calendar.timeInMillis
        datepicker!!.show()
    }

    override fun onPermissionGranted(permission: Int) {
        when (permission) {
            PermissionUtils.PERMISSION_CAMERA_PICTURE -> takePhotoFromCamera()
            PermissionUtils.PERMISSION_GALLERY -> choosePhotoFromGallery()
        }
    }

    override fun onPermissionDenied(permission: Int) {
        TODO("Not yet implemented")
    }

    override fun selectClick(pos: Int, type: String?) {
        this.pos = pos
        when (type) {
            "imageUpload" -> {
                selectImage()
            }
            "remove" -> {
                removePopup(pos)
            }
            "showDialog" -> {
                showTypeDialog(pos)
            }
            "selectDate" -> {
                selectDate(pos)
            }
        }
    }

    private fun isValid(): Boolean {
        var message: String
        message = ""

        for (i in insuranceAdapter.insuranceList.indices) {
            val count = i + 1
            if (insuranceAdapter.insuranceList[i].insuranceTypeId == "") {
                message = "Please select type $count"
                break
            } else if (insuranceAdapter.insuranceList[i].insuranceName == "") {
                message = "Please enter license name $count"
                break
            } else if (insuranceAdapter.insuranceList[i].insuranceNumber == "") {
                message = "Please enter license number $count"
                break
            } else if (insuranceAdapter.insuranceList[i].expireDate == "") {
                message = "Please select expire date $count"
                break
            } else if (insuranceAdapter.insuranceList[i].insuranceImage == "") {
                message = "Please upload insurance image $count"
                break
            }
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }

}