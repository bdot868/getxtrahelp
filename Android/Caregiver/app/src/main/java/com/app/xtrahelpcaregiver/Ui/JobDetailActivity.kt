package com.app.xtrahelpcaregiver.Ui

import android.app.AlertDialog
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.*
import android.widget.TextView.OnEditorActionListener
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Adapter.*
import com.app.xtrahelpcaregiver.CustomView.VerificationCodeView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.*
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Response.Media
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.FileUtils
import com.app.xtrahelpcaregiver.Utils.PermissionUtils
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.bumptech.glide.Glide
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.BitmapDescriptor
import com.google.android.gms.maps.model.BitmapDescriptorFactory
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.theartofdev.edmodo.cropper.CropImage
import kotlinx.android.synthetic.main.activity_job_detail.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File

class JobDetailActivity : BaseActivity(), OnMapReadyCallback {
    companion object {
        val JOBID = "jobId"
        val JOBDETAILTYPE = "jobDetailType"
        val ISMEDIAREQUEST = "isMediaRequest"
        val MEDIAREQUESTTYPE = "mediRequestType"
    }

    val GALLERY_VIDEO: Int = 3
    val CAMERA_VIDEO: Int = 3

    var photoVideoList: ArrayList<Media> = ArrayList()
    var uploadedMediaList: ArrayList<Media> = ArrayList()
    var questionList: ArrayList<Question> = ArrayList()

    var questionAnswerList: ArrayList<QuestionAnswer> = ArrayList()

    lateinit var photoVideoAdapter: PhotoVideoAdapter
    lateinit var uploadedMediaAdapter: PhotoVideoAdapter
    lateinit var preferencesAdapter: PreferencesAdapter
    lateinit var questionAdapter: QuestionAdapter

    lateinit var applyJobAdapter: ApplyJobAdapter

    var mMap: GoogleMap? = null

    var jobId = ""
    var jobDetailType = ""

    var mapFragment: SupportMapFragment? = null
    var latitude: String? = null
    var longitude: String? = null
    lateinit var dialog: BottomSheetDialog

    lateinit var jobData: JobDetailResponse.Data
    lateinit var jobDataCaregiverRelated: CaregiverRelatedJobDetailResponse.Data
    var caregiverList: ArrayList<CaregiverListResponse.Data> = ArrayList()
    var caregiverAdapter: CaregiverAdapter? = null

    var pageNum = 1
    var totalPage = ""
    var isClearList = false
    lateinit var txtDataNotFound: TextView
    lateinit var recyclerCaregiver: RecyclerView

