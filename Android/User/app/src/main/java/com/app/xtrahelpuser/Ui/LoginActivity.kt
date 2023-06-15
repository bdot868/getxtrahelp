package com.app.xtrahelpuser.Ui

import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.Environment
import android.provider.Settings
import android.text.TextUtils
import android.text.method.PasswordTransformationMethod
import android.util.Base64
import android.util.Log
import android.view.View
import android.widget.Toast
import com.app.xtrahelpcaregiver.Request.LoginData
import com.app.xtrahelpcaregiver.Request.LoginRequest
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Response.MediaUploadResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.SocialLoginRequest
import com.app.xtrahelpuser.Utils.JsonUtils
import com.app.xtrahelpuser.linkedInManager.LinkedInRequestManager
import com.app.xtrahelpuser.linkedInManager.dto.LinkedInAccessToken
import com.app.xtrahelpuser.linkedInManager.dto.LinkedInEmailAddress
import com.app.xtrahelpuser.linkedInManager.dto.LinkedInUserProfile
import com.app.xtrahelpuser.linkedInManager.events.LinkedInManagerResponse
import com.downloader.*
import com.facebook.*
import com.facebook.login.LoginManager
import com.facebook.login.LoginResult
import com.facebook.login.widget.LoginButton
import com.google.android.gms.auth.api.Auth
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.api.GoogleApiClient
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.messaging.FirebaseMessaging
import com.google.gson.Gson
import com.twitter.sdk.android.core.Result
import com.twitter.sdk.android.core.TwitterCore
import com.twitter.sdk.android.core.TwitterException
import com.twitter.sdk.android.core.TwitterSession
import com.twitter.sdk.android.core.identity.TwitterAuthClient
import com.twitter.sdk.android.core.identity.TwitterLoginButton
import com.twitter.sdk.android.core.models.User
import kotlinx.android.synthetic.main.activity_login.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File
import java.lang.Exception
import java.net.MalformedURLException
import java.net.URL
import java.security.MessageDigest

class LoginActivity : BaseActivity(), LinkedInManagerResponse {
    // Google login
    private var mGoogleSignInClient: GoogleSignInClient? = null
    private var mGoogleApiClient: GoogleApiClient? = null
    private val REQUEST_GOOGLE_SIGN_IN = 11
    private val LINKEDIN_REQUEST_CODE = 2222

    // Facebook
    var loginButton: LoginButton? = null
    var callbackManager: CallbackManager? = null

    // Twitter login
    private var twitterLoginButton: TwitterLoginButton? = null
    private var client: TwitterAuthClient? = null

    var deviceToken: String? = null

    var email = ""
    var id: String? = ""
    var name: String? = ""
    var gender: String? = ""
    var birthday: String? = ""
    var authID: String? = ""

    var imageProfileUrl: String? = ""
    var profile_pic: URL? = null

    var loginResponse: LoginResponse? = null

