package com.app.xtrahelpcaregiver.Ui

import android.app.AlertDialog
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import android.text.TextUtils
import android.util.Log
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.FeedPhotoVideoListAdapter
import com.app.xtrahelpcaregiver.Adapter.PhotoVideoAdapter
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.Media
import com.app.xtrahelpcaregiver.Request.SaveFeedRequest
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.FileUtils
import com.app.xtrahelpcaregiver.Utils.PermissionUtils
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Interface.RemovePhotoVideo
import com.bumptech.glide.Glide
import com.google.gson.Gson
import com.theartofdev.edmodo.cropper.CropImage
import kotlinx.android.synthetic.main.activity_create_feed.*
import kotlinx.android.synthetic.main.header.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import org.apache.commons.lang3.StringEscapeUtils
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File

class CreateFeedActivity : BaseActivity() , PermissionUtils.PermissionSettingsListener,
    RemovePhotoVideo {

    lateinit var photoVideoAdapter: FeedPhotoVideoListAdapter
    var photoVideoList: ArrayList<Media> = ArrayList()
    val GALLERY_VIDEO: Int = 3
    val CAMERA_VIDEO: Int = 3

    companion object {
        val FEEDID = "feedId"
        val IS_EDIT = "isEdit"
        val DESCRIPTION = "description"
    }

    var isEdit = false
    var description = ""
    var feedId = ""

    var mediaArrayList: ArrayList<FeedListResponse.Data.Media> = ArrayList()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_create_feed)
        txtTitle.text = "Create Feed"
        isEdit = intent.getBooleanExtra(IS_EDIT, false)
        init();
    }

    override fun onResume() {
        super.onResume()
        var loginResponse: LoginResponse? = null
        val userData: String = pref.getString(Const.userData).toString()
        if (!TextUtils.isEmpty(userData)) {
            loginResponse = Gson().fromJson(userData, LoginResponse::class.java)
            if (loginResponse != null) {
                val data: LoginData = loginResponse.data
                pref.setString(Const.id, data.id)

                Glide.with(this)
                    .load(data.profileImageUrl)
                    .placeholder(R.drawable.placeholder)
                    .centerCrop()
                    .into(userImg)
            }
        }
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        image.setOnClickListener(this)
        videoImg.setOnClickListener(this)
        txtPost.setOnClickListener(this)

        photoVideoAdapter = FeedPhotoVideoListAdapter(activity, photoVideoList)
        recyclerImageVideo.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerImageVideo.isNestedScrollingEnabled = false
        recyclerImageVideo.adapter = photoVideoAdapter
        photoVideoAdapter.removePhoVideoClick(this)

        if (isEdit) {
            feedId = intent.getStringExtra(FEEDID).toString()
            description = intent.getStringExtra(DESCRIPTION).toString()
            etDesc.setText(StringEscapeUtils.unescapeJava(description))
            mediaArrayList = intent.getParcelableArrayListExtra("mediaList")!!
            photoVideoList.clear()
            for (i in mediaArrayList.indices) {
                val isVideo: String = if (mediaArrayList[i].isVideo == "1") {
                    "1"
                } else {
                    "0"
                }
                val mediaRequest = Media(
                    mediaArrayList[i].mediaName,
                    mediaArrayList[i].videoImage,
                )
                photoVideoList.add(mediaRequest)
                photoVideoAdapter.notifyDataSetChanged()
            }
        }

    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed();
            R.id.image -> {
                selectImage()
            }
            R.id.videoImg -> {
                selectVideo()
            }

            R.id.txtPost -> {
                if (isValid()) {
                    saveUserFeedApi()
                }
            }
        }
    }

    private fun saveUserFeedApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val desc = StringEscapeUtils.escapeJava(etDesc.text.toString())
            val langTokenRequest = SaveFeedRequest(
                SaveFeedRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    desc,
                    photoVideoList,
                    feedId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.saveUserFeed(langTokenRequest)
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
                                finish()
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

    private fun selectVideo() {
        val options = arrayOf<CharSequence>(
            "Take Video",
            "Choose Video from Gallery",
            "Cancel"
        )
        val builder = AlertDialog.Builder(activity)
        builder.setTitle("Add Photo & Video!")
        builder.setItems(options) { dialog, item ->
            if (options[item] == "Take Video") {
                permissionUtils!!.requestPermission(PermissionUtils.PERMISSION_CAMERA_VIDEO)
            } else if (options[item] == "Choose Video from Gallery") {
                permissionUtils!!.requestPermission(PermissionUtils.PERMISSION_GALLERY_VIDEO)
            } else if (options[item] == "Cancel") {
                dialog.dismiss()
            }
        }
        builder.show()
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
        } else if (requestCode == CAMERA && resultCode == RESULT_OK) {
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
                                    var isVideo = "0"
                                    isVideo =
                                        if (mediaUploadResponse.data.get(0).mediaName.contains(".mp4") || mediaUploadResponse.data.get(
                                                0
                                            ).mediaName.contains(".avi") || mediaUploadResponse.data.get(
                                                0
                                            ).mediaName.contains(".mkv")
                                        ) {
                                            "1"
                                        } else {
                                            "0"
                                        }

                                    val mediaRequest = Media(
                                        mediaUploadResponse.data[0].mediaName,
                                        mediaUploadResponse.data[0].videoThumbImgName
                                    )
                                    photoVideoList.add(mediaRequest)

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

    private fun isValid(): Boolean {
        var message = ""

        if (etDesc.text.toString() == "") {
            message = resources.getString(R.string.enterDesc)
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }

    override fun removePhotoVideo(media: Media) {
        photoVideoList.remove(media)
        photoVideoAdapter.notifyDataSetChanged()
    }
}