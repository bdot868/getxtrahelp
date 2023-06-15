package com.app.xtrahelpcaregiver.Ui

import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.telephony.PhoneNumberFormattingTextWatcher
import android.text.Editable
import android.text.TextUtils
import android.view.View
import android.widget.TextView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.SavePersonalDetail
import com.app.xtrahelpcaregiver.Request.SavePersonalDetailRequest
import com.app.xtrahelpcaregiver.Response.LoginData
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.FileUtils
import com.app.xtrahelpcaregiver.Utils.PermissionUtils
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.bumptech.glide.Glide
import com.google.gson.Gson
import com.theartofdev.edmodo.cropper.CropImage
import kotlinx.android.synthetic.main.activity_edit_profile.*
import kotlinx.android.synthetic.main.activity_edit_profile.addImg
import kotlinx.android.synthetic.main.activity_edit_profile.etAge
import kotlinx.android.synthetic.main.activity_edit_profile.etFirstName
import kotlinx.android.synthetic.main.activity_edit_profile.etLastName
import kotlinx.android.synthetic.main.activity_edit_profile.etPhone
import kotlinx.android.synthetic.main.activity_edit_profile.relative
import kotlinx.android.synthetic.main.activity_edit_profile.txtFemale
import kotlinx.android.synthetic.main.activity_edit_profile.txtMale
import kotlinx.android.synthetic.main.activity_edit_profile.txtOther
import kotlinx.android.synthetic.main.activity_edit_profile.userImg
import kotlinx.android.synthetic.main.activity_personal_detail.*
import kotlinx.android.synthetic.main.header.arrowBack
import kotlinx.android.synthetic.main.header.txtTitle
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File

class EditProfileActivity : BaseActivity(), PermissionUtils.PermissionSettingsListener {
    var phoneNo: String = ""
    var gender: String = "1"

    lateinit var loginResponse: LoginResponse

    companion object {
        val FROMEDIT = "fromEdit"
    }
    var fromEdit = false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_edit_profile)
        txtTitle.text = "My Profile"
        fromEdit = intent.getBooleanExtra(FROMEDIT, false)
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtChangePassword.setOnClickListener(this)
        txtMale.setOnClickListener(this)
        txtFemale.setOnClickListener(this)
        txtOther.setOnClickListener(this)
        txtUpdate.setOnClickListener(this)
        addImg.setOnClickListener(this)

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

        val userData: String = pref.getString(Const.userData).toString()
        if (!TextUtils.isEmpty(userData)) {
            loginResponse = Gson().fromJson(userData, LoginResponse::class.java)
            if (loginResponse != null) {
                val data: LoginData = loginResponse.data
                pref.setString(Const.id, data.id)

                imageName = data.profileImageName
                Glide.with(this)
                    .load(data.profileImageUrl)
                    .placeholder(R.drawable.placeholder)
                    .centerCrop()
                    .into(userImg)

                etFirstName.setText(data.firstName)
                etLastName.setText(data.lastName)
                etAge.setText(data.age)
                phoneNo = data.phone

                etPhone.setText(data.phone)
                when (data.gender) {
                    "1" -> {
                        gender = "1"
                        setGender(txtMale)
                    }
                    "2" -> {
                        setGender(txtFemale)
                        gender = "2"
                    }
                    "3" -> {
                        gender = "3"
                        setGender(txtOther)
                    }
                }
            }
        }
    }


    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtChangePassword -> startActivity(
                Intent(
                    activity,
                    ChangePasswordActivity::class.java
                )
            )
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
            R.id.txtUpdate -> if (isValid()) {
                savePersonalDetailsApi()
            }

            R.id.addImg -> selectImage()
        }
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

    private fun savePersonalDetailsApi() {
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
                    "",
                    "",
                    ""
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
                                utils.customToast(activity, loginResponse.message)
                                finish()
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
                etAge.requestFocus()
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
}