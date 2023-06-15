package com.app.xtrahelpcaregiver.Utils

import android.app.Activity
import android.content.Context
import com.app.xtrahelpcaregiver.Adapter.AddressDataWithPlace
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.SelectedCategory
import com.google.android.material.snackbar.Snackbar
import java.util.ArrayList

object Const {

    const val userData = "userData"
    const val userRole = "3"
    const val isActiveCard = "0"
    const val langType = "1"
    var deviceToken = "deviceToken"
    var deviceType = "2"
    var token = ""
    var latitude = "latitude"
    var longitude = "longitude"
    var ZipCode = "zipCode"
    var location = "location"
    var notificationReadUnread = "notificationReadUnread"
    var profileStatus = "profileStatus"

    var limit = "20"
    var id = "id"
    var activeOffer = ""

    lateinit var  placeList: ArrayList<AddressDataWithPlace>
    var  selectedCategory: ArrayList<String> = ArrayList()

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

    var TIME_ZONE = "TIME_ZONE"


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
    var isStripeConnect = "isStripeConnect"
    var isBankDetail = "isBankDetail"

    fun getSharePref(context: Context) =
        context.getSharedPreferences(context.getString(R.string.app_name), Activity.MODE_PRIVATE)

    fun getToken(context: Context):String= getSharePref(context).getString(token, "").toString()
}