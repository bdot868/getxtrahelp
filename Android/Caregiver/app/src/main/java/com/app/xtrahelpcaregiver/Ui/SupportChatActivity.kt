package com.app.xtrahelpcaregiver.Ui

import android.content.ContentValues.TAG
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Adapter.SupportChattingAdapter
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.ReopenData
import com.app.xtrahelpcaregiver.Request.ReopenRequest
import com.app.xtrahelpcaregiver.Response.MediaUploadResponse
import com.app.xtrahelpcaregiver.Response.TicketChatListResponse
import com.app.xtrahelpcaregiver.Response.TicketDetailResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.FileUtils
import com.app.xtrahelpcaregiver.Utils.JsonUtils
import com.app.xtrahelpcaregiver.Utils.PermissionUtils
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpcaregiver.chatModule.WebSocketManager
import com.bumptech.glide.Glide
import com.google.gson.Gson
import com.theartofdev.edmodo.cropper.CropImage
import kotlinx.android.synthetic.main.activity_support_chat.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import org.apache.commons.lang3.StringEscapeUtils
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File

class SupportChatActivity : BaseActivity(), PermissionUtils.PermissionSettingsListener {
    companion object {
        const val TICKET_ID = "TICKET_ID"
    }

    lateinit var supportChattingAdapter: SupportChattingAdapter
    var ticketId: String = ""
    var chatList: ArrayList<TicketChatListResponse.Data> = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_support_chat)
        utils.statusBarColor(activity, resources.getColor(R.color.txtPurple))
        ticketId = intent.getStringExtra(TICKET_ID).toString()
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        imgSend.setOnClickListener(this)
        addImg.setOnClickListener(this)

        getTicketDetailApi()

        supportChattingAdapter = SupportChattingAdapter(activity, chatList)
        recyclerChat.layoutManager = LinearLayoutManager(activity)
        recyclerChat.isNestedScrollingEnabled = false
        recyclerChat.adapter = supportChattingAdapter
        Log.e(TAG, "init: ${WebSocketManager.isConnect()}")

        connectChat()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.imgSend -> {
                if (etMsg.text.toString() != "") {
                    sendMsg(StringEscapeUtils.escapeJava(etMsg.text.toString().trim()), "1")
                    if (chatList.size > 0) recyclerChat.scrollToPosition(chatList.size - 1)
                }
            }
            R.id.addImg -> selectImage()
        }

    }

    private fun connectChat() {
        val user = JSONObject().apply {
            put(Const.hookMethod, Const.userSupportTicketMessageList)
            put("ticket_id", ticketId)
        }
        Log.e(TAG, "123: $user")
        WebSocketManager.sendMessage(JsonUtils.toJson(user))
    }

    private fun sendMsg(description: String, replyType: String) {
        val user = JSONObject().apply {
            put(Const.hookMethod, Const.userSupportTicketReply)
            put("ticket_id", ticketId)
            put("description", description)
            put("replyType", replyType)
        }
        Log.e(TAG, "123: $user")
        WebSocketManager.sendMessage(JsonUtils.toJson(user))

        etMsg.setText("")
        utils.hideKeyboard(activity)
    }


    override fun onMessage(text: String?) {
        try {
            val jsonObject = JSONObject(text)

            if (jsonObject.getString(Const.hookMethod).equals(Const.userSupportTicketMessageList)) {
                val ticketChatListResponse =
                    Gson().fromJson(text, TicketChatListResponse::class.java)
                Log.e(TAG, "onMessage: $jsonObject")
                chatList.clear()
                chatList.addAll(ticketChatListResponse.data)

                runOnUiThread {
                    supportChattingAdapter.addMessage()
//                    recyclerChat.scrollToPosition(chatList.size - 1);
                    setScrollBottom();
                    txtTitle.text = ticketChatListResponse.adminData.name
                    Glide.with(this)
                        .load(ticketChatListResponse.adminData.profileImageThumbUrl)
                        .centerCrop()
                        .placeholder(R.drawable.placeholder)
                        .into(userImg)
                }

            } else if (jsonObject.getString(Const.hookMethod)
                    .equals(Const.userSupportTicketReply)
            ) {
                val data = jsonObject.getJSONObject("data")

                chatList.add(
                    JsonUtils.fromJson(
                        data.toString(),
                        TicketChatListResponse.Data::class.java
                    )
                )
                runOnUiThread {
                    supportChattingAdapter.addMessage()
                    recyclerChat.scrollToPosition(chatList.size - 1)
                    setScrollBottom()
                }
            }

        } catch (e: Exception) {
            Log.e(TAG, "onMessage: ${e.toString()}")
        }
    }

    fun setScrollBottom() {
        nestedScroll.post(Runnable {
            nestedScroll.fullScroll(View.FOCUS_DOWN)
            etMsg.requestFocus()
        })
    }

//    fun setScrollBottom() {
//        try { recyclerChat.post(Runnable { recyclerChat.scrollTo(0, recyclerChat.bottom) })
//            etMsg.requestFocus()
//        } catch (e: Exception) {
//            e.printStackTrace()
//        }
//    }

    private fun getTicketDetailApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = ReopenRequest(
                ReopenData(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    ticketId.toString()
                )
            )

            val signUp: Call<TicketDetailResponse?> =
                RetrofitClient.getClient.getTicketDetail(langTokenRequest)
            signUp.enqueue(object : Callback<TicketDetailResponse?> {
                override fun onResponse(
                    call: Call<TicketDetailResponse?>,
                    response: Response<TicketDetailResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: TicketDetailResponse =
                            response.body()!!
                        when (response.status) {
                            "1" -> {
                                txtTicketId.text = "#" + response.data.id
                                txtTicketTitle.text = "#" + response.data.title
                                txtDesc.text = response.data.description
//                                txtTitle.text = response.data.name


                                if (response.data.status == "1") {
                                    txtStatus.text = "Open"
                                    txtStatus.setTextColor(resources.getColor(R.color.txtGreen))
                                } else {
                                    txtStatus.text = "Close"
                                    txtStatus.setTextColor(resources.getColor(R.color.darkRed))
                                }
                            }
                            "6" -> {
//                                utils.showCustomToast(getCertificationsLicensesResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    response.status,
                                    response.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<TicketDetailResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
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
                                    Log.e("TAG", "onResponse: $imageName")
                                    sendMsg(imageName, "2")

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

    override fun onPermissionGranted(permission: Int) {
        when (permission) {
            PermissionUtils.PERMISSION_CAMERA_PICTURE -> takePhotoFromCamera()
            PermissionUtils.PERMISSION_GALLERY -> choosePhotoFromGallery()
        }
    }

    override fun onPermissionDenied(permission: Int) {

    }
}