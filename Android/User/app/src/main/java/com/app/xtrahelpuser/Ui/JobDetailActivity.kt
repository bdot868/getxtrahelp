package com.app.xtrahelpuser.Ui

import android.app.TimePickerDialog
import android.content.DialogInterface
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.*
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.CommonResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.ApplicantAdapter
import com.app.xtrahelpuser.Adapter.PhotoVideoListAdapter
import com.app.xtrahelpuser.Adapter.PreferencesListAdapter
import com.app.xtrahelpuser.Adapter.QuestionListAdapter
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.*
import com.app.xtrahelpuser.Response.PostedJobDetailResponse
import com.app.xtrahelpuser.Response.UserRelatedJobDetailResponse
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
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.android.synthetic.main.activity_job_detail.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*

class JobDetailActivity : BaseActivity(), OnMapReadyCallback {

    companion object {
        val JOBID: String = "jobId"
        val ISUSERRELATEDJOB: String = "isUserRelatedJob"
        val ISFEEDBACK: String = "isFeedback"

    }

    lateinit var jobData: PostedJobDetailResponse.Data;
    lateinit var userRelatedJob: UserRelatedJobDetailResponse.Data;

    lateinit var photoVideoAdapter: PhotoVideoListAdapter
    lateinit var uploadedMediaAdapter: PhotoVideoListAdapter
    lateinit var preferencesAdapter: PreferencesListAdapter
    lateinit var questionAdapter: QuestionListAdapter
    lateinit var applicantAdapter: ApplicantAdapter

    var photoVideoList: ArrayList<PostedJobDetailResponse.Data.Media> = ArrayList()
    var uploadedMediaList: ArrayList<PostedJobDetailResponse.Data.Media> = ArrayList()
    var questionList: ArrayList<PostedJobDetailResponse.Data.Question> = ArrayList()
    var applicantList: ArrayList<PostedJobDetailResponse.Data.Applicants> = ArrayList()


    var mMap: GoogleMap? = null
    var jobId = ""
    var mapFragment: SupportMapFragment? = null
    var latitude: String? = null
    var longitude: String? = null
    var isUserRelatedJob: Boolean = false

    var userJobId = ""
    var userId = ""
    var requestMediaType = ""

    var isFeedback = false

    lateinit var userRelatedJobResponse: UserRelatedJobDetailResponse

    val cldr = Calendar.getInstance()
    var picker: TimePickerDialog? = null
    var hour = cldr[Calendar.HOUR_OF_DAY]
    var hour1 = cldr[Calendar.HOUR_OF_DAY]
    var minutes = cldr[Calendar.MINUTE]
    var minutes1 = cldr[Calendar.MINUTE]

