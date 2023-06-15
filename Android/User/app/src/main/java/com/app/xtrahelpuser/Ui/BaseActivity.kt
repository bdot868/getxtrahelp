package com.app.xtrahelpuser.Ui

import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.content.ContentValues
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.net.ConnectivityManager
import android.net.Uri
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Environment
import android.os.Handler
import android.provider.MediaStore
import android.provider.Settings
import android.util.Log
import android.view.View

import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.FileProvider
import com.app.xtrahelpcaregiver.Response.MediaUploadResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.Pref
import com.app.xtrahelpcaregiver.Utils.Utils
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Interface.SnackRetryInterface
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Utils.CustomDialog
import com.app.xtrahelpuser.Utils.JsonUtils
import com.app.xtrahelpuser.Utils.PermissionUtils
import com.app.xtrahelpuser.chatModule.MessageListener
import com.app.xtrahelpuser.chatModule.WebSocketManager
import com.bumptech.glide.Glide
import com.google.android.material.snackbar.BaseTransientBottomBar
import com.google.android.material.snackbar.Snackbar
import com.theartofdev.edmodo.cropper.CropImage
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File
import java.io.IOException
import java.lang.reflect.InvocationTargetException
import java.lang.reflect.Method
import java.text.SimpleDateFormat
import java.util.*

