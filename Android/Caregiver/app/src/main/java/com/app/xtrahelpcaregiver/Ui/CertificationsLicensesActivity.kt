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
import com.app.xtrahelpcaregiver.Adapter.CertificationAdapter
import com.app.xtrahelpcaregiver.Adapter.LicenseTypeAdapter
import com.app.xtrahelpcaregiver.Interface.SelectClick
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.*
import com.app.xtrahelpcaregiver.Request.CertificationsOrLicenses
import com.app.xtrahelpcaregiver.Request.CommonData
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.FileUtils
import com.app.xtrahelpcaregiver.Utils.PermissionUtils
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.bumptech.glide.Glide
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.theartofdev.edmodo.cropper.CropImage
import kotlinx.android.synthetic.main.activity_certifications_licenses.*
import kotlinx.android.synthetic.main.activity_certifications_licenses.arrowBack
import kotlinx.android.synthetic.main.activity_certifications_licenses.relative
import kotlinx.android.synthetic.main.activity_certifications_licenses.txtNext
import kotlinx.android.synthetic.main.activity_certifications_licenses.txtNo
import kotlinx.android.synthetic.main.activity_certifications_licenses.txtYes
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

class CertificationsLicensesActivity : BaseActivity(),
    SelectClick, PermissionUtils.PermissionSettingsListener {

    lateinit var certificationAdapter: CertificationAdapter
    private lateinit var certificationsOrLicensesList: ArrayList<CertificationsOrLicenses>
    private lateinit var licenceTypeList: ArrayList<LicenceType>
    var pos: Int = -1
    var datepicker: DatePickerDialog? = null
    lateinit var dialog: BottomSheetDialog
    lateinit var licenseTypeAdapter: LicenseTypeAdapter

    var haveCertificationsOrLicenses: String = "2"

    companion object {
        val FROMEDIT = "fromEdit"
    }

    var fromEdit = false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_certifications_licenses)
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

        txtNo.setOnClickListener(this)
        txtNext.setOnClickListener(this)
        txtYes.setOnClickListener(this)
        arrowBack.setOnClickListener(this)
        txtSave.setOnClickListener(this)
        txtAddMore.setOnClickListener(this)
        certificationsOrLicensesList = ArrayList()
        licenceTypeList = ArrayList()
        getCommonDataApi()

        certificationAdapter =
            CertificationAdapter(activity, certificationsOrLicensesList, licenceTypeList)
        recyclerCertification.layoutManager = LinearLayoutManager(activity)
        recyclerCertification.adapter = certificationAdapter
        certificationAdapter.selectDateClick(this)
        recyclerCertification.isNestedScrollingEnabled = false


    }


    private fun addMore() {
        val certificationsOrLicenses = CertificationsOrLicenses("", "", "", "", "", "", "")
        certificationsOrLicensesList.add(certificationsOrLicenses)
        certificationAdapter.notifyDataSetChanged()

    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtSave -> if (haveCertificationsOrLicenses == "1") {
                if (isValid()) {
                    saveCertificateApi(true)
                }
            } else {
                certificationsOrLicensesList.clear()
                saveCertificateApi(true)
            }
            R.id.txtNext -> if (haveCertificationsOrLicenses == "1") {
                if (isValid()) {
                    saveCertificateApi(false)
                }
            } else {
                certificationsOrLicensesList.clear()
                saveCertificateApi(false)
            }
            R.id.txtYes -> if (linear.visibility == View.GONE) {
                haveCertificationsOrLicenses = "1"
                linear.visibility = View.VISIBLE
                setYesNo(txtYes)
            }

            R.id.txtNo -> if (linear.visibility == View.VISIBLE) {
                haveCertificationsOrLicenses = "2"
                linear.visibility = View.GONE
                setYesNo(txtNo)
            }

            R.id.txtAddMore -> addMore()
        }
    }

    private fun isValid(): Boolean {
        var message: String
        message = ""

        for (i in certificationAdapter.certificationsOrLicensesList.indices) {
            val count = i + 1
            if (certificationAdapter.certificationsOrLicensesList[i].licenceTypeId == "") {
                message = "Please select type $count"
                break
            } else if (certificationAdapter.certificationsOrLicensesList[i].licenceName == "") {
                message = "Please enter license name $count"
                break
            } else if (certificationAdapter.certificationsOrLicensesList[i].licenceNumber == "") {
                message = "Please enter license number $count"
                break
            } else if (certificationAdapter.certificationsOrLicensesList[i].issueDate == "") {
                message = "Please select issue date $count"
                break
            } else if (certificationAdapter.certificationsOrLicensesList[i].expireDate == "") {
                message = "Please select expire date $count"
                break
            } else if (certificationAdapter.certificationsOrLicensesList[i].licenceImage == "") {
                message = "Please upload license image $count"
                break
            } else if (certificationAdapter.certificationsOrLicensesList[i].description == "") {
                message = "Please senter description $count"
                break
            }
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }

    override fun onBackPressed() {
        super.onBackPressed()
        if (!fromEdit) {
            startActivity(
                Intent(
                    activity,
                    PersonalDetailActivity::class.java
                ).putExtra(PersonalDetailActivity.FROMEDIT, fromEdit)
            )
        }
        finish()
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
                                licenceTypeList.clear()
                                licenceTypeList.addAll(commonDataResponse.data.licenceType)
                                getCertificateList()
                            }
                            "6" -> {
                                utils.showCustomToast(commonDataResponse.message)
                                getCertificateList()
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

    private fun saveCertificateApi(fromSave: Boolean) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            var profileStatus = ""
            if (!fromEdit) {
                profileStatus = "3"
            }

            val saveCertificateRequest = SaveCertificateRequest(
                CertificateData(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    haveCertificationsOrLicenses,
                    profileStatus,
                    certificationsOrLicensesList
                )
            )

            val signUp: Call<LoginResponse?> =
                RetrofitClient.getClient.saveCertificationsLicenses(saveCertificateRequest)
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
                                if (fromEdit) {
                                    if (fromSave) {
                                        finish()
                                    } else {
                                        startActivity(
                                            Intent(
                                                activity,
                                                YourAddressActivity::class.java
                                            ).putExtra(YourAddressActivity.FROMEDIT, true)
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

    private fun getCertificateList() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = LangTokenRequest(
                LangToken(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                )
            )

            val signUp: Call<GetCertificationsLicensesResponse?> =
                RetrofitClient.getClient.getCertificationsLicenses(langTokenRequest)
            signUp.enqueue(object : Callback<GetCertificationsLicensesResponse?> {
                override fun onResponse(
                    call: Call<GetCertificationsLicensesResponse?>,
                    response: Response<GetCertificationsLicensesResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val getCertificationsLicensesResponse: GetCertificationsLicensesResponse =
                            response.body()!!
                        when (getCertificationsLicensesResponse.status) {
                            "1" -> {
                                if (getCertificationsLicensesResponse.data.isEmpty()) {
                                    addMore()
                                } else {
                                    haveCertificationsOrLicenses = "1"
                                    linear.visibility = View.VISIBLE
                                    setYesNo(txtYes)
                                    for (i in getCertificationsLicensesResponse.data.indices) {
                                        val data: ArrayList<com.app.xtrahelpcaregiver.Response.CertificationsOrLicenses> =
                                            getCertificationsLicensesResponse.data
                                        val certificationsOrLicenses = CertificationsOrLicenses(
                                            data[i].licenceTypeId,
                                            data[i].licenceName,
                                            data[i].licenceNumber,
                                            data[i].issueDate,
                                            data[i].expireDate,
                                            data[i].licenceImageName,
                                            data[i].description
                                        )
                                        certificationsOrLicensesList.add(certificationsOrLicenses)
                                    }
                                    certificationAdapter.notifyDataSetChanged()
                                }
                            }
                            "6" -> {
//                                utils.showCustomToast(getCertificationsLicensesResponse.message)
                                haveCertificationsOrLicenses = "2"
                                linear.visibility = View.GONE
                                setYesNo(txtNo)
                                addMore()
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    getCertificationsLicensesResponse.status,
                                    getCertificationsLicensesResponse.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<GetCertificationsLicensesResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun setYesNo(txt1: TextView) {
        txtYes.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtYes.background = resources.getDrawable(R.drawable.unselect_bg)
        txtNo.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtNo.background = resources.getDrawable(R.drawable.unselect_bg)

        txt1.setTextColor(resources.getColor(R.color.txtOrange))
        txt1.background = resources.getDrawable(R.drawable.select_bg)
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

                                    certificationsOrLicensesList[pos].licenceImage =
                                        mediaUploadResponse.data[0].mediaName
                                    certificationAdapter.notifyDataSetChanged()

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

    override fun onPermissionGranted(permission: Int) {
        when (permission) {
            PermissionUtils.PERMISSION_CAMERA_PICTURE -> takePhotoFromCamera()
            PermissionUtils.PERMISSION_GALLERY -> choosePhotoFromGallery()
        }
    }

    override fun onPermissionDenied(permission: Int) {
        TODO("Not yet implemented")
    }

    private fun selectIssueDate(position: Int) {
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
                certificationsOrLicensesList[position].issueDate = "$year-$strMonth-$strDay"
                certificationAdapter.notifyDataSetChanged()

            }, year, month, dayOfMonth
        )
        datepicker!!.datePicker.maxDate = calendar.timeInMillis
        datepicker!!.show()
    }

    private fun selectExpireDate(position: Int) {
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
                isDateAfter("$year-$strMonth-$strDay", position)
            }, year, month, dayOfMonth
        )
        datepicker!!.datePicker.minDate = calendar.timeInMillis
        datepicker!!.show()
    }

    private fun isDateAfter(endDate: String?, position: Int): Boolean {
        return try {
            val format = "yyyy-MM-dd" // for example
            val df = SimpleDateFormat(format)
            val date1 = df.parse(endDate)
            val startingDate = df.parse(certificationsOrLicensesList[position].issueDate)

            if (date1.after(startingDate)) {
                if (endDate != null) {
                    certificationsOrLicensesList[position].expireDate = endDate
                }
                certificationAdapter.notifyDataSetChanged()
                true
            } else {
                utils.showCustomToast("Please select Valid Date")
                false
            }
        } catch (e: java.lang.Exception) {
            false
        }
    }

    private fun removePopup(pos: Int) {
        MaterialAlertDialogBuilder(this)
            .setCancelable(false)
            .setMessage("Are you sure want to remove this License/Certificate?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int ->
                certificationsOrLicensesList.removeAt(pos)
                certificationAdapter.notifyDataSetChanged()
            }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
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

        licenseTypeAdapter = LicenseTypeAdapter(activity, licenceTypeList, object :
            LicenseTypeAdapter.CallbackListen {
            override fun clickItem(id: String) {
                for (i in licenceTypeList.indices) {
                    if (licenceTypeList[i].licenceTypeId == id) {
                        certificationsOrLicensesList[position].licenceTypeId =
                            licenceTypeList[i].licenceTypeId
                        certificationAdapter.notifyDataSetChanged()
                        dialog.dismiss()
                    }
                }
            }
        })
        recyclerView.adapter = licenseTypeAdapter
        licenseTypeAdapter.notifyDataSetChanged()

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        dialog.show()
    }

    override fun selectClick(pos: Int, type: String?) {
        this.pos = pos
        when (type) {
            "issueDate" -> {
                selectIssueDate(pos)
            }
            "expireDate" -> {
                selectExpireDate(pos)
            }
            "imageUpload" -> {
                selectImage()
            }
            "remove" -> {
                removePopup(pos)
            }
            "showDialog" -> {
                showTypeDialog(pos)
            }
        }
    }
}