    var popupWindow: PopupWindow? = null
    var view_verification: VerificationCodeView? = null
    lateinit var caregiverRelatedJobDetailResponse: CaregiverRelatedJobDetailResponse
    var isMediaRequest = false
    var mediRequestType = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_job_detail)
        jobId = intent.getStringExtra(JOBID).toString()
        jobDetailType = intent.getStringExtra(JOBDETAILTYPE).toString()
        isMediaRequest = intent.getBooleanExtra(ISMEDIAREQUEST, false)
        mediRequestType = intent.getStringExtra(MEDIAREQUESTTYPE).toString()
        init()
    }


    private fun init() {
        arrowBack.setOnClickListener(this)
        relativeApply.setOnClickListener(this)
        relativeCancel.setOnClickListener(this)
        relativeModifyAns.setOnClickListener(this)
        relativeSubstitute.setOnClickListener(this)
        relativeStartJob.setOnClickListener(this)
        relativeOnGoing.setOnClickListener(this)
        chatImg.setOnClickListener(this)

        mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment?
        mapFragment?.getMapAsync(this)

        photoVideoAdapter = PhotoVideoAdapter(activity, photoVideoList)
        recyclerPhotoVideo.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerPhotoVideo.isNestedScrollingEnabled = false
        recyclerPhotoVideo.adapter = photoVideoAdapter

        uploadedMediaAdapter = PhotoVideoAdapter(activity, uploadedMediaList)
        recyclerUploadedMedia.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerUploadedMedia.isNestedScrollingEnabled = false
        recyclerUploadedMedia.adapter = uploadedMediaAdapter

        preferencesAdapter = PreferencesAdapter(activity)
        recyclerPref.layoutManager = LinearLayoutManager(activity)
        recyclerPref.isNestedScrollingEnabled = false
        recyclerPref.adapter = preferencesAdapter

        questionAdapter = QuestionAdapter(activity, questionList)
        recyclerQuestion.layoutManager = LinearLayoutManager(activity)
        recyclerQuestion.isNestedScrollingEnabled = false
        recyclerQuestion.adapter = questionAdapter

        if (isMediaRequest) {
            if (mediRequestType == "image") {
                selectImage()
            } else if (mediRequestType == "video") {
                selectVideo()
            } else if (mediRequestType == "feedback") {
                showFeedbackPopup()
            } else if (mediRequestType == "extraHours") {
                getRequestAddJobHoursDetailApi()
            } else {
                selectBoth()
            }
        }
    }

    private fun showFeedbackPopup() {
        val dialogView = layoutInflater.inflate(R.layout.job_feedback_popup, null)
        val dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val radioBad = dialog.findViewById<RadioButton>(R.id.radioBad)
        val radioAverage = dialog.findViewById<RadioButton>(R.id.radioAverage)
        val radioGood = dialog.findViewById<RadioButton>(R.id.radioGood)
        val etFeedBack = dialog.findViewById<EditText>(R.id.etFeedBack)
        val txtSubmit = dialog.findViewById<TextView>(R.id.txtSubmit)

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }
        var rating = "3"

        radioGood!!.setOnClickListener {
            rating = "3"
        }

        radioAverage!!.setOnClickListener {
            rating = "2"
        }

        radioBad!!.setOnClickListener {
            rating = "1"
        }

        txtSubmit!!.setOnClickListener {
            if (etFeedBack!!.text.toString().isEmpty()) {
                utils.showCustomToast("Kindly share your valuable feedback ")
            } else {
                setFeedBackApi(etFeedBack!!.text.toString(), rating)
                dialog.dismiss()
            }
        }

        dialog.show()
    }


    override fun onResume() {
        super.onResume()
        if (jobDetailType == "job") {
            userImg.visibility = View.VISIBLE
            chatImg.visibility = View.VISIBLE
            relativeApply.visibility = View.GONE
            linearCancelModify.visibility = View.VISIBLE
            getCaregiverRelatedJobDetailApi()

            pageNum = 1
            isClearList = true
            getCaregiverApi("")

        } else {
            userImg.visibility = View.GONE
            chatImg.visibility = View.GONE
            relativeApply.visibility = View.VISIBLE
            linearCancelModify.visibility = View.GONE
            getJobDetailApi()
        }


    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.relativeApply -> if (jobData.questions.isNotEmpty()) {
                jobApplyModifyPopup("apply")
            } else {
                applyUserJobApi()
            }
            R.id.relativeCancel -> cancelJobPopup()
            R.id.relativeModifyAns -> jobApplyModifyPopup("modify")
            R.id.relativeSubstitute -> substitutePopup()
            R.id.relativeStartJob -> {
                if (caregiverRelatedJobDetailResponse.data.startJobStatus == "0") {
                    showAuthDialog(v)
                    popupWindow!!.showAtLocation(v, Gravity.CENTER, 0, 0)
                }else {
                    startActivity(
                        Intent(activity, StartedJobActivity::class.java)
                            .putExtra(StartedJobActivity.JOBDETAILID, caregiverRelatedJobDetailResponse.data.userJobDetailId)
                            .putExtra(StartedJobActivity.JOBID, caregiverRelatedJobDetailResponse.data.userJobId)
                            .putExtra(StartedJobActivity.TOTALSEC, caregiverRelatedJobDetailResponse.data.ongoingJobPendingSeconds)
                            .putExtra(StartedJobActivity.TOTALMIN, caregiverRelatedJobDetailResponse.data.ongoingJobPendingMinutes)
                    )
                }

            }

            R.id.relativeOnGoing->{
                startActivity(
                    Intent(activity, StartedJobActivity::class.java)
                        .putExtra(StartedJobActivity.JOBDETAILID, caregiverRelatedJobDetailResponse.data.userJobDetailId)
                        .putExtra(StartedJobActivity.JOBID, caregiverRelatedJobDetailResponse.data.userJobId)
                        .putExtra(StartedJobActivity.TOTALSEC, caregiverRelatedJobDetailResponse.data.ongoingJobPendingSeconds)
                        .putExtra(StartedJobActivity.TOTALMIN, caregiverRelatedJobDetailResponse.data.ongoingJobPendingMinutes)
                )
            }

            R.id.chatImg -> {
                startActivity(
                    Intent(activity, ChattingActivity::class.java)
                        .putExtra(ChattingActivity.FROMCHATLIST, false)
                        .putExtra(
                            ChattingActivity.ID,
                            caregiverRelatedJobDetailResponse.data.caregiverId
                        )
                )
            }
        }
    }

    private fun selectBoth() {
        val options = arrayOf<CharSequence>(
            "Take Photo",
            "Choose from Gallery",
            "Take Video",
            "Choose Video from Gallery",
            "Cancel"
        )
        val builder = AlertDialog.Builder(activity)
        builder.setTitle("Add Photo & Video!")
        builder.setItems(options) { dialog, item ->
            if (options[item] == "Take Photo") {
                dialog.dismiss()
                permissionUtils!!.requestPermission(PermissionUtils.PERMISSION_CAMERA_PICTURE)
            } else if (options[item] == "Choose from Gallery") {
                permissionUtils?.requestPermission(PermissionUtils.PERMISSION_GALLERY)
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

    private fun selectVideo() {
        val options = arrayOf<CharSequence>(
            "Take Video",
            "Choose Video from Gallery",
            "Cancel"
        )
        val builder = AlertDialog.Builder(activity)
        builder.setTitle("Add Video!")
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

    private fun substitutePopup() {
        val dialogView = layoutInflater.inflate(R.layout.substitute_job_popup, null)
        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)

        val closeImg: ImageView? = dialog.findViewById(R.id.closeImg)
        val txtCancel: TextView? = dialog.findViewById(R.id.txtCancel)
        val txtSubstitute: TextView? = dialog.findViewById(R.id.txtSubstitute)


        txtCancel?.setOnClickListener {
            dialog.dismiss()
            cancelJobPopup();
        }

        txtSubstitute?.setOnClickListener {
            dialog.dismiss()
            substituteCaregiverPopup()
        }

        closeImg?.setOnClickListener {
            dialog.dismiss()
        }

        dialog.show()
    }

    private fun showAuthDialog(view: View) {
        try {
            val inflater = view.context.getSystemService(LAYOUT_INFLATER_SERVICE) as LayoutInflater
            val popupView = inflater.inflate(R.layout.authentication_code_popup, null)
            val width = LinearLayout.LayoutParams.MATCH_PARENT
            val height = LinearLayout.LayoutParams.MATCH_PARENT
            val focusable = true
            popupWindow = PopupWindow(popupView, width, height, focusable)
            popupWindow!!.isOutsideTouchable = true
            val txtStartAppointment = popupView.findViewById<TextView>(R.id.txtStartAppointment)
            view_verification = popupView.findViewById(R.id.view_verification)
            txtStartAppointment.setOnClickListener { v: View? ->
                if (!view_verification!!.isFinish) {
                    utils.showCustomToast("Please enter verification code")
                } else {
                    verifyAuthCodeApi()
                }
            }
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
            Log.e("dbhaaadd", "filterDialog: $e")
        }
    }

    private fun verifyAuthCodeApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val code = view_verification?.content
            val langTokenRequest = VerifyJobVerificationCode(
                VerifyJobVerificationCode.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    caregiverRelatedJobDetailResponse.data.userJobId,
                    caregiverRelatedJobDetailResponse.data.userJobDetailId,
                    code.toString()
                )
            )

            val getProfileCall: Call<VerifyJobCodeResponse> =
                RetrofitClient.getClient.verifyJobVerificationCode(langTokenRequest)
            getProfileCall.enqueue(object : Callback<VerifyJobCodeResponse?> {
                override fun onResponse(
                    call: Call<VerifyJobCodeResponse?>,
                    response: Response<VerifyJobCodeResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val getCaregiverMyProfileResponse: VerifyJobCodeResponse =
                            response.body()!!
                        when (getCaregiverMyProfileResponse.status) {
                            "1" -> {
                                popupWindow?.dismiss()
                                startActivity(
                                    Intent(activity, StartedJobActivity::class.java)
                                        .putExtra(
                                            StartedJobActivity.JOBDETAILID,
                                            getCaregiverMyProfileResponse.data.userJobDetailId
                                        )
                                        .putExtra(
                                            StartedJobActivity.JOBID,
                                            getCaregiverMyProfileResponse.data.userJobId
                                        )
                                        .putExtra(
                                            StartedJobActivity.TOTALSEC,
                                            getCaregiverMyProfileResponse.data.TotalSeconds
                                        )
                                        .putExtra(
                                            StartedJobActivity.TOTALMIN,
                                            getCaregiverMyProfileResponse.data.totalMinutes
                                        )
                                )
                            }
                            "6" -> {
//                                utils.showCustomToast(getCertificationsLicensesResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    getCaregiverMyProfileResponse.status,
                                    getCaregiverMyProfileResponse.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<VerifyJobCodeResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun substituteCaregiverPopup() {
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

        caregiverAdapter = CaregiverAdapter(activity, caregiverList)
        recyclerCaregiver.layoutManager = LinearLayoutManager(activity)

        recyclerCaregiver.addOnScrollListener(object : RecyclerView.OnScrollListener() {
            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                super.onScrolled(recyclerView, dx, dy)
                if ((recyclerCaregiver.layoutManager as LinearLayoutManager).findLastVisibleItemPosition() == caregiverList.size - 1 && pageNum != totalPage.toInt()
                ) {
                    pageNum++
                    isClearList = false
                    getCaregiverApi(etSearch!!.text.toString())
                }
            }
        })


        recyclerCaregiver.adapter = caregiverAdapter

//        caregiverAdapter.notifyDataSetChanged()

        etSearch?.setOnEditorActionListener(OnEditorActionListener { v, actionId, event ->
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
                caregiverSubstituteJobApi(caregiverAdapter!!.caregiverId)
            } else {
                utils.showCustomToast("Please select caregiver")
            }
        }
        dialog.show()
    }

    private fun cancelJobPopup() {
        val dialogView = layoutInflater.inflate(R.layout.cancel_job_popup, null)
        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)

        val closeImg: ImageView? = dialog.findViewById(R.id.closeImg)
        val txtNo: TextView? = dialog.findViewById(R.id.txtNo)
        val txtYes: TextView? = dialog.findViewById(R.id.txtYes)


        txtYes?.setOnClickListener {
            if (jobDataCaregiverRelated.jobStatus == "1") {
                cancelUpcomingJob()
//                Toast.makeText(activity, "Upcoming", Toast.LENGTH_SHORT).show()
            } else {
                cancelJobRequestApi(jobDataCaregiverRelated.userJobApplyId)
//                Toast.makeText(activity, "Cancel Job", Toast.LENGTH_SHORT).show()
            }
        }

        txtNo?.setOnClickListener {
            dialog.dismiss()
        }

        closeImg?.setOnClickListener {
            dialog.dismiss()
        }

        dialog.show()

    }

    private fun cancelUpcomingJob() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CancelUpcomingJobRequest(
                CancelUpcomingJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId,
                    jobDataCaregiverRelated.userJobApplyId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.cancelUpcomingJob(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val getJobCategoruListResponse: CommonResponse =
                            response.body()!!
                        when (getJobCategoruListResponse.status) {
                            "1" -> {
                                dialog.dismiss()
                                activity.finish()
                            }
                            "6" -> {
//                                utils.showCustomToast(getCertificationsLicensesResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    getJobCategoruListResponse.status,
                                    getJobCategoruListResponse.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<CommonResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun jobApplyModifyPopup(type: String) {
        val dialogView = layoutInflater.inflate(R.layout.apply_job_popup, null)
        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)

        val recyclerQuestionAnswer: RecyclerView? = dialog.findViewById(R.id.recyclerQuestionAnswer)
        val closeImg: ImageView? = dialog.findViewById(R.id.closeImg)
        val txtSubmitApply: TextView? = dialog.findViewById(R.id.txtSubmitApply)
        val title: TextView? = dialog.findViewById(R.id.title)

        if (type == "apply") {
            title?.text = "Additional Questions"
            txtSubmitApply?.text = "Submit & Apply"
        } else {
            title?.text = "Modify Answers"
            txtSubmitApply?.text = "Submit"
        }

        applyJobAdapter = ApplyJobAdapter(activity, questionAnswerList, questionList)
        recyclerQuestionAnswer?.layoutManager = LinearLayoutManager(activity)
        recyclerQuestionAnswer?.isNestedScrollingEnabled = false
        recyclerQuestionAnswer?.adapter = applyJobAdapter

        txtSubmitApply?.setOnClickListener {
            if (isValid()) {
                if (type == "apply") {
                    applyUserJobApi()
                } else {
                    modifyJobApi()
                }
            }
        }

        closeImg?.setOnClickListener {
            dialog.dismiss()
        }
        dialog.show()

    }

    private fun getJobDetailApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = JobDetailRequest(
                JobDetailRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId,
                    "",
                    ""
                )
            )

            val signUp: Call<JobDetailResponse?> =
                RetrofitClient.getClient.getUserJobDetail(langTokenRequest)
            signUp.enqueue(object : Callback<JobDetailResponse?> {
                override fun onResponse(
                    call: Call<JobDetailResponse?>,
                    response: Response<JobDetailResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: JobDetailResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                txtDataNotFoundMain.visibility = View.GONE
                                relativeBottom.visibility = View.VISIBLE
                                nestedScroll.visibility = View.VISIBLE
                                userImg.visibility = View.VISIBLE
                                chatImg.visibility = View.VISIBLE

                                jobData = response.data
                                userImg2.visibility = View.VISIBLE
                                userImg.visibility = View.GONE
                                chatImg.visibility = View.GONE

                                Glide.with(activity)
                                    .load(jobData.profileImageThumbUrl)
                                    .placeholder(R.drawable.placeholder)
                                    .centerCrop()
                                    .into(userImg2)

                                txtDate.text = jobData.startDateTime
                                txtCategory.text = jobData.CategoryName
                                txtDesc.text = jobData.description
                                txtTitle.text = jobData.userFullName
                                txtHourAgo.text = jobData.createdDateFormat
                                txtJobName.text = jobData.name
                                txtMile.text = jobData.distance + " ml"
                                txtPrice.text = jobData.formatedPrice + "/hr"

                                photoVideoList.clear()
                                photoVideoList.addAll(jobData.media)
                                photoVideoAdapter.notifyDataSetChanged()


                                if (photoVideoList.isEmpty()) {
                                    linearPhotoVideo.visibility = View.GONE
                                }

                                if (jobData.questions.isEmpty()) {
                                    linearQuestion.visibility = View.GONE
                                } else {
                                    linearQuestion.visibility = View.VISIBLE
                                    questionList.clear()
                                    questionList.addAll(jobData.questions)
                                    questionAdapter.notifyDataSetChanged()
                                }


                                if (jobData.isJobApply == "0") {
                                    relativeApply.visibility = View.VISIBLE
                                } else {
                                    relativeApply.visibility = View.GONE
                                }

                                if (jobData.isJob == "1") {
                                    txtType.text = "One Time"
                                } else {
                                    txtType.text = "Recurring"
                                }

                                latitude = jobData.latitude
                                longitude = jobData.longitude
                                onMapReady(mMap)

                                questionAnswerList.clear()
                                for (i in questionList.indices) {
                                    val queData =
                                        QuestionAnswer(questionList[i].userJobQuestionId, "")
                                    questionAnswerList.add(queData)
                                }
                            }
                            "6" -> {
                                txtDataNotFoundMain.visibility = View.VISIBLE
                                nestedScroll.visibility = View.GONE
                                relativeBottom.visibility = View.GONE
                                userImg.visibility = View.GONE
                                chatImg.visibility = View.GONE
                                txtDataNotFoundMain.text = response.message
//                                utils.showCustomToast(response.message)
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<JobDetailResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getCaregiverRelatedJobDetailApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CaregiverRelatedJobDetailRequest(
                CaregiverRelatedJobDetailRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId
                )
            )

            val signUp: Call<CaregiverRelatedJobDetailResponse?> =
                RetrofitClient.getClient.getCaregiverRelatedJobDetail(langTokenRequest)
            signUp.enqueue(object : Callback<CaregiverRelatedJobDetailResponse?> {
                override fun onResponse(
                    call: Call<CaregiverRelatedJobDetailResponse?>,
                    response: Response<CaregiverRelatedJobDetailResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        caregiverRelatedJobDetailResponse = response.body()!!
                        when (caregiverRelatedJobDetailResponse.status) {
                            "1" -> {
                                txtDataNotFoundMain.visibility = View.GONE
                                nestedScroll.visibility = View.VISIBLE
                                relativeBottom.visibility = View.VISIBLE
                                userImg.visibility = View.VISIBLE
                                chatImg.visibility = View.VISIBLE

                                jobDataCaregiverRelated = caregiverRelatedJobDetailResponse.data

                                Glide.with(activity)
                                    .load(jobDataCaregiverRelated.profileImageThumbUrl)
                                    .placeholder(R.drawable.placeholder)
                                    .centerCrop()
                                    .into(userImg)

                                txtDate.text = jobDataCaregiverRelated.startDateTime
                                txtCategory.text = jobDataCaregiverRelated.CategoryName
                                txtDesc.text = jobDataCaregiverRelated.description
                                txtTitle.text = jobDataCaregiverRelated.userFullName
                                txtHourAgo.text = jobDataCaregiverRelated.createdDateFormat
                                txtJobName.text = jobDataCaregiverRelated.name
                                txtMile.text = jobDataCaregiverRelated.distance + " ml"
                                txtPrice.text = jobDataCaregiverRelated.formatedPrice + "/hr"

                                photoVideoList.clear()
                                photoVideoList.addAll(jobDataCaregiverRelated.media)
                                photoVideoAdapter.notifyDataSetChanged()

                                uploadedMediaList.clear()
                                uploadedMediaList.addAll(jobDataCaregiverRelated.uploadedMedia)
                                uploadedMediaAdapter.notifyDataSetChanged()

                                if (photoVideoList.isEmpty()) {
                                    linearPhotoVideo.visibility = View.GONE
                                }

                                if (uploadedMediaList.isEmpty()) {
                                    linearUploadedMedia.visibility = View.GONE
                                } else {
                                    linearUploadedMedia.visibility = View.VISIBLE
                                }

                                if (jobDataCaregiverRelated.questions.isEmpty()) {
                                    linearQuestion.visibility = View.GONE
                                } else {
                                    linearQuestion.visibility = View.VISIBLE
                                    questionList.clear()
                                    questionList.addAll(jobDataCaregiverRelated.questions)
                                    questionAdapter.notifyDataSetChanged()
                                }

                                if (jobDataCaregiverRelated.isJob == "1") {
                                    txtType.text = "One Time"
                                } else {
                                    txtType.text = "Recurring"
                                }

                                latitude = jobDataCaregiverRelated.latitude
                                longitude = jobDataCaregiverRelated.longitude
                                onMapReady(mMap)

                                questionAnswerList.clear()
                                for (i in questionList.indices) {
                                    val queData =
                                        QuestionAnswer(questionList[i].userJobQuestionId, "")
                                    questionAnswerList.add(queData)
                                }

                                try {
                                    ratingBar.rating = jobDataCaregiverRelated.jobRating.toFloat()
                                    txtFeedback.text = jobDataCaregiverRelated.jobFeedback
                                } catch (e: Exception) {
                                }

                                when (jobDataCaregiverRelated.jobStatus) {
                                    "1" -> {
                                        cardMap.visibility = View.VISIBLE
                                        linearRating.visibility = View.GONE
                                        linearCancelModify.visibility = View.GONE
                                        relativeApply.visibility = View.GONE

                                        txtHourAgo.visibility = View.VISIBLE
                                        txtComplete.visibility = View.GONE

                                        if (jobDataCaregiverRelated.startJobStatus == "0") {
//                                            txtStartJob.text = "Start Job"
                                            linearSubstituteStartJob.visibility = View.VISIBLE
                                            relativeOnGoing.visibility = View.GONE
                                        } else {
//                                            txtStartJob.text = "Ongoing"
                                            linearSubstituteStartJob.visibility = View.GONE
                                            relativeOnGoing.visibility = View.VISIBLE
                                        }
                                    }
                                    "2" -> {
                                        cardMap.visibility = View.GONE
                                        linearRating.visibility = View.VISIBLE
                                        relativeOnGoing.visibility = View.GONE
                                        linearCancelModify.visibility = View.GONE
                                        relativeApply.visibility = View.GONE
                                        linearSubstituteStartJob.visibility = View.GONE
                                        txtHourAgo.visibility = View.GONE
                                        txtComplete.visibility = View.VISIBLE
                                    }
                                    "3" -> {
                                        cardMap.visibility = View.GONE
                                        linearRating.visibility = View.GONE
                                        linearCancelModify.visibility = View.VISIBLE
                                        relativeApply.visibility = View.GONE
                                        relativeOnGoing.visibility = View.GONE
                                        linearSubstituteStartJob.visibility = View.GONE
                                        txtHourAgo.visibility = View.VISIBLE
                                        txtComplete.visibility = View.GONE
                                    }
                                }


                            }
                            "6" -> {
                                txtDataNotFoundMain.visibility = View.VISIBLE
                                nestedScroll.visibility = View.GONE
                                relativeBottom.visibility = View.GONE
                                userImg.visibility = View.GONE
                                chatImg.visibility = View.GONE
                                txtDataNotFoundMain.text = caregiverRelatedJobDetailResponse.message
//                                utils.showCustomToast(response.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    caregiverRelatedJobDetailResponse.status,
                                    caregiverRelatedJobDetailResponse.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<CaregiverRelatedJobDetailResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getRequestAddJobHoursDetailApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CaregiverRelatedJobDetailRequest(
                CaregiverRelatedJobDetailRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId
                )
            )

            val signUp: Call<RequestAddJobResponse?> =
                RetrofitClient.getClient.getRequestAddJobHoursDetail(langTokenRequest)
            signUp.enqueue(object : Callback<RequestAddJobResponse?> {
                override fun onResponse(
                    call: Call<RequestAddJobResponse?>,
                    response: Response<RequestAddJobResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: RequestAddJobResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                extraHoursPopup(response)
                            }
                            "6" -> {
                                utils.showCustomToast(response.message)
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<RequestAddJobResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun cancelJobRequestApi(userJobApplyId: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CancelJobRequest(
                CancelJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    userJobApplyId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.cancelJobRequest(langTokenRequest)
            signUp.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val getJobCategoruListResponse: CommonResponse =
                            response.body()!!
                        when (getJobCategoruListResponse.status) {
                            "1" -> {
                                dialog.dismiss()
                                activity.finish()
                            }
                            "6" -> {
//                                utils.showCustomToast(getCertificationsLicensesResponse.message)
                            }
                            else -> {
                                checkStatus(
                                    relative,
                                    getJobCategoruListResponse.status,
                                    getJobCategoruListResponse.message
                                )
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<CommonResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
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

    private fun caregiverSubstituteJobApi(caregiverId: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CaregiverSubstituteJobRequest(
                CaregiverSubstituteJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobDataCaregiverRelated.userJobId,
                    jobDataCaregiverRelated.userJobApplyId,
                    caregiverId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.sendSubstituteJobRequest(langTokenRequest)
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
                                dialog.dismiss()
                                activity.finish()
//                                caregiverAdapter.notifyDataSetChanged()
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

    override fun onMapReady(googleMap: GoogleMap?) {
        mMap = googleMap

        if (latitude != null && longitude != null) {
            googleMap?.uiSettings?.isZoomControlsEnabled = true
            googleMap?.uiSettings?.isRotateGesturesEnabled = true
            googleMap?.uiSettings?.isScrollGesturesEnabled = true
            googleMap?.uiSettings?.isTiltGesturesEnabled = true
            mMap!!.uiSettings.isZoomControlsEnabled = true
            mMap!!.animateCamera(
                CameraUpdateFactory.newLatLngZoom(
                    LatLng(
                        latitude!!.toDouble(),
                        longitude!!.toDouble()
                    ), 15f
                )
            )
            mMap!!.clear()
            val circleDrawable = resources.getDrawable(R.drawable.current_location_pin)
            val markerIcon: BitmapDescriptor = getMarkerIconFromDrawable(circleDrawable)
            mMap!!.addMarker(
                MarkerOptions()
                    .position(LatLng(latitude!!.toDouble(), longitude!!.toDouble()))
                    .title("Your location")
                    .icon(markerIcon)
            )
        }
    }

    private fun applyUserJobApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = ApplyJobRequest(
                ApplyJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId,
                    questionAnswerList
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.applyUserJob(langTokenRequest)
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
                                try {
                                    dialog.dismiss()
                                } catch (e: Exception) {
                                }
                                utils.showCustomToast(response.message)
                                getJobDetailApi()
                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
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

    private fun modifyJobApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = ModifyAnswerRequest(
                ModifyAnswerRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId,
                    jobDataCaregiverRelated.userJobApplyId,
                    questionAnswerList
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.modifyJobAnswer(langTokenRequest)
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
                                dialog.dismiss()
                                utils.showCustomToast(response.message)
                                getCaregiverRelatedJobDetailApi()
                            }
                            "6" -> {
//                                utils.showCustomToast(response.message)
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

    private fun getMarkerIconFromDrawable(drawable: Drawable): BitmapDescriptor {
        val canvas = Canvas()
        val bitmap = Bitmap.createBitmap(
            drawable.intrinsicWidth,
            drawable.intrinsicHeight,
            Bitmap.Config.ARGB_8888
        )
        canvas.setBitmap(bitmap)
        drawable.setBounds(0, 0, drawable.intrinsicWidth, drawable.intrinsicHeight)
        drawable.draw(canvas)
        return BitmapDescriptorFactory.fromBitmap(bitmap)
    }

    private fun uploadJobMedia(mediaName: String, videoThumb: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = RequestMediaUploadRequest(
                RequestMediaUploadRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId,
                    mediaName,
                    videoThumb
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.uploadJobMedia(langTokenRequest)
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

    private fun setFeedBackApi(feedBackText: String, rating: String) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = OnGoingJobReviewRequest(
                OnGoingJobReviewRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId,
                    rating,
                    feedBackText
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.setOngoingJobReview(langTokenRequest)
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

                                    if (mediaUploadResponse.data[0].mediaName.contains(".mp4")
                                        || mediaUploadResponse.data[0].mediaName.contains(".avi")
                                        || mediaUploadResponse.data[0].mediaName.contains(".mkv")
                                    ) {

                                        uploadJobMedia(
                                            mediaUploadResponse.data[0].mediaName,
                                            mediaUploadResponse.data[0].videoThumbImgName
                                        )
                                    } else {
                                        uploadJobMedia(mediaUploadResponse.data[0].mediaName, "")
                                    }
                                    getCaregiverRelatedJobDetailApi()
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

    private fun extraHoursPopup(response: RequestAddJobResponse) {
        val dialogView = layoutInflater.inflate(R.layout.additional_hours_popup, null)
        dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)

        val closeImg: ImageView? = dialog.findViewById(R.id.closeImg)
        val txtDecline: TextView? = dialog.findViewById(R.id.txtDecline)
        val txtAccept: TextView? = dialog.findViewById(R.id.txtAccept)
        val txtPreviousHr: TextView? = dialog.findViewById(R.id.txtPreviousHr)
        val txtUpdatedHours: TextView? = dialog.findViewById(R.id.txtUpdatedHours)

        txtPreviousHr?.text = response.data.perviousHours
        txtUpdatedHours?.text = response.data.updatedHours

        txtAccept?.setOnClickListener {
            acceptAdditionalHrApi(dialog)
        }

        txtDecline?.setOnClickListener {
            declineAdditionalHrApi(dialog)
        }

        closeImg?.setOnClickListener {
            dialog.dismiss()
        }

        dialog.show()
    }

    private fun declineAdditionalHrApi(dialog: BottomSheetDialog) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CaregiverRelatedJobDetailRequest(
                CaregiverRelatedJobDetailRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.declineAddJobHoursRequest(langTokenRequest)
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
                                dialog.dismiss()
                            }
                            "6" -> {

                            }

                            else -> {
                                dialog.dismiss()
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<CommonResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun acceptAdditionalHrApi(dialog: BottomSheetDialog) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CaregiverRelatedJobDetailRequest(
                CaregiverRelatedJobDetailRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.acceptAddJobHoursRequest(langTokenRequest)
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
                                dialog.dismiss()
                            }
                            "6" -> {

                            }
                            else -> {
                                dialog.dismiss()
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(
                    call: Call<CommonResponse?>,
                    t: Throwable
                ) {
                    utils.dismissProgress()
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun isValid(): Boolean {
        var message: String
        message = ""

        for (i in applyJobAdapter.questionAnswerList.indices) {
            val count = i + 1
            if (applyJobAdapter.questionAnswerList[i].answer == "") {
                message = "Please enter answer $count"
                break
            }
        }


        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showCustomToast(message)
        }
        return message.trim().isEmpty()
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