open class BaseActivity : AppCompatActivity(), View.OnClickListener,
    PermissionUtils.PermissionSettingsListener,
    SnackRetryInterface, MessageListener {
    var snackbar: Snackbar? = null
    var activity: Activity = this
    lateinit var utils: Utils
    lateinit var pref: Pref

    lateinit var customDialog: CustomDialog
    var fileImage: File? = null
    var permissionUtils: PermissionUtils? = null
    val GALLERY = 1
    var CAMERA: Int = 2
    var path = ""
    var imageName: String = ""

    var TAG = "Demo... "

//    init {
//        WebSocketManager.init(RetrofitClient.webSocketUrl, this)
//        if (!WebSocketManager.isConnect()) {
//            WebSocketManager.connect()
//        }
//    }

    override fun onResume() {
        super.onResume()
        WebSocketManager.init(RetrofitClient.webSocketUrl, this)
        if (!WebSocketManager.isConnect()) {
            WebSocketManager.connect()
        }
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_base)
        utils = Utils(activity)
        pref = Pref(activity)

        utils.setRetryClickListener(this)
        customDialog = CustomDialog(this)
        permissionUtils = PermissionUtils(this)
        permissionUtils!!.setListener(this)

        val handler = Handler()
        handler.postDelayed(object : Runnable {
            override fun run() {
                val connectivityManager =
                    getSystemService(CONNECTIVITY_SERVICE) as ConnectivityManager
                val wifi = connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI)
                val mobile = connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE)

                if (wifi != null && wifi.isConnected || mobile != null && mobile.isConnected) {
                    if (snackbar != null && snackbar!!.isShown) {
                        snackbar!!.dismiss()
                        snackbar = null
                    }
                } else {
                    if (snackbar == null) {
                        snackbar = Snackbar.make(
                            findViewById(android.R.id.content),
                            "Internet connection not available",
                            Snackbar.LENGTH_INDEFINITE
                        )
                            .setAnimationMode(BaseTransientBottomBar.ANIMATION_MODE_SLIDE) //                                .setBackgroundTint(Color.parseColor("#EA3E2B"))
                            .setAction(R.string.action) { v ->
                                snackbar = null
                                try {
                                    dropDown()
                                } catch (e: ClassNotFoundException) {
                                    e.printStackTrace()
                                } catch (e: NoSuchMethodException) {
                                    e.printStackTrace()
                                } catch (e: InvocationTargetException) {
                                    startActivity(Intent(Settings.ACTION_SETTINGS))
                                    e.printStackTrace()
                                } catch (e: IllegalAccessException) {
                                    e.printStackTrace()
                                }
                            }
                            .setActionTextColor(Color.parseColor("#FFD400"))
                        snackbar!!.show()
                    }
                }
                handler.postDelayed(this, 2000)
            }
        }, 2000)
    }

    @Throws(
        ClassNotFoundException::class,
        NoSuchMethodException::class,
        InvocationTargetException::class,
        IllegalAccessException::class
    )

    open fun dropDown() {
        @SuppressLint("WrongConstant") val sbservice = getSystemService("statusbar")
        val statusbarManager = Class.forName("android.app.StatusBarManager")
        val showsb: Method
        showsb = if (Build.VERSION.SDK_INT >= 17) {
            statusbarManager.getMethod("expandNotificationsPanel")
        } else {
            statusbarManager.getMethod("expand")
        }
        showsb.invoke(sbservice)
    }

    override fun onClick(v: View?) {

    }


    fun loginActivity() {
        if (pref.getString(Const.token).toString() == "") {
            startActivity(Intent(activity, TutorialActivity::class.java))
            finish()
        } else {
            when {
                pref.getString(Const.profileStatus).toString() == "0" -> {
                    startActivity(
                        Intent(
                            activity,
                            SubscriptionActivity::class.java
                        ).putExtra("fromLogin", true)
                    )
                    finish()
                }
                pref.getString(Const.profileStatus).toString() == "1" -> {
                    startActivity(Intent(activity, PersonalDetailActivity::class.java))
                    finish()
                }
                pref.getString(Const.profileStatus).toString() == "2" -> {
                    startActivity(Intent(activity, AboutLovedOneActivity::class.java))
                    finish()
                }
                pref.getString(Const.profileStatus).toString() == "3" -> {
                    startActivity(Intent(activity, LocationActivity::class.java))
                    finish()
                }
                pref.getString(Const.profileStatus).toString() == "4" -> {
                    startActivity(Intent(activity, DashboardActivity::class.java))
                    finish()
                }
            }
        }
    }

    fun checkStatus(view: View, status: String, message: String) {
        if (status == "0") {
            utils.showSnackBar(view, activity, message, Const.alert, Const.successDuration)
        } else if (status == "2" || status == "5") {
            utils.logOut(activity, message)
        }
    }

    override fun onPermissionGranted(permission: Int) {
        TODO("Not yet implemented")
    }

    override fun onPermissionDenied(permission: Int) {
        TODO("Not yet implemented")
    }

    open fun selectImage() {
        val options = arrayOf<CharSequence>("Take Photo", "Choose from Gallery", "Cancel")
        val builder = AlertDialog.Builder(this, R.style.MyAlertDialogTheme)
        builder.setTitle("Add Photo!")
        builder.setItems(options) { dialog: DialogInterface, item: Int ->
            if (options[item] == "Take Photo") {
                dialog.dismiss()
                permissionUtils!!.requestPermission(PermissionUtils.PERMISSION_CAMERA_PICTURE)
            } else if (options[item] == "Choose from Gallery") {
                permissionUtils?.requestPermission(PermissionUtils.PERMISSION_GALLERY)
            } else if (options[item] == "Cancel") {
                dialog.dismiss()
            }
        }
        builder.show()
    }

    fun takePhotoFromCamera() {
        try {
            checkCameraHardware(this)
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
    }

    @Throws(IOException::class)
    fun checkCameraHardware(context: Context) {
        if (context.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY)) {
            if (Build.VERSION.SDK_INT < 23) {
                dispatchTakePictureIntent()
            } else {
                dispatchTakePictureNIntent()
            }
        }
    }

    @Throws(IOException::class)
    fun dispatchTakePictureIntent() {
        val takePictureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        if (takePictureIntent.resolveActivity(this.packageManager) != null) {
            val photoFile = createImageFile()
            if (photoFile != null) {
                takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(photoFile))
            }
            startActivityForResult(takePictureIntent, CAMERA)
        }
    }

    fun dispatchTakePictureNIntent() {
        val takePictureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        if (takePictureIntent.resolveActivity(this.packageManager) != null) {
            var photoFile: File? = null
            try {
                photoFile = createImageFile()
            } catch (ex: IOException) {
            }
            if (photoFile != null) {
                if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M) {
                    takePictureIntent.putExtra(
                        MediaStore.EXTRA_OUTPUT,
                        FileProvider.getUriForFile(
                            this, this.packageName
                                .toString() + ".provider", photoFile
                        )
                    )
                } else {
                    takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(photoFile))
                }
                startActivityForResult(takePictureIntent, CAMERA)
            }
        }
    }

    fun createImageFile(): File? {
        val timeStamp = SimpleDateFormat("yyyyMMdd_HHmmss").format(Date())
        val imageFileName = "PhotoEditor" + "_"
        val storageDir = getExternalFilesDir(Environment.DIRECTORY_PICTURES)
        val image = File.createTempFile(
            imageFileName,
            ".jpg",
            storageDir
        )
        path = image.absolutePath
        return image
    }

    fun choosePhotoFromGallery() {
        val galleryIntent = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
        startActivityForResult(galleryIntent, GALLERY)
    }

    fun beginCrop(source: Uri?) {
        CropImage.activity(source).start(this)
    }

    fun uploadGalleryMedia(imageView: ImageView) {
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
                                "0" -> {
                                    utils.showCustomToast(mediaUploadResponse.message)
                                }
                                "1" -> {
                                    imageName = mediaUploadResponse.data.get(0).mediaName
                                    Log.e("TAG", "onResponse: $imageName")
                                    Glide.with(activity)
                                        .load(mediaUploadResponse.data.get(0).mediaBaseUrl)
                                        .placeholder(R.drawable.placeholder)
                                        .centerCrop()
                                        .into(imageView)
                                }
                                "2" -> {
                                    utils.logOut(activity, mediaUploadResponse.message)
                                }
                                "6" -> {
                                    utils.showCustomToast(mediaUploadResponse.message)
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

    override fun onReTryClick(view: View?, textView: TextView?) {
        if (textView!!.text.toString().trim { it <= ' ' }
                .equals(resources.getString(R.string.setting), ignoreCase = true)) {
            startActivityForResult(Intent(Settings.ACTION_SETTINGS), 123)
        } else {
        }
    }

    override fun onConnectSuccess() {
        val user = JSONObject().apply {
            put(Const.token_pass, Const.getToken(this@BaseActivity))
            put(Const.hookMethod, Const.registration)
        }
        Log.e(TAG, "onConnectSuccess: $user")
        WebSocketManager.sendMessage(JsonUtils.toJson(user))
    }

    override fun onConnectFailed() {
        Log.e(TAG, "onConnectFailed: ")
    }

    override fun onClose() {
    }

    override fun onMessage(text: String?) {
    }


}