    var startTime = ""
    var endTime = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_job_detail)
        txtTitle.text = "Applicants"
        jobId = intent.getStringExtra(JOBID).toString()
        isUserRelatedJob = intent.getBooleanExtra(ISUSERRELATEDJOB, false)
        isFeedback = intent.getBooleanExtra(ISFEEDBACK, false)
        init()
    }


    private fun init() {
        arrowBack.setOnClickListener(this)
        txtViewAllApplicants.setOnClickListener(this)
        relativeCancelJob.setOnClickListener(this)
        relativeCancel.setOnClickListener(this)
        chatIcon.setOnClickListener(this)
        txtReview.setOnClickListener(this)
        txtRequest.setOnClickListener(this)
        relativeAddHours.setOnClickListener(this)

        mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment?
        mapFragment?.getMapAsync(this)

        photoVideoAdapter = PhotoVideoListAdapter(activity, photoVideoList)
        recyclerPhotoVideo.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerPhotoVideo.isNestedScrollingEnabled = false
        recyclerPhotoVideo.adapter = photoVideoAdapter

        uploadedMediaAdapter = PhotoVideoListAdapter(activity, uploadedMediaList)
        recyclerUploadedMedia.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerUploadedMedia.isNestedScrollingEnabled = false
        recyclerUploadedMedia.adapter = uploadedMediaAdapter

        preferencesAdapter = PreferencesListAdapter(activity)
        recyclerPref.layoutManager = LinearLayoutManager(activity)
        recyclerPref.isNestedScrollingEnabled = false
        recyclerPref.adapter = preferencesAdapter

        questionAdapter = QuestionListAdapter(activity, questionList)
        recyclerQuestion.layoutManager = LinearLayoutManager(activity)
        recyclerQuestion.isNestedScrollingEnabled = false
        recyclerQuestion.adapter = questionAdapter

        applicantAdapter = ApplicantAdapter(activity, applicantList)
        recyclerApplicants.layoutManager =
            LinearLayoutManager(activity, RecyclerView.HORIZONTAL, false)
        recyclerApplicants.isNestedScrollingEnabled = false
        recyclerApplicants.adapter = applicantAdapter

        if (isFeedback) {
            showFeedbackPopup()
        }
    }


    override fun onResume() {
        super.onResume()
        if (isUserRelatedJob) {
            getUserRelatedJobApi()
        } else {
            getPostedJobDetailApi()
        }
    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtViewAllApplicants -> startActivity(
                Intent(activity, ApplicantsListActivity::class.java)
                    .putExtra(ApplicantsListActivity.JOBID, jobData.userJobId)
            )

            R.id.relativeCancelJob -> {
                cancelPopup()
            }

            R.id.relativeCancel -> {
                cancelPopup()
            }

            R.id.chatIcon -> {
                startActivity(
                    Intent(activity, ChattingActivity::class.java)
                        .putExtra(ChattingActivity.ID, userId)
                        .putExtra(ChattingActivity.FROMCHATLIST, false)
                )
            }

            R.id.txtRequest -> {
                showRequestMediaDialog()
            }

            R.id.relativeAddHours -> addHoursPopup()

            R.id.txtReview -> {
                startActivity(
                    Intent(activity, GiveReviewActivity::class.java)
                        .putExtra(GiveReviewActivity.JOBID, userRelatedJob.userJobId)
                        .putExtra(GiveReviewActivity.NAME, userRelatedJob.userFullName)
                        .putExtra(GiveReviewActivity.RATING, userRelatedJob.jobRating)
                        .putExtra(GiveReviewActivity.FEEDBACK, userRelatedJob.jobFeedback)
                        .putExtra(
                            GiveReviewActivity.PROFILEIMG,
                            userRelatedJob.profileImageThumbUrl
                        )
                )

//                startActivity(Intent(activity, GiveReviewActivity::class.java))

            }
        }
    }

    private fun addHoursPopup() {
        val dialogView = layoutInflater.inflate(R.layout.add_hour_popup, null)
        val dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val txtSubmit = dialog.findViewById<TextView>(R.id.txtSubmit)
        val txtStartTime = dialog.findViewById<TextView>(R.id.txtStartTime)
        val txtEndTime = dialog.findViewById<TextView>(R.id.txtEndTime)

        txtStartTime?.text = userRelatedJobResponse.data.endTime
        startTime = userRelatedJobResponse.data.endTime

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }
        txtEndTime?.setOnClickListener {
            endDate(txtEndTime)
        }
        txtSubmit!!.setOnClickListener {
            sendJobExtraHrApi(dialog)
        }

        dialog.show()
    }


    private fun endDate(txtEndTime: TextView) {
        picker = TimePickerDialog(
            activity,
            { tp: TimePicker?, sHour: Int, sMinute: Int ->
                hour1 = sHour
                minutes1 = sMinute
                val calendar = Calendar.getInstance()
                calendar[Calendar.HOUR_OF_DAY] = sHour
                calendar[Calendar.MINUTE] = sMinute
                val dateIn12Hour = SimpleDateFormat("hh:mm a").format(calendar.timeInMillis)
                val tempEndTime = SimpleDateFormat("HH:mm").format(calendar.timeInMillis)
                Log.e("TAG", "onTimeSet123: $tempEndTime")

                val dateFormat = SimpleDateFormat("HH:mm")
                var date: Date? = null
                var date1: Date? = null
                try {
                    date = dateFormat.parse(startTime)
                    date1 = dateFormat.parse(tempEndTime)
                } catch (e: ParseException) {
                    e.printStackTrace()
                }

                if (date!!.after(date1)) {
                    utils.showCustomToast("End time is greater than finish time.")
                } else {
                    endTime = SimpleDateFormat("HH:mm").format(calendar.timeInMillis)
                    txtEndTime.setText(dateIn12Hour.toLowerCase())
                    endTime = dateIn12Hour.toLowerCase()
                }
            }, hour1, minutes1, false
        )
        picker!!.show()
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

    private fun showRequestMediaDialog() {
        val dialogView = layoutInflater.inflate(R.layout.request_video_image_popup, null)
        val dialog = BottomSheetDialog(activity, R.style.MyDialog)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.setCancelable(true)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setContentView(dialogView)
        val closeImg = dialog.findViewById<ImageView>(R.id.closeImg)
        val relativeImage = dialog.findViewById<RelativeLayout>(R.id.relativeImage)
        val relativeVideo = dialog.findViewById<RelativeLayout>(R.id.relativeVideo)
        val txtSubmit = dialog.findViewById<TextView>(R.id.txtSubmit)

        closeImg!!.setOnClickListener { v: View? -> dialog.dismiss() }
        relativeImage?.setOnClickListener {
            relativeImage.background = resources.getDrawable(R.drawable.request_media_select)
            relativeVideo?.background = resources.getDrawable(R.drawable.request_media_unselect)
            requestMediaType = "1"
        }

        relativeVideo?.setOnClickListener {
            relativeVideo.background = resources.getDrawable(R.drawable.request_media_select)
            relativeImage?.background = resources.getDrawable(R.drawable.request_media_unselect)
            requestMediaType = "2"
        }

        txtSubmit!!.setOnClickListener { v: View? ->
            if (requestMediaType == "") {
                utils.showCustomToast("Please select what you need")
            } else {
                requestMediaApi()
                dialog.dismiss()
            }
        }

        dialog.show()
    }

    private fun cancelPopup() {
        MaterialAlertDialogBuilder(this)
            .setCancelable(false)
            .setMessage("Are you sure want to cancel this job?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int -> cancelJobApi() }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }

    private fun getPostedJobDetailApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = PostedJobDetailRequest(
                PostedJobDetailRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId
                )
            )

            val signUp: Call<PostedJobDetailResponse?> =
                RetrofitClient.getClient.getMyPostedJobDetail(langTokenRequest)
            signUp.enqueue(object : Callback<PostedJobDetailResponse?> {
                override fun onResponse(
                    call: Call<PostedJobDetailResponse?>,
                    response: Response<PostedJobDetailResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response: PostedJobDetailResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                nestedScroll.visibility = View.VISIBLE
                                relativeCancelJob.visibility = View.VISIBLE
                                txtDataNotFound.visibility = View.GONE

                                jobData = response.data
                                userJobId = jobData.userJobId
                                userId = jobData.userId
                                txtDate.text = jobData.startDateTime
                                txtCategory.text = jobData.CategoryName
                                txtDesc.text = jobData.description
                                txtTitle.text = jobData.name
                                txtHourAgo.text = jobData.createdDateFormat
                                txtJobName.text = jobData.name
                                txtPrice.text = jobData.formatedPrice + "/hr"


                                photoVideoList.clear()
                                photoVideoList.addAll(jobData.media)
                                photoVideoAdapter.notifyDataSetChanged()

                                if (photoVideoList.isEmpty()) {
                                    recyclerPhotoVideo.visibility = View.GONE
                                }

                                if (jobData.questions.isEmpty()) {
                                    linearQuestion.visibility = View.GONE
                                } else {
                                    linearQuestion.visibility = View.VISIBLE
                                    questionList.clear()
                                    questionList.addAll(jobData.questions)
                                    questionAdapter.notifyDataSetChanged()
                                }

                                applicantList.clear()
                                if (jobData.applicants.isEmpty()) {
                                    linearApplicant.visibility = View.GONE
                                } else {
                                    linearApplicant.visibility = View.VISIBLE
                                    applicantList.addAll(jobData.applicants)
                                    applicantAdapter.notifyDataSetChanged()
                                }

                                if (jobData.isJob == "1") {
                                    txtType.text = "One Time"
                                } else {
                                    txtType.text = "Recurring"
                                }

                                latitude = jobData.latitude
                                longitude = jobData.longitude
                                onMapReady(mMap)

                            }
                            "6" -> {
                                nestedScroll.visibility = View.GONE
                                relativeCancelJob.visibility = View.GONE
                                txtDataNotFound.visibility = View.VISIBLE
                                txtDataNotFound.text = response.message
//                                utils.showCustomToast(response.message)
                            }
                            else -> {
                                checkStatus(relative, response.status, response.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<PostedJobDetailResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun getUserRelatedJobApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = UserRelatedJobDetailRequest(
                UserRelatedJobDetailRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    jobId
                )
            )

            val signUp: Call<UserRelatedJobDetailResponse?> =
                RetrofitClient.getClient.getUserRelatedJobDetail(langTokenRequest)
            signUp.enqueue(object : Callback<UserRelatedJobDetailResponse?> {
                override fun onResponse(
                    call: Call<UserRelatedJobDetailResponse?>,
                    response: Response<UserRelatedJobDetailResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        userRelatedJobResponse = response.body()!!
                        val response: UserRelatedJobDetailResponse = response.body()!!
                        when (response.status) {
                            "1" -> {
                                val jobData = response.data
                                userRelatedJob = response.data

                                userJobId = jobData.userJobId
                                userId = jobData.userId

                                txtDate.text = jobData.startDateTime
                                txtCategory.text = jobData.CategoryName
                                txtDesc.text = jobData.description
                                txtTitle.text = jobData.name
                                txtJobName.text = jobData.name
                                txtPrice.text = jobData.formatedPrice + "/hr"


                                photoVideoList.clear()
                                photoVideoList.addAll(jobData.media)
                                photoVideoAdapter.notifyDataSetChanged()

                                uploadedMediaList.clear()
                                uploadedMediaList.addAll(jobData.uploadedMedia)
                                uploadedMediaAdapter.notifyDataSetChanged()

                                if (photoVideoList.isEmpty()) {
                                    recyclerPhotoVideo.visibility = View.GONE
                                }

                                if (uploadedMediaList.isEmpty()) {
                                    linearUploadedMedia.visibility = View.GONE
                                } else {
                                    linearUploadedMedia.visibility = View.VISIBLE
                                }

                                if (jobData.questions.isEmpty()) {
                                    linearQuestion.visibility = View.GONE
                                } else {
                                    linearQuestion.visibility = View.VISIBLE
                                    questionList.clear()
                                    questionList.addAll(jobData.questions)
                                    questionAdapter.notifyDataSetChanged()
                                }

                                linearApplicant.visibility = View.GONE
                                txtHourAgo.visibility = View.GONE

                                if (jobData.isJob == "1") {
                                    txtType.text = "One Time"
                                } else {
                                    txtType.text = "Recurring"
                                }

                                latitude = jobData.latitude
                                longitude = jobData.longitude
                                onMapReady(mMap)

                                if (jobData.jobStatus == "1") {
//                                    linearCancelAddHours.visibility = View.VISIBLE
                                    relativeCancelJob.visibility = View.GONE
                                    linearRating.visibility = View.GONE
                                    txtRequest.visibility = View.VISIBLE

                                    if (jobData.startJobStatus == "1") {
                                        linearCancelAddHours.visibility = View.VISIBLE
                                        txtRequest.visibility = View.VISIBLE
                                        relativeCancelJob.visibility = View.GONE
                                    } else {
                                        linearCancelAddHours.visibility = View.GONE
                                        txtRequest.visibility = View.GONE
                                        relativeCancelJob.visibility = View.VISIBLE
                                    }

                                } else if (jobData.jobStatus == "3") {
                                    linearRating.visibility = View.VISIBLE
                                    txtRequest.visibility = View.GONE
                                    linearCancelAddHours.visibility = View.GONE
                                    relativeCancelJob.visibility = View.GONE
                                    completeImage.visibility = View.VISIBLE
                                } else {
                                    relativeCancelJob.visibility = View.GONE
                                    linearCancelAddHours.visibility = View.GONE
                                    txtHourAgo.visibility = View.GONE
                                    completeImage.visibility = View.VISIBLE
                                    linearRating.visibility = View.GONE
                                    txtRequest.visibility = View.VISIBLE
                                }



                                if (jobData.jobFeedback.isNotEmpty()) {
                                    txtReview.text = "Edit Review"
                                }
                                try {
                                    ratingBar.rating = jobData.jobRating.toFloat()
                                    txtFeedback.text = jobData.jobFeedback
                                } catch (e: Exception) {
                                }


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

                override fun onFailure(call: Call<UserRelatedJobDetailResponse?>, t: Throwable) {
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    private fun cancelJobApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = CancelJobRequest(
                CancelJobRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    userJobId
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.cancelMyPostedJob(langTokenRequest)
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
                                utils.customToast(activity, response.message)
                                finish()
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

    private fun requestMediaApi() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = RequestMediaRequest(
                RequestMediaRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    requestMediaType,
                    jobId
                )
            )

            val getProfileCall: Call<CommonResponse?> =
                RetrofitClient.getClient.requestJobImageVideo(langTokenRequest)
            getProfileCall.enqueue(object : Callback<CommonResponse?> {
                override fun onResponse(
                    call: Call<CommonResponse?>,
                    response: Response<CommonResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val response = response.body()!!
                        when (response.status) {
                            "1" -> {
                                utils.customToast(activity, response.message)
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

    private fun sendJobExtraHrApi(dialog: BottomSheetDialog) {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val langTokenRequest = SendJobExtraHrRequest(
                SendJobExtraHrRequest.Data(
                    Const.langType,
                    pref.getString(Const.token).toString(),
                    userRelatedJobResponse.data.userJobDetailId,
                    startTime,
                    endTime
                )
            )

            val signUp: Call<CommonResponse?> =
                RetrofitClient.getClient.sendJobExtraHoursRequest(langTokenRequest)
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
                    .title("Your Location")
                    .icon(markerIcon)
            )
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

    }
}