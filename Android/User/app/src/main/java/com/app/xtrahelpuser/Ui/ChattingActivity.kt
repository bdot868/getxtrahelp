package com.app.xtrahelpuser.Ui

import android.content.ContentValues
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.MediaUploadResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.ChattingAdapter
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.ChatListResponse
import com.app.xtrahelpuser.Utils.FileUtils
import com.app.xtrahelpuser.Utils.JsonUtils
import com.app.xtrahelpuser.Utils.PermissionUtils
import com.app.xtrahelpuser.chatModule.WebSocketManager
import com.bumptech.glide.Glide
import com.google.gson.Gson
import com.theartofdev.edmodo.cropper.CropImage
import kotlinx.android.synthetic.main.activity_chatting.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import org.apache.commons.lang3.StringEscapeUtils
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File

class ChattingActivity : BaseActivity(), PermissionUtils.PermissionSettingsListener {
    companion object {
        const val ID = "id"
        const val FROMCHATLIST = "fromChatList"
    }

    var id: String = ""
    var groupId: String = ""
    var fromChatList: Boolean = false

    lateinit var chattingAdapter: ChattingAdapter

    var chatList: ArrayList<ChatListResponse.Data> = ArrayList()

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true
    var itemno = 0
    var bottom = true

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_chatting)
        id = intent.getStringExtra(ID).toString()
        fromChatList = intent.getBooleanExtra(FROMCHATLIST, false)
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        imgSend.setOnClickListener(this)
        addImg.setOnClickListener(this)
        pageNum = 1
        isClearList = true

        chattingAdapter = ChattingAdapter(activity, chatList)
        recyclerMessage.layoutManager = LinearLayoutManager(activity)
        recyclerMessage.isNestedScrollingEnabled = false
        recyclerMessage.adapter = chattingAdapter

        swipeRefreshLayout.setOnRefreshListener {
            swipeRefreshLayout.isRefreshing = false
            if (itemno == 0 && pageNum != totalPage!!.toInt()) {
                isClearList = false
                itemno = 1
                pageNum++
                connectMessageList()
            } else {
                swipeRefreshLayout.isRefreshing = false
            }
        }

        recyclerMessage.addOnScrollListener(object : RecyclerView.OnScrollListener() {
            override fun onScrollStateChanged(recyclerView: RecyclerView, newState: Int) {
                super.onScrollStateChanged(recyclerView, newState)
            }

            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                val layoutManager = LinearLayoutManager::class.java.cast(recyclerView.layoutManager)
                itemno = layoutManager.findFirstVisibleItemPosition()
                if (dy < 0) {
                    bottom = false
                    Log.e("recyclerMessages", "onScrolled: " + "truee")
                    // Recycle view scrolling up...
                } else if (dy > 0) {
                    bottom = true
                    Log.e("recyclerMessages", "onScrolled: " + "falsseee")
                    // Recycle view scrolling down...
                }
            }
        })