        private var linkedInRequestManager: LinkedInRequestManager? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)
        init();
    }

    private fun init() {
        checkbox.setOnClickListener(this);
        txtSignup.setOnClickListener(this);
        txtForgetPassword.setOnClickListener(this);
        txtLogin.setOnClickListener(this);
        facebookImg.setOnClickListener(this);
        googleImg.setOnClickListener(this);
        linkedInImg.setOnClickListener(this);
        twitterImg.setOnClickListener(this);

        //Twitter login
        client = TwitterAuthClient()
        twitterLoginButton = findViewById(R.id.default_twitter_login_button)

        try {
            val info = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
            for (signature in info.signatures) {
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                Log.e("KeyHashQSSUSER:", Base64.encodeToString(md.digest(), Base64.DEFAULT))
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        deviceToken = pref.getString(Const.deviceToken)
        Log.e("FCMToken", "onComplete: $deviceToken")

        if (deviceToken!!.isEmpty()) {
            FirebaseMessaging.getInstance().token
                .addOnCompleteListener(OnCompleteListener<String?> { task ->
                    if (!task.isSuccessful) {
                        Log.w("shdg", "Fetching FCM registration token failed", task.exception)
                        return@OnCompleteListener
                    }
                    deviceToken = task.result
                    Log.e("FCMToken", "onComplete: $deviceToken")
                    pref.setString(Const.deviceToken, deviceToken)
                })
        }
        Initialization();
        etEmail.setOnFocusChangeListener { _, hasFocus ->
            if (etEmail.text.toString() != "") {
                emailImg.setImageResource(R.drawable.email_select);
            } else {
                if (hasFocus) {
                    emailImg.setImageResource(R.drawable.email_select);
                } else {
                    emailImg.setImageResource(R.drawable.email_unselect);
                }
            }
        }

        etPassword.setOnFocusChangeListener { _, hasFocus ->
            if (etPassword.text.toString() != "") {
                passwordImg.setImageResource(R.drawable.password_select);
            } else {
                if (hasFocus) {
                    passwordImg.setImageResource(R.drawable.password_select);
                } else {
                    passwordImg.setImageResource(R.drawable.password_unselect);
                }
            }
        }

        initObjects()
        //Twitter login
    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.checkbox -> if (!checkbox.isChecked) etPassword.transformationMethod =
                PasswordTransformationMethod()
            else etPassword.transformationMethod = null

            R.id.txtSignup -> startActivity(Intent(activity, SignupActivity::class.java))
            R.id.txtLogin -> if (isValid()) {
                loginAPITaskCall()
            }
            R.id.txtForgetPassword -> startActivity(
                Intent(activity, ForgotPasswordActivity::class.java)
            )

            R.id.googleImg -> {
                signInWithGoogle();
            }

            R.id.facebookImg -> {
                loginButton!!.performClick()
            }

            R.id.twitterImg -> {
                customLoginTwitter()
            }

            R.id.linkedInImg -> {
//                LinkedInBuilder.getInstance(this)
//                    .setClientID(resources.getString(R.string.linkedinClientId))
//                    .setClientSecret(resources.getString(R.string.linkedinClientSecret))
//                    .setRedirectURI(resources.getString(R.string.linkedinClientSCallBackUrl))
//                    .authenticate(LINKEDIN_REQUEST_CODE);

                linkedInRequestManager!!.showAuthenticateView(LinkedInRequestManager.MODE_BOTH_OPTIONS)
            }
        }
    }


    private fun loginAPITaskCall() {
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity)
            val loginRequest = LoginRequest(
                LoginData(
                    Const.langType,
                    etEmail.text.toString().trim(),
                    etPassword.text.toString().trim(),
                    Const.userRole,
                    pref.getString(Const.TIME_ZONE)!!,
                    Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID),
                    Const.deviceType,
                    pref.getString(Const.deviceToken).toString()
                )
            )

            val signUp: Call<LoginResponse?> = RetrofitClient.getClient.login(loginRequest)
            signUp.enqueue(object : Callback<LoginResponse?> {
                override fun onResponse(
                    call: Call<LoginResponse?>, response: Response<LoginResponse?>
                ) {
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: LoginResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
//                                utils.showCustomToast(loginResponse.message)
                                pref.setString(Const.userData, Gson().toJson(response.body()))
                                pref.setString(Const.token, loginResponse.data.token)
                                pref.setString(Const.id, loginResponse.data.id)
                                pref.setString(
                                    Const.profileStatus,
                                    loginResponse.data.profileStatus
                                )
                                loginActivity()
//                                checkTokenAndNavigateUser()
                            }
                            "3" -> {
                                startActivity(
                                    Intent(
                                        activity,
                                        OTPActivity::class.java
                                    ).putExtra(
                                        OTPActivity.EXTRA_EMAIL,
                                        etEmail.text.toString().trim()
                                    ).putExtra(OTPActivity.EXTRA_FLAG, false)
                                )
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
        var message: String
        message = ""
        if (etEmail.text.toString().isEmpty()) {
            message = getString(R.string.enterEmail)
            etEmail.requestFocus()
        } else if (!utils.isValidEmail(etEmail.text.toString())) {
            message = getString(R.string.enterValidEmail)
            etEmail.requestFocus()
        } else if (etPassword.text.toString().isEmpty()) {
            message = getString(R.string.enterPassword)
            etPassword.requestFocus()
        } else if (etPassword.text.length < 8 || etPassword.text.toString().length > 15) {
            message = resources.getString(R.string.password_length)
            etPassword.requestFocus()
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }

    private fun initObjects() {
        //Client ID and Client Secret is in the LinkedIn Developer Console
        //provide Redirection URL in this format <https://www.example.com>. This URL is also available in LinkedIn Developer Console
        linkedInRequestManager = LinkedInRequestManager(
            this@LoginActivity,
            this,
            Const.clientID,
            Const.clientSecret,
            Const.redirectionURL
        )
    }


    private fun Initialization() {
        loginButton = findViewById<View>(R.id.login_button) as LoginButton
        LoginManager.getInstance().logOut()
        loginButton!!.setReadPermissions();

        callbackManager = CallbackManager.Factory.create()

        LoginManager.getInstance().registerCallback(callbackManager,
            object : FacebookCallback<LoginResult?> {
                override fun onSuccess(loginResult: LoginResult?) {
                    Toast.makeText(activity, "successss", Toast.LENGTH_SHORT).show()
                }

                override fun onCancel() {
                    // App code
                }

                override fun onError(exception: FacebookException) {
                    // App code
                }
            })

        PRDownloader.initialize(applicationContext)
        val config: PRDownloaderConfig = PRDownloaderConfig.newBuilder()
            .setDatabaseEnabled(true)
            .build()
        PRDownloader.initialize(applicationContext, config)

        // Setting timeout globally for the download network requests:
        val config1: PRDownloaderConfig = PRDownloaderConfig.newBuilder()
            .setReadTimeout(30000)
            .setConnectTimeout(30000)
            .build()
        PRDownloader.initialize(this, config1)
        try {
            val info = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
            for (signature in info.signatures) {
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                Log.e("KeyHashQSSUSER:", Base64.encodeToString(md.digest(), Base64.DEFAULT))
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        //Google login
        val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestIdToken(resources.getString(R.string.server_client_id))
            .requestProfile()
            .requestId()
            .requestEmail()
            .build()
        mGoogleApiClient = GoogleApiClient.Builder(this)
            .enableAutoManage(
                this
            ) { }
            .addApi(Auth.GOOGLE_SIGN_IN_API, gso)
            .build()
        mGoogleSignInClient = GoogleSignIn.getClient(this, gso)
//        mGoogleSignInClient.signOut()

        //facebook login
        loginButton!!.registerCallback(callbackManager, object : FacebookCallback<LoginResult> {
            override fun onSuccess(loginResult: LoginResult) {
                println("onSuccess")
                val accessToken = loginResult.accessToken
                    .token
                Log.i("accessToken", accessToken)
                val request = GraphRequest.newMeRequest(
                    loginResult.accessToken
                ) { `object`: JSONObject, response: GraphResponse ->
                    Log.e(
                        "LoginActivity",
                        response.toString()
                    )
                    try {
                        id = `object`.getString("id")
                        try {
                            profile_pic = URL(
                                "http://graph.facebook.com/$id/picture?type=large"
                            )
                            Log.i("profile_pic", profile_pic.toString() + "")
                        } catch (e: MalformedURLException) {
                            e.printStackTrace()
                        }
                        try {
                            name = `object`.getString("name")
                        } catch (e: JSONException) {
                            e.printStackTrace()
                        }
                        try {
                            email = `object`.getString("email")
                        } catch (e: JSONException) {
                            email = ""
                            e.printStackTrace()
                        }
                        try {
                            gender = `object`.getString("gender")
                        } catch (e: JSONException) {
                            e.printStackTrace()
                        }
                        try {
                            birthday = `object`.getString("birthday")
                        } catch (e: JSONException) {
                            e.printStackTrace()
                        }
                        pref.setString(Const.socialName, name)
                        pref.setString(Const.socialEmail, email)
                        pref.setString(Const.socialId, id)
                        pref.setString(Const.socialAuthProvider, "facebook")

                        if (profile_pic == null) {
                            var firstName: String? = ""
                            var lastName = ""
                            if (name!!.contains(" ")) {
                                val names: Array<String> = name?.split(" ")!!.toTypedArray()
                                firstName = names[0]
                                lastName = names[1]
                            } else {
                                firstName = name
                            }
                            socialLoginAPI(
                                email,
                                firstName,
                                lastName,
                                "",
                                id.toString(),
                                "facebook"
                            )
                        } else {
                            faceBookImageDownload()
                        }
                    } catch (e: JSONException) {
                        e.printStackTrace()
                    }
                }
                val parameters = Bundle()
                parameters.putString("fields", "id,name,email,gender, birthday")
                request.parameters = parameters
                request.executeAsync()
            }

            override fun onCancel() {
                println("onCancel")
            }

            override fun onError(exception: FacebookException) {
                println("onError" + exception.message)
                Log.e("LoginActivityError", exception.toString())
            }
        })
    }

    private fun socialLoginAPI(
        email: String,
        firstName: String?,
        lastName: String,
        imageName: String,
        authId: String,
        authProvider: String
    ) {
        pref.setString(Const.authId, authId)
        if (utils.isNetworkAvailable()) {
            utils.showProgress(activity);
//            utils.showProgress(activity)
            val loginRequest = SocialLoginRequest(
                SocialLoginRequest.Data(
                    Const.langType,
                    authId,
                    authProvider,
                    pref.getString(Const.deviceToken).toString(),
                    "",
                    Const.deviceType,
                    Settings.Secure.getString(this.contentResolver, Settings.Secure.ANDROID_ID),
                    pref.getString(Const.TIME_ZONE).toString(),
                    Const.userRole,
                    email,
                    if (email.isEmpty()) "1" else "0",
                    firstName + " " + lastName
                )
            )

            val signUp: Call<LoginResponse?> = RetrofitClient.getClient.socialLogin(loginRequest)
            signUp.enqueue(object : Callback<LoginResponse?> {
                override fun onResponse(
                    call: Call<LoginResponse?>, response: Response<LoginResponse?>
                ) {
//                    utils.dismissProgress()
                    utils.dismissProgress()
                    if (response.isSuccessful) {
                        val loginResponse: LoginResponse = response.body()!!
                        when (loginResponse.status) {
                            "1" -> {
//                                utils.showCustomToast(loginResponse.message)
                                pref.setString(Const.userData, Gson().toJson(response.body()))
                                pref.setString(Const.token, loginResponse.data.token)
                                pref.setString(Const.id, loginResponse.data.id)
                                pref.setString(
                                    Const.profileStatus,
                                    loginResponse.data.profileStatus
                                )
                                loginActivity()
//                                checkTokenAndNavigateUser()
                            }
                            "3" -> {
                                startActivity(
                                    Intent(
                                        activity,
                                        OTPActivity::class.java
                                    ).putExtra(
                                        OTPActivity.EXTRA_EMAIL,
                                        etEmail.text.toString().trim()
                                    ).putExtra(OTPActivity.EXTRA_FLAG, false)
                                )
                            }
                            "4" -> {
                                startActivity(Intent(activity, EmailActivity::class.java))
                            }
                            else -> {
                                checkStatus(relative, loginResponse.status, loginResponse.message)
                            }
                        }
                    }
                }

                override fun onFailure(call: Call<LoginResponse?>, t: Throwable) {
//                    utils.dismissProgress()
                    utils.dismissProgress()
                    utils.showCustomToast(resources.getString(R.string.server_not_responding))
                }

            })

        } else {
//            utils.showAlert(getString(R.string.noInternet))
        }
    }

    fun faceBookImageDownload() {
        val fname = "XtraHelp/App"
        val myfolder = Environment.getExternalStorageDirectory().toString() + "/" + fname
        val file = File(myfolder)
        if (!file.exists()) {
            file.mkdirs()
        }
        val downloadId = PRDownloader.download(
            profile_pic.toString() + "",
            file.absolutePath,
            "facebookProfileXtraHelp.jpg"
        )
            .build()
            .setOnStartOrResumeListener {}
            .setOnPauseListener {}
            .setOnCancelListener {}
            .setOnProgressListener { progress: Progress? -> }
            .start(object : OnDownloadListener {
                override fun onDownloadComplete() {
                    Log.e("TAG", "onDownloadComplete: " + "TAG")
                    fileImage = File(File("$file/facebookProfileXtraHelp.jpg").toString())
                    uploadMedia()
                }

                override fun onError(error: Error) {
                    var firstName = ""
                    var lastName = ""
                    name = pref.getString(Const.socialName)

                    if (!TextUtils.isEmpty(name)) {
                        val names = name!!.split(" ").toTypedArray()
                        firstName = names[0]
                        lastName = names[1]
                    }
                    email = pref.getString(Const.socialEmail).toString()

                    id = pref.getString(Const.socialId).toString()
                    val authProvider: String = pref.getString(Const.socialAuthProvider).toString()

                    socialLoginAPI(email, firstName, lastName, "", id.toString(), authProvider)
                }
            })
    }

    fun uploadMedia() {
        if (fileImage != null) {
            val requestBody = RequestBody.create("*/*".toMediaTypeOrNull(), fileImage!!)
            Log.e("file name", "uploadMedia: $fileImage")
            val body: MultipartBody.Part =
                MultipartBody.Part.createFormData("files", fileImage!!.name, requestBody)
            val langType = RequestBody.create("text/plain".toMediaTypeOrNull(), "1")
            try {
//                utils.showProgress(activity)
                utils.showProgress(activity)
                val call: Call<MediaUploadResponse?>? =
                    RetrofitClient.getClient.mediaUpload(langType, body)
                call?.enqueue(object : Callback<MediaUploadResponse?> {
                    override fun onResponse(
                        call: Call<MediaUploadResponse?>,
                        response: Response<MediaUploadResponse?>
                    ) {
//                        utils.dismissProgress()
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

                                    pref.setString(Const.socialImage, imageName)
                                    var firstName = ""
                                    var lastName = ""
                                    name = pref.getString(Const.socialName)
                                    if (!TextUtils.isEmpty(name)) {
                                        val names = name!!.split(" ").toTypedArray()
                                        firstName = names[0]
                                        lastName = names[1]
                                    }
                                    email = pref.getString(Const.socialEmail).toString()

                                    id = pref.getString(Const.socialId)
                                    val authProvider: String =
                                        pref.getString(Const.socialAuthProvider).toString()

                                    socialLoginAPI(
                                        email,
                                        firstName,
                                        lastName,
                                        imageName,
                                        id.toString(),
                                        authProvider
                                    )

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
//                        utils.dismissProgress()
                        utils.dismissProgress()
                        utils.showCustomToast(resources.getString(R.string.server_not_responding))
                    }
                })
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    //Google Login
    private fun signInWithGoogle() {
        utils.showProgress(activity)
        val signInIntent = Auth.GoogleSignInApi.getSignInIntent(mGoogleApiClient)
        startActivityForResult(signInIntent, REQUEST_GOOGLE_SIGN_IN)
    }


    //Twitter
    fun customLoginTwitter() {
        authID = "twitter"
        //check if user is already authenticated or not
        if (getTwitterSession() == null) {

            //if user is not authenticated start authenticating
            client!!.authorize(
                this,
                object : com.twitter.sdk.android.core.Callback<TwitterSession>() {
                    override fun success(result: Result<TwitterSession>) {

                        // Do something with result, which provides a TwitterSession for making API calls
                        val twitterSession = result.data

                        //call fetch email only when permission is granted
                        fetchTwitterImage()
                        //                    fetchTwitterEmail(twitterSession);
                    }

                    override fun failure(e: TwitterException) {
                        // Do something on failure
                        utils.showCustomToast("Failed to authenticate. Please try again.")
                    }
                })
        } else {
            //if user is already authenticated direct call fetch twitter email api
            fetchTwitterImage()
            //            fetchTwitterEmail(getTwitterSession());
        }
    }

    fun fetchTwitterImage() {
        //check if user is already authenticated or not
        if (getTwitterSession() != null) {

            //fetch twitter image with other information if user is already authenticated

            //initialize twitter api client
            val twitterApiClient = TwitterCore.getInstance().apiClient

            //Link for Help : https://developer.twitter.com/en/docs/accounts-and-users/manage-account-settings/api-reference/get-account-verify_credentials

            //pass includeEmail : true if you want to fetch Email as well
            val call = twitterApiClient.accountService.verifyCredentials(true, false, true)
            call.enqueue(object : com.twitter.sdk.android.core.Callback<User>() {
                override fun success(result: Result<User>) {
                    val user = result.data
                    Log.e(
                        "twitterdata", """
     success: User Id : ${user.id}
     User Name : ${user.name}
     Email Id : ${user.email}
     Screen Name : ${user.screenName}
     """.trimIndent()
                    )
                    imageProfileUrl = user.profileImageUrl
                    id = user.id.toString()
                    Log.d("Email---->", "id----->" + user.email)
                    email = user.email
                    name = user.name
                    Log.e("profileImageUrl", "Data : $imageProfileUrl")
                    //NOTE : User profile provided by twitter is very small in size i.e 48*48
                    //Link : https://developer.twitter.com/en/docs/accounts-and-users/user-profile-images-and-banners
                    //so if you want to get bigger size image then do the following:
                    imageProfileUrl = imageProfileUrl!!.replace("_normal", "")

                    Log.e("profileimage", "success: $imageProfileUrl")
                    ///load image using Picasso
                    pref.setString(Const.socialName, name)
                    pref.setString(Const.socialEmail, email)
                    pref.setString(Const.socialId, id)
                    pref.setString(Const.socialAuthProvider, "twitter")

                    if (imageProfileUrl.equals("", ignoreCase = true)) {
                        var firstName: String? = ""
                        var lastName = ""
                        if (name == "") {
                            val names = name!!.split(" ").toTypedArray()
                            firstName = names[0]
                            try {
                                lastName = names[1]
                            } catch (e: Exception) {
                                e.printStackTrace()
                            }
                        } else {
                            firstName = name
                        }
                        socialLoginAPI(email, firstName, lastName, "", id!!, "twitter")
                    } else {
                        twitterImageDownload(imageProfileUrl!!)
                    }
                }

                override fun failure(exception: TwitterException) {
                    utils.showCustomToast("Failed to authenticate. Please try again.")
                }
            })
        } else {
            //if user is not authenticated first ask user to do authentication
            utils.showCustomToast("First to Twitter auth to Verify Credentials.")
        }
    }

    private fun getTwitterSession(): TwitterSession? {

        //NOTE : if you want to get token and secret too use uncomment the below code
        /*TwitterAuthToken authToken = session.getAuthToken();
        String token = authToken.token;
        String secret = authToken.secret;*/return TwitterCore.getInstance().sessionManager.activeSession
    }

    fun twitterImageDownload(image: String) {

        /*String fname = "MyFolder/Images";
        String myfolder = Environment.getExternalStorageDirectory() + "/" + fname;
        final File file = new File(myfolder);

        if (!file.exists()) {
            file.mkdirs();
        }*/


        // final String path = Environment.getExternalStorageDirectory().toString() + "/" + getResources().getString(R.string.app_name);
        // int downloadId = PRDownloader.download(image + "", file.getAbsolutePath(), "twitterProfileVicinity.jpg")
        val downloadId = PRDownloader.download(
            image + "",
            externalCacheDir!!.absolutePath,
            "twitterProfileVicinity.jpg"
        )
            .build()
            .setOnStartOrResumeListener {}
            .setOnPauseListener {}
            .setOnCancelListener {}
            .setOnProgressListener { progress: Progress? -> }
            .start(object : OnDownloadListener {
                override fun onDownloadComplete() {
                    Log.e("TAG", "onDownloadComplete: " + "TAG")
                    //fileImage = new File(String.valueOf(new File(file + "/twitterProfileVicinity.jpg")));
                    fileImage =
                        File(File(externalCacheDir!!.absolutePath.toString() + "/twitterProfileVicinity.jpg").toString())
                    uploadMedia()
                }

                override fun onError(error: Error) {
                    var firstName = ""
                    var lastName = ""
                    name = pref.getString(Const.socialName)
                    if (!TextUtils.isEmpty(name)) {
                        val names = name!!.split(" ").toTypedArray()
                        firstName = names[0]
                        try {
                            lastName = names[1]
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                    name = pref.getString(Const.socialName)
                    id = pref.getString(Const.socialId)
                    val authProvider: String = pref.getString(Const.socialAuthProvider).toString()
                    socialLoginAPI(email, firstName, lastName, "", id!!, authProvider)
                    Log.e("TAGerror", "onDownloadComplete: " + " TAG ")
                }
            })
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        callbackManager!!.onActivityResult(requestCode, resultCode, data)
        if (client != null) client!!.onActivityResult(requestCode, resultCode, data)

        // Pass the activity result to the login button.
        twitterLoginButton!!.onActivityResult(requestCode, resultCode, data)

        if (requestCode == REQUEST_GOOGLE_SIGN_IN) {
            // Result returned from launching the Intent from GoogleSignInApi.getSignInIntent(...);
            val result = Auth.GoogleSignInApi.getSignInResultFromIntent(data)
            if (result!!.isSuccess) {
                // Signed in successfully, show authenticated UI.
                val acct = result.signInAccount
                handleSignInResult(acct!!)
            } else {
//                utils.dismissProgress()
//                utils.dismissProgress()
                utils.dismissProgress()
                Log.e("googleSign", "onActivityResult: ")
            }
        }
        //LinkedIn Login jo biji activity ma jai login karvu hoy to library uncomment kari code uncomment karvo
//        if (requestCode == LINKEDIN_REQUEST_CODE) {
//            if (resultCode == RESULT_OK) {
//                //Successfully signed in
//                val user: LinkedInUser = data?.getParcelableExtra("social_login")!!
//
//                //acessing user info
//                Log.e("LinkedInLogin", user.firstName)
//            } else {
//                if (data != null) {
//                    if (data!!.getIntExtra("err_code", 0) == LinkedInBuilder.ERROR_USER_DENIED) {
//                        //Handle : user denied access to account
//                    } else if (data.getIntExtra("err_code", 0) == LinkedInBuilder.ERROR_FAILED) {
//
//                        //Handle : Error in API : see logcat output for details
//                        Log.e("LINKEDIN ERROR", data.getStringExtra("err_message")!!)
//                    }
//                }
//            }
//        }

        if (requestCode == RESULT_CANCELED) {
            return
        }

        if (requestCode == 123) {
        }
    }

    private fun handleSignInResult(account: GoogleSignInAccount) {
//        Utils.dismissProgress()
//        utils.dismissProgress()
        utils.dismissProgress()
        try {
            id = account.id
            //deviceToken = account.getIdToken();
            name = account.displayName
            email = account.email!!
            if (account.photoUrl != null) {
                if (!TextUtils.isEmpty(account.photoUrl.toString())) {
                    imageProfileUrl = account.photoUrl.toString()
                }
            }
            pref.setString(Const.socialName, name)
            pref.setString(Const.socialEmail, email)
            pref.setString(Const.socialId, id)
            pref.setString(Const.socialAuthProvider, "google")

            if (imageProfileUrl.equals("", ignoreCase = true)) {
                var firstName: String? = ""
                var lastName = ""
                if (name!!.trim { it <= ' ' }.contains(" ")) {
                    val names = name!!.split(" ").toTypedArray()
                    firstName = names[0]
                    lastName = names[1]
                } else {
                    firstName = name
                }
                socialLoginAPI(email, firstName, lastName, "", id!!, "google")
            } else {
                googleImageDownload(imageProfileUrl.toString())
            }
            Log.e(
                "LoginGoogle", "Name: " + name + ", email: " + email
                        + ", Image: " + imageProfileUrl
            )
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun googleImageDownload(image: String) {
        val downloadId = PRDownloader.download(
            image + "",
            externalCacheDir!!.absolutePath,
            "googleProfileBlueCollar.jpg"
        )
            .build()
            .setOnStartOrResumeListener {}
            .setOnPauseListener {}
            .setOnCancelListener {}
            .setOnProgressListener { progress: Progress? -> }
            .start(object : OnDownloadListener {
                override fun onDownloadComplete() {
                    Log.e("TAG", "onDownloadComplete: " + "TAG")
                    fileImage =
                        File(File(externalCacheDir!!.absolutePath + "/googleProfileBlueCollar.jpg").toString())
                    uploadMedia()
                }

                override fun onError(error: Error) {
                    Log.e("uploadImages", "onError: $error")
                    var firstName = ""
                    var lastName = ""
                    name = pref.setString(Const.socialName, "").toString()

                    if (!TextUtils.isEmpty(name)) {
                        val names = name!!.split(" ").toTypedArray()
                        firstName = names[0]
                        lastName = names[1]
                    }
                    email = pref.setString(Const.socialEmail, "").toString()
                    id = pref.setString(Const.socialId, "").toString()
                    val authProvider: String =
                        pref.setString(Const.socialAuthProvider, "").toString()
                    socialLoginAPI(email, firstName, lastName, "", id!!, authProvider)
                }
            })
    }


    override fun onGetAccessTokenFailed() {
        Log.e("tokenFailed", "onGetAccessTokenFailed: ");
    }

    override fun onGetAccessTokenSuccess(linkedInAccessToken: LinkedInAccessToken?) {
        Log.e(
            "linkedInAccessToken",
            "onGetAccessTokenSuccess: " + JsonUtils.toJson(linkedInAccessToken)
        )
    }

    override fun onGetCodeFailed() {
        Log.e("linkCodeFailed", "onGetCodeFailed: ")
    }

    override fun onGetCodeSuccess(code: String?) {
        Log.e("code", "onGetCodeSuccess: $code")
    }

    override fun onGetProfileDataFailed() {
        Log.e("linkProfilefailed", "onGetProfileDataFailed: ")
    }

    override fun onGetProfileDataSuccess(linkedInUserProfile: LinkedInUserProfile?) {
        Log.e(
            "linkedInUserProfile",
            "onGetProfileDataSuccess: " + linkedInUserProfile!!.userName.firstName.localized.en_US
        )
        Log.e(
            "linkedInUserProfile",
            "onGetProfileDataSuccess: " + linkedInUserProfile.userName.lastName.localized.en_US
        )
        Log.e(
            "linkedInUserProfile",
            "onGetProfileDataSuccess: " + linkedInUserProfile.userName.id
        )
        Log.e("linkedInUserProfile", "onGetProfileDataSuccess: " + linkedInUserProfile.imageURL)
        pref.setString(
            Const.socialName,
            linkedInUserProfile.userName.firstName.localized.en_US.toString() + " " + linkedInUserProfile.userName.lastName.localized.en_US
        )

        pref.setString(Const.socialId, linkedInUserProfile.userName.id)

        id = linkedInUserProfile.userName.id
        pref.setString(Const.socialAuthProvider, "linkedin")

        linkedInRequestManager!!.dismissAuthenticateView()
        if (linkedInUserProfile.imageURL == "" || linkedInUserProfile.imageURL == "null" || linkedInUserProfile.imageURL == null) {
            socialLoginAPI(
                email,
                linkedInUserProfile.userName.firstName.localized.en_US,
                linkedInUserProfile.userName.lastName.localized.en_US,
                "",
                id.toString(),
                "linkedin"
            )
        } else {
            uploadFileLinkedIn(linkedInUserProfile.imageURL.toString() + "")
        }
    }

    override fun onGetEmailAddressFailed() {
        Log.e("LinkedinEmailFailed", "onGetEmailAddressFailed: ")
    }

    override fun onGetEmailAddressSuccess(linkedInEmailAddress: LinkedInEmailAddress?) {
        email = linkedInEmailAddress!!.emailAddress
        pref.setString(Const.socialEmail, linkedInEmailAddress.emailAddress)
        Log.e(
            "linkedInEmailAddress",
            "onGetEmailAddressSuccess: " + linkedInEmailAddress.emailAddress
        )
    }

    fun uploadFileLinkedIn(url: String) {

    }
}