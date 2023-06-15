package com.app.xtrahelpcaregiver.Utils

import android.app.Activity
import android.content.Context
import com.app.xtrahelpuser.Adapter.AddressDataWithPlace
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.SaveUserJobRequest
import com.google.android.material.snackbar.Snackbar
import com.google.gson.Gson
import java.util.ArrayList

object Const {
    const val userData = "userData"
    const val userRole = "2"
    const val isActiveCard = "0"
    const val langType = "1"
    const val profileStatus = "profileStatus"
    var deviceToken = "deviceToken"
    var deviceType = "2"
    var token = ""
    var ZipCode = "zipCode"
    var location = "location"
    var loc = "loc"
    var latitude = "latitude"
    var longitude = "longitude"
    var notificationReadUnread = "notificationReadUnread"
    var TIME_ZONE = "timeZone"

    var limit = "20"
    var id = "id"
    var activeOffer = ""

    lateinit var placeList: ArrayList<AddressDataWithPlace>

    const val GOOGLE_MAP_API_KEY_FOR_PLACE =
        "AIzaSyAOXcITbfxO2EV_HSJ_gImF1Lp3KFE17lM"; //live place api
    var LocationNotAllowThenGetLatLng =
        "https://www.googleapis.com/geolocation/v1/geolocate?key=$GOOGLE_MAP_API_KEY_FOR_PLACE"

    val clientID: String = "78ab6vx75k4ahc"
    val clientSecret: String = "S3oUxR65dqXCEKPW"
    val redirectionURL: String = "https://xtrahelp.com"

    const val profileUpdate = "profileUpdate"
    const val OFFER_ACTIVATED = "OFFER_ACTIVATED"
    const val OFFER_REDEEMED = "OFFER_REDEEMED"
    const val OFFER_FULLREDEEMED = "OFFER_FULLREDEEMED"

    // SnackBar type
    var success = "1"
    var error = "2"
    var alert = "3"
    var noInternet = "4"
    var noInternetDuration = Snackbar.LENGTH_LONG
    var successDuration = Snackbar.LENGTH_SHORT

    var registration = "registration"
    var hookMethod = "hookMethod"
    var token_pass = "token"
    var userSupportTicketReply = "userSupportTicketReply"
    var userSupportTicketMessageList = "userSupportTicketMessageList"

    const val chatinbox = "chatinbox"
    var chatmessagelist = "chatmessagelist"
    var usermessagelist = "usermessagelist"
    var message = "message"
    var removechatmessagelist = "removechatmessagelist"


    //social
    var socialName = "socialName"
    var socialEmail = "socialEmail"
    var socialId = "socialId"
    var socialAuthProvider = "socialAuthProvider"
    var socialImage = "socialImage"
    var firebaseToken = "firebaseToken"
    var socialFName = "socialFName"
    var socialLName = "socialLName"
    var authId = "socialLName"

    fun getSharePref(context: Context) =
        context.getSharedPreferences(context.getString(R.string.app_name), Activity.MODE_PRIVATE)

    fun editor(context: Context) = getSharePref(context).edit()

    fun getToken(context: Context): String = getSharePref(context).getString(token, "").toString()
//    fun getUser(context: Context): User = Gson().fromJson(getSharePref(context).getString(USER, "").toString(), User::class.java)

}