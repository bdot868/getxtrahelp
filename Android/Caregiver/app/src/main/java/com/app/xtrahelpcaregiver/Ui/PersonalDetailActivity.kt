package com.app.xtrahelpcaregiver.Ui

import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.telephony.PhoneNumberFormattingTextWatcher
import android.text.Editable
import android.text.Html
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.HereAboutAdapter
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.*
import com.app.xtrahelpcaregiver.Request.CommonData
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Response.LoginData
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.FileUtils
import com.app.xtrahelpcaregiver.Utils.PermissionUtils
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.bumptech.glide.Glide
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.gson.Gson
import com.theartofdev.edmodo.cropper.CropImage
import kotlinx.android.synthetic.main.activity_personal_detail.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File

class PersonalDetailActivity : BaseActivity(), PermissionUtils.PermissionSettingsListener {

    var phoneNo: String = ""
    var hereId: String = ""
    var gender: String = "1"
    var vaccinated: String = "1"

    lateinit var recyclerView: RecyclerView
    lateinit var txtDataNotFoundPopup: TextView
    lateinit var dialog: BottomSheetDialog

    lateinit var hearAboutUsList: ArrayList<HearAboutUs>

    lateinit var hereAboutAdapter: HereAboutAdapter

    companion object {
        val FROMEDIT = "fromEdit"
    }

    var fromEdit = false

