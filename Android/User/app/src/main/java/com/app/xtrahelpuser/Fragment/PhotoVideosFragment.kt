package com.app.xtrahelpuser.Fragment

import android.app.Activity.RESULT_CANCELED
import android.app.Activity.RESULT_OK
import android.app.AlertDialog
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.GridLayoutManager
import com.app.xtrahelpcaregiver.Response.MediaUploadResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.PhotoVideoAdapter
import com.app.xtrahelpuser.Interface.SelectImageVideoClick
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.SaveUserJobRequest
import com.app.xtrahelpuser.Ui.AddJobActivity
import com.app.xtrahelpuser.Ui.AddJobActivity.Companion.media
import com.app.xtrahelpuser.Utils.FileUtils
import com.app.xtrahelpuser.Utils.PermissionUtils
import com.theartofdev.edmodo.cropper.CropImage
import kotlinx.android.synthetic.main.fragment_photo_videos.*
import kotlinx.android.synthetic.main.fragment_photo_videos.relative
import kotlinx.android.synthetic.main.fragment_photo_videos.relativeBack
import kotlinx.android.synthetic.main.fragment_photo_videos.relativeNext
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.Console
import java.io.File
import java.lang.Exception
import java.util.ArrayList


class PhotoVideosFragment : BaseFragment(), SelectImageVideoClick,
    PermissionUtils.PermissionSettingsListener {
    val list = ArrayList<String>()

    lateinit var photoVideoAdapter: PhotoVideoAdapter

    val GALLERY_VIDEO: Int = 3
    val CAMERA_VIDEO: Int = 3

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_photo_videos, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        init()

    }

    private fun init() {
        relativeBack.setOnClickListener(this)
        relativeNext.setOnClickListener(this)

        photoVideoAdapter = PhotoVideoAdapter(activity)
        recyclerPhotoVideo.layoutManager = GridLayoutManager(activity, 3)
        recyclerPhotoVideo.isNestedScrollingEnabled = false
        recyclerPhotoVideo.adapter = photoVideoAdapter
        photoVideoAdapter.selectImageVideoClick(this)

        if (media.isEmpty()) {
            val mediaRequest = SaveUserJobRequest.Media("123", "")
            media.add(mediaRequest)
        }
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.relativeNext -> {
                if (media.isEmpty()) {
                    utils.showSnackBar(relative, activity, "Please add image/video", Const.alert, Const.successDuration)
                } else {
                    (getActivity() as AddJobActivity?)?.nextFragment()
                }
            }
            R.id.relativeBack -> {
                (getActivity() as AddJobActivity?)?.backFragment()
            }
        }
    }

    private fun selectImageVideo() {
        val options = arrayOf<CharSequence>(
            "Take Photo",
            "Choose Photo from Gallery",
            "Take Video",
            "Choose Video from Gallery",
            "Cancel")
        val builder = AlertDialog.Builder(getActivity())
        builder.setTitle("Add Photo & Video!")
        builder.setItems(options) { dialog, item ->
            if (options[item] == "Take Photo") {
                dialog.dismiss()
                permissionUtils?.requestPermission(PermissionUtils.PERMISSION_CAMERA_PICTURE)
            } else if (options[item] == "Choose Photo from Gallery") {
                permissionUtils!!.requestPermission(PermissionUtils.PERMISSION_GALLERY)
            } else if (options[item] == "Take Video") {
                permissionUtils!!.requestPermission(PermissionUtils.PERMISSION_CAMERA_VIDEO)
            } else if (options[item] == "Choose Video from Gallery") {
                permissionUtils!!.requestPermission(PermissionUtils.PERMISSION_GALLERY_VIDEO)
            } else if (options[item] == "Cancel") {
                dialog.dismiss()
            }
        }
        builder.show()
    }

    override fun onSelectImageClick(pos: Int) {
        selectImageVideo()
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == RESULT_CANCELED) {
            return
        }
        if (requestCode == GALLERY) {
            if (data != null) {
                val contentURI = data.data
                fileImage = File(FileUtils.getPath(activity, contentURI))
                beginCrop(contentURI)
            }
        } else if (requestCode == CAMERA) {
            val image: File = File(path)
            val bmOptions = BitmapFactory.Options()
            val photo = BitmapFactory.decodeFile(image.absolutePath, bmOptions)
            val tempUri = Uri.fromFile(File(path))
            fileImage = File(FileUtils.getPath(activity, tempUri))
            beginCrop(tempUri)
        } else if (requestCode == GALLERY_VIDEO && resultCode == RESULT_OK) {
            if (data != null) {
                val contentURI = data.data
                val path = FileUtils.getPath(activity, contentURI)
                val duration = FileUtils.getMediaDuration(path)
                val hours = duration / 3600
                val minutes = (duration - hours * 3600) / 60
                Log.e("minutes", "onActivityResult: $minutes")
                Log.e("duration", "onActivityResult: $duration")
                if (duration > 60) {
                    utils.showSnackBar(
                        relative,
                        activity,
                        getString(R.string.video_MaxLimit),
                        Const.alert,
                        Const.successDuration
                    )
                } else {
                    try {
                        fileImage = File(FileUtils.getPath(activity, contentURI))
                        Log.e("mCurrentPhotoPath", "catch  $fileImage")
                        uploadGalleryMedia()
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
            }
        } else if (requestCode == CAMERA_VIDEO) {
            try {
                fileImage = File(FileUtils.getPath(activity, data!!.data))
                uploadGalleryMedia()
            } catch (e: Exception) {
            }
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

    fun beginCrop(source: Uri?) {
        CropImage.activity(source)
            .start(activity, this@PhotoVideosFragment)
    }

    fun uploadGalleryMedia() {
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
                                    val mediaRequest = SaveUserJobRequest.Media(
                                        mediaUploadResponse.data.get(0).mediaName,
                                        mediaUploadResponse.data.get(0).videoThumbImgName
                                    )

                                    media.add(mediaRequest)

                                    val mediaRequest1 = SaveUserJobRequest.Media("123", "")
                                    media.remove(mediaRequest1)
                                    media.add(mediaRequest1)

                                    photoVideoAdapter.notifyDataSetChanged()
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

    private fun takeVideoFromCamera() {
        val intent = Intent(MediaStore.ACTION_VIDEO_CAPTURE)
        intent.putExtra("android.intent.extra.durationLimit", 60)
        intent.putExtra("EXTRA_VIDEO_QUALITY", 0)
        startActivityForResult(intent, CAMERA_VIDEO)
    }

    private fun chooseVideoFromGallery() {
        val intent = Intent()
        intent.type = "video/*"
        intent.action = Intent.ACTION_GET_CONTENT
        startActivityForResult(intent, GALLERY_VIDEO)
    }

    override fun onPermissionGranted(permission: Int) {
        when (permission) {
            PermissionUtils.PERMISSION_CAMERA_PICTURE -> takePhotoFromCamera()
            PermissionUtils.PERMISSION_GALLERY -> choosePhotoFromGallery()
            PermissionUtils.PERMISSION_CAMERA_VIDEO -> takeVideoFromCamera()
            PermissionUtils.PERMISSION_GALLERY_VIDEO -> chooseVideoFromGallery()
        }
    }

    override fun onPermissionDenied(permission: Int) {

    }

}