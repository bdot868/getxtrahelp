package com.app.xtrahelpcaregiver.Ui

import android.annotation.SuppressLint
import android.content.ContentValues
import android.content.ContentValues.TAG
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.icu.text.MessagePattern
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.CaregiverAdapter
import com.app.xtrahelpcaregiver.Adapter.ChattingAdapter
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.CaregiverListRequest
import com.app.xtrahelpcaregiver.Response.CaregiverListResponse
import com.app.xtrahelpcaregiver.Response.ChatListResponse
import com.app.xtrahelpcaregiver.Response.MediaUploadResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.FileUtils
import com.app.xtrahelpcaregiver.Utils.JsonUtils
import com.app.xtrahelpcaregiver.Utils.PermissionUtils
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpcaregiver.chatModule.WebSocketManager
import com.bumptech.glide.Glide
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.snackbar.Snackbar
import com.google.gson.Gson
import com.theartofdev.edmodo.cropper.CropImage
import kotlinx.android.synthetic.main.activity_chatting.*
import kotlinx.android.synthetic.main.activity_chatting.arrowBack
import kotlinx.android.synthetic.main.activity_chatting.etMsg
import kotlinx.android.synthetic.main.activity_chatting.imgSend
import kotlinx.android.synthetic.main.activity_chatting.relative
import kotlinx.android.synthetic.main.activity_chatting.txtTitle
import kotlinx.android.synthetic.main.activity_chatting.userImg
import okhttp3.MediaType
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import org.apache.commons.lang3.StringEscapeUtils
import org.json.JSONArray
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File
import java.lang.Exception
import java.util.ArrayList

class ChattingActivity : BaseActivity(), PermissionUtils.PermissionSettingsListener {
    var permissionList =
        arrayOf("android.permission.WRITE_EXTERNAL_STORAGE", "android.permission.CAMERA")

    companion object {
        const val ID = "id"
        const val FROMCHATLIST = "fromChatList"
    }

    var id: String = ""
    var groupId: String = ""
    var fromChatList: Boolean = false

    lateinit var chattingAdapter: ChattingAdapter

    var chatList: ArrayList<ChatListResponse.Data> = ArrayList()
    lateinit var dialog: BottomSheetDialog

    lateinit var txtDataNotFound: TextView
    lateinit var recyclerCaregiver: RecyclerView
    var caregiverAdapter: CaregiverAdapter? = null
    var caregiverList: ArrayList<CaregiverListResponse.Data> = ArrayList()
    var stringArrayList = ArrayList<String>()
    var mCurrentResumePath = ""
    val REQUEST_CODE_WRITE_EXTERNAL_STORAGE = 1
    var PDF_REQ_CODE = 1234
    private val mFile = ArrayList<File>()
    var fileName: File? = null
    var strUploadName: String = ""
    var originalName: String = ""
    private var mDocUri: Uri? = null

