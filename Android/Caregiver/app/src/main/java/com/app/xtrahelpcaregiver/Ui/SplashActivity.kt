package com.app.xtrahelpcaregiver.Ui

import android.Manifest
import android.content.DialogInterface
import  android.content.Intent
import android.content.pm.PackageManager
import android.location.Geocoder
import android.location.LocationManager
import android.os.Bundle
import android.os.Handler
import android.provider.Settings
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatDelegate
import androidx.core.app.ActivityCompat
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.GPSTracker
import com.app.xtrahelpcaregiver.Utils.Pref
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import okhttp3.MediaType
import okhttp3.MediaType.Companion.parse
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import org.json.JSONException
import org.json.JSONObject
import java.lang.Exception
import java.lang.StringBuilder
import java.util.*

class SplashActivity : BaseActivity() {
    val REQUEST_LOCATION = 10
    var locationManager: LocationManager? = null
    lateinit var latitude: String
    lateinit var longitude: String
    lateinit var deviceToken: String

    var tracker: GPSTracker? = null
    var address = ""
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)
        utils.fullScreenUIMode(activity)
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)

        val timeZone = TimeZone.getDefault()
        val timezone = timeZone.id
        pref.setString(Const.TIME_ZONE, timezone)
        Log.e("sLkdhnjksjdh", "onCreate: " + timezone)
        utils.setRetryClickListener(this)

    }

    override fun onResume() {
        super.onResume()
        tracker = GPSTracker(this)
        locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
        if (!locationManager!!.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
            OnGPS()
        } else {
            getLocation()
        }
    }

    private fun OnGPS() {
        MaterialAlertDialogBuilder(activity)
            .setMessage("Enable GPS")
            .setCancelable(false)
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int ->
                startActivity(
                    Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
                )
            }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }

    private fun getLocation() {
        if (ActivityCompat.checkSelfPermission(
                this, Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                this, Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), REQUEST_LOCATION
            )
        } else {
            if (tracker!!.canGetLocation()) {
                latitude = java.lang.String.valueOf(tracker!!.latitude)
                longitude = java.lang.String.valueOf(tracker!!.longitude)

                if (pref.getString(Const.latitude) == "0.0" || pref.getString(Const.latitude) == "") {
                    pref.setString(Const.latitude, latitude)
                    pref.setString(Const.longitude, longitude)
                }

                if (latitude.equals("0.0", ignoreCase = true)) {
                    CallApiForLatLong()
                } else {
                    val handler = Handler()
                    handler.postDelayed({
                        loginActivity()
                    }, 2000)
                }
                Log.e("lat", "initMapView: $latitude")
                Log.e("long", "initMapView: $longitude")
            } else {
                Toast.makeText(this, "Unable to find location.", Toast.LENGTH_SHORT).show()
            }
        }
    }

    fun CallApiForLatLong() {
        val jsonObject = JSONObject()
        val client = OkHttpClient()
//        val JSON: MediaType = parse.parse("application/json; charset=utf-8")
        val JSON: MediaType? = "application/json; charset=utf-8".toMediaTypeOrNull()
        val body = RequestBody.create(JSON, jsonObject.toString())
        val request: Request = Request.Builder()
            .url(Const.LocationNotAllowThenGetLatLng)
            .post(body)
            .build()
        val thread = Thread {
            try {
                val resStr = client.newCall(request).execute().body!!.string()
                Log.e("SFdsfsdfsdf", "" + resStr)
                val jsonObject1 = JSONObject(resStr)
                val jsonObject2 = jsonObject1.getJSONObject("location")
                runOnUiThread {
                    try {
                        latitude = jsonObject2.getString("lat")
                        longitude = jsonObject2.getString("lng")
                        pref.setString(Const.latitude, latitude)
                        pref.setString(Const.longitude, longitude)

                        Log.e("SFdsfsdfsdf", "Lat$latitude")
                        Log.e("SFdsfsdfsdf", "Lng$longitude")

                        getCompleteAddressString(latitude.toDouble(), longitude.toDouble())

                        val handler = Handler()
                        handler.postDelayed({
                            loginActivity()
                        }, 1000)

                    } catch (e: JSONException) {
                        e.printStackTrace()
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                Log.e("SFdsfsdfsdf", "" + e.toString())
            }
        }
        thread.start()
    }

    private fun getCompleteAddressString(LATITUDE: Double, LONGITUDE: Double): String? {
        val geocoder = Geocoder(this, Locale.getDefault())
        try {
            val addresses = geocoder.getFromLocation(LATITUDE, LONGITUDE, 1)
            if (addresses != null) {
                address = addresses[0].getAddressLine(1)
                val returnedAddress = addresses[0]
                val apartment = returnedAddress.subLocality
                val city = returnedAddress.locality
                val state = returnedAddress.adminArea
                val zipCode = returnedAddress.postalCode
                val strReturnedAddress = StringBuilder()
                for (i in 0..returnedAddress.maxAddressLineIndex) {
                    strReturnedAddress.append(returnedAddress.getAddressLine(i)).append(",")
                }
                address = strReturnedAddress.toString()

                val lat = returnedAddress.latitude.toString()
                val lon = returnedAddress.longitude.toString()
                latitude = lat
                longitude = lon

                pref.setString(Const.location, address)
                Log.e("TAG", "getCompleteAddressString: $lat\n$lon")
                Log.e("MyCurrentLocation", "" + strReturnedAddress.toString())
                Log.e(
                    "Appart",
                    "$address\n Apart $apartment\n City $city\n State $state\n zipCode $zipCode"
                )
            } else {
                Log.e("MyCurrentLocation", "No Address returned!")
            }
        } catch (e: Exception) {
            e.printStackTrace()
            Log.e("MyCurrentLocation", "Can't get Address!")
        }
        return address
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String?>,
        grantResults: IntArray
    ) {
        when (requestCode) {
            REQUEST_LOCATION -> if (permissions.size > 0) {
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    getLocation()
                } else {
                    CallApiForLatLong()
                    // Permission Denied
                }
            }
            else -> super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

}