//        try {
//            nestedScroll.viewTreeObserver
//                .addOnScrollChangedListener(ViewTreeObserver.OnScrollChangedListener {
//                    val view = nestedScroll.getChildAt(nestedScroll.childCount - 1) as View
//                    val diff: Int = view.bottom - (nestedScroll.height + nestedScroll.scrollY)
//                    if (diff == 0 && pageNum != totalPage!!.toInt()) {
//                        pageNum++
//                        isClearList = false
//                        connectMessageList()
//                    }
//                })
//        } catch (e: Exception) {
//        }

        connectMessageList()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.addImg -> selectImage()
            R.id.imgSend -> {
                if (etMsg.text.toString() != "") {
                    sendMsg(StringEscapeUtils.escapeJava(etMsg.text.toString().trim()), "1")
                }
            }
        }
    }

    private fun sendMsg(description: String, replyType: String) {
        val user = JSONObject().apply {
            put(Const.hookMethod, Const.message)
            put("message", description)
            put("type", replyType)
            put("recipient_id", groupId)
        }
        Log.e(ContentValues.TAG, "123: $user")
        WebSocketManager.sendMessage(JsonUtils.toJson(user))

        etMsg.setText("")
    }

    private fun connectMessageList() {
        utils.showProgress(activity)
        val user = JSONObject().apply {
            if (fromChatList) {
                put(Const.hookMethod, Const.chatmessagelist)
            } else {
                put(Const.hookMethod, Const.usermessagelist)
            }
            put("id", id)
            put("limit", "")
            put("page", pageNum)
        }
        Log.e(ContentValues.TAG, "123: $user")
        WebSocketManager.sendMessage(JsonUtils.toJson(user))
    }

    override fun onMessage(text: String?) {
        try {
            val jsonObject = JSONObject(text)
            Log.e(ContentValues.TAG, "onMessage: $jsonObject")
            swipeRefreshLayout.isRefreshing = false
            if (jsonObject.getString(Const.hookMethod)
                    .equals(Const.chatmessagelist) || jsonObject.getString(Const.hookMethod)
                    .equals(Const.usermessagelist)
            ) {
                val chatResponse = Gson().fromJson(text, ChatListResponse::class.java)
                Log.e(ContentValues.TAG, "onMessage: $jsonObject")
                groupId = chatResponse.group.id
                itemno = 0
//                chatList.addAll(chatResponse.data)

                runOnUiThread {
                    totalPage = chatResponse.total_page
                    if (isClearList){
                        chatList.clear()
                    }
                    var chatListTemp: ArrayList<ChatListResponse.Data> = ArrayList()

                    chatListTemp.addAll(chatResponse.data)
                    chatListTemp.reverse()

                    for (k in chatListTemp.indices) {
                        chatList.add(k, chatListTemp.get(k))
                    }
                    chattingAdapter.addMessage()

//                    chattingAdapter.setAdapterList(chatList)
                    if (pageNum == 1) {
                        recyclerMessage.scrollToPosition(chatList.size - 1);
                        setScrollBottom();
                    } else {
                        recyclerMessage.scrollToPosition(chatList.size + 3)
                    }

                    txtTitle.text = chatResponse.group.name

                    Glide.with(this)
                        .load(chatResponse.group.thumbImage)
                        .centerCrop()
                        .placeholder(R.drawable.placeholder)
                        .into(userImg)

                    if (chatResponse.group.isOnline == "1") {
                        txtOnline.visibility = View.VISIBLE
                    } else {
                        txtOnline.visibility = View.GONE
                    }
                }
                utils.dismissProgress()
            } else if (jsonObject.getString(Const.hookMethod).equals(Const.message)) {
                val data = jsonObject.getJSONObject("data")

                chatList.add(JsonUtils.fromJson(data.toString(), ChatListResponse.Data::class.java))

                runOnUiThread {
                    chattingAdapter.addMessage()
                    if (bottom) {
                        recyclerMessage.scrollToPosition(chatList.size - 1)
                        setScrollBottom()
                    }
                    etMsg.requestFocus()
//                    recyclerMessage.scrollToPosition(chatList.size - 1)

                }
            }

        } catch (e: Exception) {
            Log.e(ContentValues.TAG, "onMessage: $e")
        }
    }

//    private fun setScrollBottom() {
//        try {
//            recyclerMessage.post(Runnable {
//                recyclerMessage.scrollTo(0, recyclerMessage.getBottom())
//            })
//        } catch (e: java.lang.Exception) {
//            e.printStackTrace()
//        }
//    }

    fun setScrollBottom() {
//        nestedScroll.post {
//            nestedScroll.fullScroll(View.FOCUS_DOWN)
//            etMsg.requestFocus()
//        }

        try {
            recyclerMessage.post(Runnable { recyclerMessage.scrollTo(0, etMsg.getBottom()) })
            etMsg.requestFocus()
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
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
                                    imageName = mediaUploadResponse.data[0].mediaName
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
        } else if (requestCode == CAMERA) {
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