    var covidDesc = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_personal_detail)
        fromEdit = intent.getBooleanExtra(EditProfileActivity.FROMEDIT, false)
        init();
    }

    private fun init() {
//        permissionUtils = PermissionUtils(this)
//        permissionUtils!!.setListener(this)
        if (fromEdit) {
            txtSave.visibility = View.VISIBLE
            txtNext.text = resources.getString(R.string.save_next)
            linearHereAbout.visibility = View.GONE
        } else {
            txtSave.visibility = View.GONE
            linearHereAbout.visibility = View.VISIBLE
            txtNext.text = "Next"
        }

        hearAboutUsList = ArrayList()

        getCommonDataApi()
        getCovidApi()

        txtGuidelines.setOnClickListener(this);
        arrowBack.setOnClickListener(this);
        txtNext.setOnClickListener(this);
        txtMale.setOnClickListener(this);
        txtFemale.setOnClickListener(this);
        txtOther.setOnClickListener(this);
        txtNo.setOnClickListener(this);
        txtYes.setOnClickListener(this);
        addImg.setOnClickListener(this);
        etHearAboutUs.setOnClickListener(this);
        txtSave.setOnClickListener(this);

        etPhone.addTextChangedListener(object : PhoneNumberFormattingTextWatcher() {
            private var backspacingFlag = false
            private var editedFlag = false
            private var cursorComplement = 0

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
                cursorComplement = s.length - etPhone.selectionStart
                backspacingFlag = count > after
            }

            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                // nothing to do here =D
            }

            override fun afterTextChanged(s: Editable) {
                val string = s.toString()
                val phone = string.replace("[^\\d]".toRegex(), "")
                if (!editedFlag) {
                    if (phone.length >= 6 && !backspacingFlag) {
                        editedFlag = true
                        val ans = "(" + phone.substring(0, 3) + ") " + phone.substring(
                            3,
                            6
                        ) + "-" + phone.substring(6)
                        etPhone.setText(ans)
                        etPhone.setSelection(etPhone.text.length - cursorComplement)
                    } else if (phone.length >= 3 && !backspacingFlag) {
                        editedFlag = true
                        val ans = "(" + phone.substring(0, 3) + ") " + phone.substring(3)
                        etPhone.setText(ans)
                        etPhone.setSelection(etPhone.text.length - cursorComplement)
                    }
                } else {
                    editedFlag = false
                }
                phoneNo = etPhone.text.toString().trim { it <= ' ' }
            }
        })
    }


    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtSave -> if (isValid()) {
                savePersonalDetailsApi(true)
            }
            R.id.txtNext -> if (isValid()) {
                savePersonalDetailsApi(false)
            }
            R.id.txtMale -> {
                gender = "1"
                setGender(txtMale)
            }
            R.id.txtFemale -> {
                setGender(txtFemale)
                gender = "2"
            }
            R.id.txtOther -> {
                gender = "3"
                setGender(txtOther)
            }
            R.id.txtYes -> {
                showCovid19Popup()
                setYesNo(txtYes)
                vaccinated = "1"
            }
            R.id.txtNo -> {
                setYesNo(txtNo)
                vaccinated = "2"
            }
            R.id.txtGuidelines -> showCovid19Popup()
            R.id.addImg -> selectImage()
            R.id.etHearAboutUs -> showAddWorkDialog()
        }
    }


    private fun showCovid19Popup() {
        val dialogView = layoutInflater.inflate(R.layout.covid19_popup, null)
        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtDesc = dialog.findViewById<TextView>(R.id.txtDesc)
        val txtAgree = dialog.findViewById<TextView>(R.id.txtAgree)

        txtDesc?.text = Html.fromHtml("<p>$covidDesc</p>", Html.FROM_HTML_MODE_COMPACT)

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        txtAgree!!.setOnClickListener { v: View? -> dialog.dismiss() }
        dialog.show()
    }

    private fun showAddWorkDialog() {
        val dialogView = layoutInflater.inflate(R.layout.common_popup, null)
        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtTitlePopup = dialog.findViewById<TextView>(R.id.txtTitlePopup)

        txtTitlePopup?.text = "How did you hear about us?"

        recyclerView = dialog.findViewById(R.id.recyclerView)!!
        txtDataNotFoundPopup = dialog.findViewById(R.id.txtDataNotFoundPopup)!!
        recyclerView.layoutManager = LinearLayoutManager(activity)

        hereAboutAdapter = HereAboutAdapter(activity, hearAboutUsList, object :
            HereAboutAdapter.CallbackListen {
            override fun clickItem(id: String) {
                for (i in hearAboutUsList.indices) {
                    if (hearAboutUsList[i].hearAboutUsId == id) {
                        etHearAboutUs.setText(hearAboutUsList[i].name)
                        hereId = id
                        dialog.dismiss()
                    }
                }
            }
        })
        recyclerView.adapter = hereAboutAdapter
        hereAboutAdapter.notifyDataSetChanged()

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }

        dialog.show()
    }

    override fun onBackPressed() {
        super.onBackPressed()
//        if (fromEdit) {
//            finish()
//        } else {
//            startActivity(Intent(activity, SubscriptionActivity::class.java))
//            finish()
//        }
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

    private fun setGender(txt1: TextView) {
        txtMale.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtMale.background = resources.getDrawable(R.drawable.unselect_bg)
        txtFemale.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtFemale.background = resources.getDrawable(R.drawable.unselect_bg)
        txtOther.setTextColor(resources.getColor(R.color.txtLightPurple))
        txtOther.background = resources.getDrawable(R.drawable.unselect_bg)
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
                                hearAboutUsList.clear()
                                hearAboutUsList.addAll(commonDataResponse.data.hearAboutUs)
                                getUserDetailsApi()
                            }
                            "6" -> {
                                utils.showCustomToast(commonDataResponse.message)
                                getUserDetailsApi()
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
                                val data: LoginData = loginResponse.data
                                etFirstName.setText(data.firstName)
                                etLastName.setText(data.lastName)
                                etAge.setText(data.age)
                                etPhone.setText(data.phone)
                                hereId = data.hearAboutUsId
                                gender = data.gender
                                vaccinated = data.familyVaccinated
                                imageName = data.image

                                Glide.with(activity)
                                    .load(data.profileImageUrl)
                                    .placeholder(R.drawable.placeholder)
                                    .into(userImg)

                                for (i in hearAboutUsList.indices) {
                                    if (hearAboutUsList[i].hearAboutUsId == hereId) {
                                        etHearAboutUs.setText(hearAboutUsList[i].name)
                                    }
                                }

                                when (gender) {
                                    "1" -> {
                                        setGender(txtMale)
                                    }
                                    "2" -> {
                                        setGender(txtFemale)
                                    }
                                    "3" -> {
                                        setGender(txtOther)
                                    }
                                }

                                when (vaccinated) {
                                    "1" -> {
                                        setYesNo(txtYes)
                                    }
                                    "2" -> {
                                        setYesNo(txtNo)
                                    }
                                }


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

    private fun savePersonalDetailsApi(fromSave: Boolean) {
        var profileStatus = ""
        if (!fromEdit) {
            profileStatus = "2"
        }

        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val savePersonalDetailRequest = SavePersonalDetailRequest(
                SavePersonalDetail(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    etFirstName.text.toString(),
                    etLastName.text.toString(),
                    imageName,
                    phoneNo,
                    etAge.text.toString(),
                    gender,
                    vaccinated,
                    hereId,
                    profileStatus
                )
            )

            val signUp: Call<LoginResponse?> =
                RetrofitClient.getClient.savePersonalDetails(savePersonalDetailRequest)
            signUp.enqueue(object : Callback<LoginResponse?> {
                override fun onResponse(
                    call: Call<LoginResponse?>, response: Response<LoginResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: LoginResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
                                
                                pref.setString(Const.userData, Gson().toJson(response.body()))

                                pref.setString(Const.profileStatus, loginResponse.data.profileStatus)
                                if (fromEdit) {
                                    if (fromSave) {
                                        finish()
                                    } else {
                                        startActivity(
                                            Intent(
                                                activity,
                                                CertificationsLicensesActivity::class.java
                                            ).putExtra(
                                                CertificationsLicensesActivity.FROMEDIT,
                                                true
                                            )
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

    private fun getCovidApi() {
        if (utils.isNetworkAvailable()) {
//            utils.showProgress(activity)
            val commonDataRequest = CMSRequest(
                CMSData(
                    Const.langType,
                    "covid19guideline"
                )
            )

            val signUp: Call<CMSResponse?> =
                RetrofitClient.getClient.getCMS(commonDataRequest)
            signUp.enqueue(object : Callback<CMSResponse?> {
                override fun onResponse(
                    call: Call<CMSResponse?>, response: Response<CMSResponse?>
                ) {
//                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val commonDataResponse: CMSResponse = response.body()!!
                        when (commonDataResponse.status) {
                            "1" -> {
                                covidDesc = commonDataResponse.data.description
                            }
                            "6" -> {

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

                override fun onFailure(call: Call<CMSResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
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
                uploadGalleryMedia(userImg)
            } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
                val error = result.error
                utils.showCustomToast(error.localizedMessage)
            }
        }
        if (requestCode == 123) {
            utils.showCustomToast(getString(R.string.connected))
        }

    }

    private fun isValid(): Boolean {
        phoneNo = etPhone.text.toString().trim { it <= ' ' }
        phoneNo = phoneNo.replace("+", "")
        phoneNo = phoneNo.replace(" ", "")
        phoneNo = phoneNo.replace("_", "")
        phoneNo = phoneNo.replace("(", "")
        phoneNo = phoneNo.replace(")", "")
        phoneNo = phoneNo.replace("-", "")

        var message: String
        message = ""

        when {
            etFirstName.text.toString() == "" -> {
                message = getString(R.string.enterFirstName)
                etFirstName.requestFocus()
            }
            etLastName.text.toString() == "" -> {
                message = getString(R.string.enterLastName)
                etLastName.requestFocus()
            }
            etAge.text.toString() == "" -> {
                message = getString(R.string.enterAge)
                etAge.requestFocus()
            }
            phoneNo.isEmpty() -> {
                message = getString(R.string.enterPhone)
            }
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }

    override fun onPermissionGranted(permission: Int) {
        when (permission) {
            PermissionUtils.PERMISSION_CAMERA_PICTURE -> takePhotoFromCamera()
            PermissionUtils.PERMISSION_GALLERY -> choosePhotoFromGallery()
        }
    }

    override fun onPermissionDenied(permission: Int) {

    }
}