    var pageNum = 1
    var totalPage: String? = null
    var isClearList = true
    var itemno = 0
    var bottom = true

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_chatting)
        fromChatList = intent.getBooleanExtra(FROMCHATLIST, false)
        id = intent.getStringExtra(ID).toString()

        init()
    }


    private fun init() {
        arrowBack.setOnClickListener(this)
        imgSend.setOnClickListener(this)
        addImg.setOnClickListener(this)
        closeImg.setOnClickListener(this)
        caregiverIcon.setOnClickListener(this)
        imageIcon.setOnClickListener(this)
        fileIcon.setOnClickListener(this)

        pageNum = 1
        isClearList = true
        getCaregiverApi("")

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

        connectMessageList()
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.imageIcon -> selectImage()
            R.id.addImg -> {
                linearTools.visibility = View.VISIBLE
                imgSend.visibility = View.GONE
                relativeBottom.visibility = View.GONE
            }

            R.id.closeImg -> {
                linearTools.visibility = View.GONE
                imgSend.visibility = View.VISIBLE
                relativeBottom.visibility = View.VISIBLE
            }
            R.id.imgSend -> {
                if (etMsg.text.toString() != "") {
                    sendMsg(StringEscapeUtils.escapeJava(etMsg.text.toString().trim()), "1")
                }
            }
            R.id.caregiverIcon -> {
                caregiverPopup()
            }

            R.id.fileIcon -> {
                selectDocument()
            }
        }
    }

    private fun sendMsg(description: String, replyType: String) {
        val user = JSONObject().apply {
            put(Const.hookMethod, Const.message)
            put("message", description)
            put("type", replyType)
            put("recipient_id", groupId)
            put("attachmentRealName", originalName)
        }
        Log.e(TAG, "123: $user")
        WebSocketManager.sendMessage(JsonUtils.toJson(user))
        originalName = ""
        etMsg.setText("")
//        utils.hideKeyboard(activity)
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
            put("limit", "20")
            put("page", "1")
        }
        Log.e(TAG, "123: $user")
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
            utils.dismissProgress()
            Log.e(TAG, "onMessage: $e")
        }
    }

    private fun setScrollBottom() {
        try {
            recyclerMessage.post(Runnable { recyclerMessage.scrollTo(0, etMsg.getBottom()) })
            etMsg.requestFocus()
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
//        nestedScroll.post {
//            nestedScroll.fullScroll(View.FOCUS_DOWN)
//            recyclerMessage.itemAnimator = null;
//            etMsg.requestFocus()
//        }
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

    override fun onPermissionGranted(permission: Int) {
        when (permission) {
            PermissionUtils.PERMISSION_CAMERA_PICTURE -> takePhotoFromCamera()
            PermissionUtils.PERMISSION_GALLERY -> choosePhotoFromGallery()
        }
    }

    override fun onPermissionDenied(permission: Int) {

    }

    private fun caregiverPopup() {
        val dialogView = layoutInflater.inflate(R.layout.substitute_caregiver_popup, null)
        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)

        recyclerCaregiver = dialog.findViewById(R.id.recyclerCaregiver)!!
        val closeImg: ImageView? = dialog.findViewById(R.id.closeImg)
        val txtSubmit: TextView? = dialog.findViewById(R.id.txtSubmit)
        val title: TextView? = dialog.findViewById(R.id.title)
        val etSearch: EditText? = dialog.findViewById(R.id.etSearch)
        txtDataNotFound = dialog.findViewById(R.id.txtDataNotFound)!!

        title?.text = "Suggest Caregiver"

        caregiverAdapter = CaregiverAdapter(activity, caregiverList)
        recyclerCaregiver.layoutManager = LinearLayoutManager(activity)

        recyclerCaregiver.addOnScrollListener(object : RecyclerView.OnScrollListener() {
            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                super.onScrolled(recyclerView, dx, dy)
                if ((recyclerCaregiver.layoutManager as LinearLayoutManager).findLastVisibleItemPosition() == caregiverList.size - 1 && pageNum != totalPage!!.toInt()
                ) {
                    pageNum++
                    isClearList = false
                    getCaregiverApi(etSearch!!.text.toString())
                }
            }
        })


        recyclerCaregiver.adapter = caregiverAdapter

//        caregiverAdapter.notifyDataSetChanged()

        etSearch?.setOnEditorActionListener(TextView.OnEditorActionListener { v, actionId, event ->
            if (actionId == EditorInfo.IME_ACTION_SEARCH) {
                pageNum = 1
                isClearList = true
                getCaregiverApi(etSearch.text.toString())
                return@OnEditorActionListener true
            }
            false
        })

        etSearch?.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable) {
                if (s.toString().isEmpty()) {
                    pageNum = 1
                    isClearList = true
                    getCaregiverApi(etSearch.text.toString())
                }
            }
        })

        closeImg?.setOnClickListener {
            dialog.dismiss()
        }

        txtSubmit?.setOnClickListener {
            if (caregiverAdapter!!.caregiverId != "") {
                sendMsg(caregiverAdapter!!.caregiverId, "4")
                dialog.dismiss()
            } else {
                utils.showCustomToast("Please select caregiver")
            }
        }
        dialog.show()
    }

    private fun getCaregiverApi(search: String) {
        if (utils.isNetworkAvailable()) {
//            utils.showProgress(activity)
            val langTokenRequest = CaregiverListRequest(
                CaregiverListRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    pageNum,
                    "10",
                    search
                )
            )

            val signUp: Call<CaregiverListResponse?> =
                RetrofitClient.getClient.getCaregiverList(langTokenRequest)
            signUp.enqueue(object : Callback<CaregiverListResponse?> {
                override fun onResponse(
                    call: Call<CaregiverListResponse?>,
                    response: Response<CaregiverListResponse?>
                ) {
//                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: CaregiverListResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                if (isClearList) {
                                    caregiverList.clear()
                                }
                                totalPage = response.totalPages

                                caregiverList.addAll(response.data)
                                caregiverAdapter?.setAdapterList(caregiverList)

                                if (caregiverAdapter != null) {
                                    txtDataNotFound.visibility = View.GONE
                                    recyclerCaregiver.visibility = View.VISIBLE
                                    caregiverAdapter!!.notifyDataSetChanged()
                                }
//                                caregiverAdapter.notifyDataSetChanged()

                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
                                caregiverList.clear()
                                if (caregiverAdapter != null) {
                                    txtDataNotFound.visibility = View.VISIBLE
                                    recyclerCaregiver.visibility = View.GONE
                                    txtDataNotFound.text = response.message
                                    caregiverAdapter!!.notifyDataSetChanged()
                                }
                            }

                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<CaregiverListResponse?>, t: Throwable) {
//                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun selectDocument() {
        if (checkPermission()) {
            val intent = Intent(Intent.ACTION_GET_CONTENT)
            intent.addCategory(Intent.CATEGORY_OPENABLE)
            val mimeTypes = arrayOf(
                "application/pdf",
                "application/msword",
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            )
            intent.type = "*/*"
            intent.putExtra(Intent.EXTRA_MIME_TYPES, mimeTypes)
            startActivityForResult(Intent.createChooser(intent, "Select File"), PDF_REQ_CODE)
        }
    }

    private fun checkPermission(): Boolean {
        var isPermissionGranted = false
        stringArrayList = ArrayList<String>()
        if (Build.VERSION.SDK_INT >= 23) {
            try {
                for (permission in permissionList) {
                    if (activity.checkSelfPermission(permission!!) != PackageManager.PERMISSION_GRANTED) {
                        stringArrayList.add(permission)
                    }
                }
                isPermissionGranted = if (stringArrayList.size <= 0) {
                    true
                } else {
                    val stringArray: Array<String> = stringArrayList.toTypedArray<String>()
                    requestPermissions(stringArray, REQUEST_CODE_WRITE_EXTERNAL_STORAGE)
                    false
                }
            } catch (e: Exception) {
                Log.e("error-->>", e.toString())
            }
        } else {
            isPermissionGranted = true
        }
        return isPermissionGranted
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

        if (requestCode == PDF_REQ_CODE) {
            if (data != null) {
                val contentURI = data.data
                try {
                    mDocUri = data.data
                    mCurrentResumePath =
                        FileUtils.getPath(activity, contentURI)
                    Log.d(
                        "",
                        "Chosen path = " + mCurrentResumePath
                    )
                    mFile.clear()
                    val f: File =
                        File(mCurrentResumePath)
                    fileName = f
                    originalName = f.name
                    if (f.name.contains(".pdf") || f.name.contains(".doc") || f.name.contains(".docx")) {
                        setFile()
                        uploadFile()
                    } else {
                        utils.showCustomToast(resources.getString(R.string.file_Validation))
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                    Log.e("catch", "catch  $e")
                }
            }
        }

        if (requestCode == 123) {
            utils.showCustomToast(getString(R.string.connected))
        }

    }

    private fun setFile() {
        mFile.clear()
        mFile.add(File(mCurrentResumePath))
    }

    private fun uploadFile() {
        if (fileName != null) {
            val requestBody = RequestBody.create("*/*".toMediaTypeOrNull(), fileName!!)
            Log.e("file thumbImage", "uploadMedia: $fileName")
            val body: MultipartBody.Part =
                MultipartBody.Part.createFormData("files", fileName!!.name, requestBody)
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
                                    strUploadName = mediaUploadResponse.data[0].mediaName
                                    sendMsg(strUploadName, "5")
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
}