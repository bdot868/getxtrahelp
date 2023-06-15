package com.app.xtrahelpuser.Ui

import android.Manifest
import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.location.Address
import android.location.Geocoder
import android.location.LocationManager
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.AdapterView
import android.widget.Toast
import androidx.core.app.ActivityCompat
import com.app.xtrahelpcaregiver.Request.UpdateProfileStatus
import com.app.xtrahelpcaregiver.Request.UpdateProfileStatusRequest
import com.app.xtrahelpcaregiver.Response.LoginResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.app.xtrahelpuser.Adapter.AdpOfDestinationAddress
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Utils.GPSTracker
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.BitmapDescriptor
import com.google.android.gms.maps.model.BitmapDescriptorFactory
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import kotlinx.android.synthetic.main.activity_location_change.*
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import org.json.JSONException
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import java.io.IOException
import java.lang.Exception
import java.lang.StringBuilder
import java.util.*

class LocationChangeActivity : BaseActivity(), OnMapReadyCallback {
    var lat: String? = null
    var lon: String? = null
    var address: String? = null
    var apartment: String? = null
    var city: String? = null
    var state: String? = null
    var zipCode: String? = null

    var latitude: String? = null
    var longitude: String? = null
    var tracker: GPSTracker? = null

    var locationManager: LocationManager? = null
    private val REQUEST_LOCATION = 1
    var mMap: GoogleMap? = null
    var mapFragment: SupportMapFragment? = null

    var currentLat: String? = null
    var currentLong: String? = null
    var isCurrent: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_location_change)

        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtFinish.setOnClickListener(this)
        detectLocation.setOnClickListener(this)
        isCurrent = true

        mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment?
        mapFragment?.getMapAsync(this)
        tracker = GPSTracker(this)
        locationManager = getSystemService(LOCATION_SERVICE) as LocationManager

        if (!locationManager!!.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
            OnGPS()
        } else {
            getLocation()
        }

        etLocation.threshold = 2
        etLocation.setAdapter(
            AdpOfDestinationAddress(
                this,
                R.layout.autocomplete_list_item,
                android.R.id.text1
            )
        )
        etLocation.onItemClickListener =
            AdapterView.OnItemClickListener { parent: AdapterView<*>, view: View?, position: Int, id: Long ->
                try {
                    val description = parent.getItemAtPosition(position) as String
                    // Toast.makeText(getApplicationContext(), description, Toast.LENGTH_SHORT).show();
                    utils.showProgress(activity)
                    val `in` = getSystemService(INPUT_METHOD_SERVICE) as InputMethodManager
                    `in`.hideSoftInputFromWindow(currentFocus!!.applicationWindowToken, 0)
                    getLocationFromAddress(activity, description)
                    //    getCode(description);            0
                } catch (e: Exception) {
                    Log.e("master-->>", "master$e")
                }
            }

    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
            R.id.txtFinish -> {
                pref.setString(Const.latitude, latitude)
                pref.setString(Const.longitude, longitude)
                pref.setString(Const.location, address)
                onBackPressed()
            }

            R.id.detectLocation -> {
                val lat: Double? = currentLat?.toDouble()
                val lon = currentLong?.toDouble()

                if (lat != null && lon != null) {
                    getCompleteAddressString(lat, lon)
                }
                onMapReady(mMap)
            }

            R.id.linear -> {
                val lat: Double? = currentLat?.toDouble()
                val lon = currentLong?.toDouble()

                if (lat != null && lon != null) {
                    getCompleteAddressString(lat, lon)
                }
                onMapReady(mMap)
            }
        }
    }

    private fun getLocationFromAddress(context: Context?, strAddress: String?): LatLng? {
        val coder = Geocoder(context)
        val address: List<Address>?
        var p1: LatLng? = null
        utils.dismissProgress()
        try {
            // May throw an IOException
            address = coder.getFromLocationName(strAddress, 5)
            if (address == null) {
                return null
            }
            val location = address[0]
            try {
                getCompleteAddressString(location.latitude, location.longitude)
            } catch (e: Exception) {
            }

            latitude = location.latitude.toString()
            longitude = location.longitude.toString()
            if (isCurrent) {
                currentLat = location.latitude.toString()
                currentLong = location.longitude.toString()
                isCurrent = false
            }
            onMapReady(mMap)

        } catch (ex: IOException) {
            ex.printStackTrace()
        }
        return p1
    }

    private fun getCompleteAddressString(LATITUDE: Double, LONGITUDE: Double): String? {
        val geocoder = Geocoder(this, Locale.getDefault())
        try {
            val addresses = geocoder.getFromLocation(LATITUDE, LONGITUDE, 1)
            if (addresses != null) {
                address = addresses[0].getAddressLine(1)
                val returnedAddress = addresses[0]
                apartment = returnedAddress.subLocality
                city = returnedAddress.locality
                state = returnedAddress.adminArea
                zipCode = returnedAddress.postalCode
                val strReturnedAddress = StringBuilder()
                for (i in 0..returnedAddress.maxAddressLineIndex) {
                    strReturnedAddress.append(returnedAddress.getAddressLine(i)).append(",")
                }
                address = strReturnedAddress.toString()
                etLocation.setText(address)

                val lat = returnedAddress.latitude.toString()
                val lon = returnedAddress.longitude.toString()
                latitude = lat
                longitude = lon

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

    private fun OnGPS() {
        val builder = AlertDialog.Builder(this)
        builder.setMessage("Enable GPS").setCancelable(false).setPositiveButton(
            "Yes"
        ) { dialog, which -> startActivity(Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)) }
            .setNegativeButton(
                "No"
            ) { dialog, which -> dialog.cancel() }
        val alertDialog = builder.create()
        alertDialog.show()
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
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                REQUEST_LOCATION
            )
        } else {
            if (tracker!!.canGetLocation()) {
                latitude = java.lang.String.valueOf(tracker!!.latitude)
                longitude = java.lang.String.valueOf(tracker!!.longitude)
                lat = latitude
                lon = longitude
                if (lat.equals("0.0", ignoreCase = true)) {
                    CallApiForLatLong()
                }
                Log.e("lat", "initMapView: $lat")
                Log.e("long", "initMapView: $lon")
            } else {
                Toast.makeText(this, "Unable to find location.", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun CallApiForLatLong() {
        val jsonObject = JSONObject()
        val client = OkHttpClient()
        val JSON: MediaType? = "application/json; charset=utf-8".toMediaTypeOrNull()
        val body = RequestBody.create(JSON, jsonObject.toString())
        val request: Request = Request.Builder()
            .url(Const.LocationNotAllowThenGetLatLng)
            .post(body)
            .build()
        val response: Response? = null
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
                        lat = latitude
                        lon = longitude
                        Log.e(
                            "SFdsfsdfsdf",
                            "jsonObject1.getString(\"latitude\")$lat"
                        )
                        Log.e("SFdsfsdfsdf", "asd$lon")
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

    override fun onMapReady(googleMap: GoogleMap?) {
        mMap = googleMap

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
        getCompleteAddressString(latitude!!.toDouble(), longitude!!.toDouble())
        mMap!!.setOnMapClickListener { arg0: LatLng ->
            mMap!!.clear()
            mMap!!.addMarker(
                MarkerOptions()
                    .position(LatLng(arg0.latitude, arg0.longitude))
                    .title("Your Location")
                    .icon(markerIcon)
            )
            getCompleteAddressString(arg0.latitude, arg0.longitude)
            Log.e("onMapClick", "Horray!" + arg0.latitude)
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
}