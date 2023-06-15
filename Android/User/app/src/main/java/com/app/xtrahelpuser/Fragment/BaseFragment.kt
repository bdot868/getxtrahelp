package com.app.xtrahelpuser.Fragment

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.FileProvider
import androidx.fragment.app.Fragment
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.Pref
import com.app.xtrahelpcaregiver.Utils.Utils
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Utils.CustomDialog
import com.app.xtrahelpuser.Utils.PermissionUtils
import com.google.android.material.snackbar.Snackbar
import com.theartofdev.edmodo.cropper.CropImage
import java.io.File
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.*

open class BaseFragment : Fragment(), View.OnClickListener,
    PermissionUtils.PermissionSettingsListener {
    lateinit var activity: Activity
    lateinit var utils: Utils
    lateinit var pref: Pref
    lateinit var customDialog: CustomDialog

    var snackbar: Snackbar? = null
    var fileImage: File? = null
    var permissionUtils: PermissionUtils? = null
    open val GALLERY = 1
    open var CAMERA: Int = 2
    var path = ""
    var imageName: String = ""

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_base, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        activity = requireActivity()
        utils = Utils(activity)
        pref = Pref(activity)
        customDialog = CustomDialog(activity)

        permissionUtils = PermissionUtils(this)
        permissionUtils!!.setListener(this)
    }

    override fun onClick(v: View?) {

    }


    fun checkStatus(view: View, status: String, message: String) {
        if (status == "0") {
            utils.showSnackBar(view, activity, message, Const.alert, Const.successDuration)
        } else if (status == "2" || status == "5") {
            utils.logOut(activity, message)
        }
    }

    fun takePhotoFromCamera() {
        try {
            checkCameraHardware(activity)
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
        if (takePictureIntent.resolveActivity(activity.packageManager) != null) {
            val photoFile = createImageFile()
            if (photoFile != null) {
                takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(photoFile))
            }
            startActivityForResult(takePictureIntent, CAMERA)
        }
    }

    fun dispatchTakePictureNIntent() {
        val takePictureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        if (takePictureIntent.resolveActivity(activity.packageManager) != null) {
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
                            activity, activity.packageName
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
        val storageDir = activity.getExternalFilesDir(Environment.DIRECTORY_PICTURES)
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


    override fun onPermissionGranted(permission: Int) {
        TODO("Not yet implemented")
    }

    override fun onPermissionDenied(permission: Int) {
        TODO("Not yet implemented")
    }
}