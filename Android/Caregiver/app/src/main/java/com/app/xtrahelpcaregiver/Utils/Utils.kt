package com.app.xtrahelpcaregiver.Utils

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkInfo
import android.net.Uri
import android.os.Build
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.view.inputmethod.InputMethodManager
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.app.xtrahelpcaregiver.Interface.SnackRetryInterface
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Ui.LoginActivity
import com.google.android.material.snackbar.Snackbar
import com.google.android.material.snackbar.Snackbar.SnackbarLayout
import java.util.regex.Pattern

class Utils(val context: Context) {
    var custDailog: CustomProgress? = null

    //hide keyboard
    fun hideKeyBoardFromView(context: Context) {
        val inputMethodManager =
            context.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
        // Find the currently focused view, so we can grab the correct window
        // token from it.
        var view = (context as Activity).currentFocus
        // If no view currently has focus, create a new one, just so we can grab
        // a window token from it
        if (view == null) {
            view = View(context)
        }
        inputMethodManager.hideSoftInputFromWindow(view.windowToken, 0)
    }

    fun hideKeyboard(activity: Activity) {
        val imm = activity.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
        //Find the currently focused view, so we can grab the correct window token from it.
        var view = activity.currentFocus
        //If no view currently has focus, create a new one, just so we can grab a window token from it
        if (view == null) {
            view = View(activity)
        }
        imm.hideSoftInputFromWindow(view.windowToken, 0)
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    fun statusBarLightColor(activity: Activity, color: Int) {
        activity.window.statusBarColor = ContextCompat.getColor(activity, R.color.white)
        val decorView = activity.window.decorView //set status background Black
        decorView.systemUiVisibility =
            decorView.systemUiVisibility and View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR.inv()
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    fun statusBarColor(activity: Activity, color: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val window = activity.window
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
            window.statusBarColor = color
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                val window = activity.window
                window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
                window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
                window.statusBarColor = color
            }
        }
    }

    fun hideKeyBoardFromView() {
        val activity = context as AppCompatActivity
        val view = activity.currentFocus
        if (view != null) {
            val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            imm.hideSoftInputFromWindow(view.windowToken, 0)
        }
    }

    fun fullScreenUIMode(context: Activity) {
        if (Build.VERSION.SDK_INT == Build.VERSION_CODES.M) {
            context.window.setFlags(
                WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN
            )
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                val window = context.window
                window.setFlags(
                    WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
                    WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
                )
            }
            val uiOptions =
                View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
            context.window.decorView.systemUiVisibility = uiOptions
        }
    }

    fun fullScreenUIModeForMainActivity(context: Activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            val window = context.window
            //window.setFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS, WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
            window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN)
        }
    }

    fun showMap(context: Context, lat: String, longi: String) {
        try {
            val intent = Intent(
                Intent.ACTION_VIEW,
                Uri.parse("http://maps.google.com/maps?q=loc:$lat,$longi")
            )
            context.startActivity(intent)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
    var snackRetryInterface: SnackRetryInterface? = null

    fun setRetryClickListener(SnackRetryInterface: SnackRetryInterface) {
        snackRetryInterface = SnackRetryInterface
    }

    fun showSnackBar(view: View, context: Context, data: String, type: String, duration: Int) {
        try {
            val snackbar = Snackbar.make(view, "", duration)
            val layout = snackbar.view as SnackbarLayout
            val snackView: View =
                LayoutInflater.from(context).inflate(R.layout.snack_bar_layout, null)
            val snackbar_text = snackView.findViewById<TextView>(R.id.snackbar_text)
            val linearSnackBar = snackView.findViewById<LinearLayout>(R.id.linearSnackBar)
            val snackImg = snackView.findViewById<ImageView>(R.id.snackImg)
            val snackbar_btn = snackView.findViewById<TextView>(R.id.snackbar_btn)
            snackbar_text.text = data


            when {
                type.equals(Const.success, ignoreCase = true) -> {
                    snackbar_btn.visibility = View.GONE
                    snackbar_text.setTextColor(context.resources.getColor(R.color.white))
                    linearSnackBar.setBackgroundColor(context.resources.getColor(R.color.snackGreen))
                    snackImg.background = context.resources.getDrawable(R.drawable.success)
                }
                type.equals(Const.error, ignoreCase = true) -> {
                    snackbar_btn.setText(R.string.retry)
                    snackbar_btn.visibility = View.VISIBLE
                    linearSnackBar.setBackgroundColor(context.resources.getColor(R.color.snackRed))
                    snackbar_text.setTextColor(context.resources.getColor(R.color.white))
                    snackImg.background = context.resources.getDrawable(R.drawable.error)
                }
                type.equals(Const.alert, ignoreCase = true) -> {
                    snackbar_btn.visibility = View.GONE
                    linearSnackBar.setBackgroundColor(context.resources.getColor(R.color.darkYellow))
                    snackbar_text.setTextColor(context.resources.getColor(R.color.white))
                    snackImg.background = context.resources.getDrawable(R.drawable.alert)
                }
//                type.equals(Const.noInternet, ignoreCase = true) -> {
//                    snackbar_btn.setText(R.string.setting)
//                    snackbar_btn.visibility = View.VISIBLE
//                    linearSnackBar.setBackgroundColor(context.resources.getColor(R.color.snackRed))
//                    snackbar_text.setTextColor(context.resources.getColor(R.color.white))
//                    snackImg.background =
//                        context.resources.getDrawable(R.drawable.internet_connection)
//                }
            }

            layout.setBackgroundColor(context.resources.getColor(R.color.transparent))
            layout.setPadding(0, 0, 0, 0)
            layout.addView(snackView, 0)
            snackbar.show()

            try {
                snackbar_btn.setOnClickListener { view1: View? ->
                    snackRetryInterface?.onReTryClick(
                        snackbar_btn,
                        snackbar_btn
                    )
                }
            } catch (e: Exception) {
                Log.e("Exception", "showSnackBar: $e")
            }
        } catch (e: Exception) {
        }
    }

    fun customToast(context: Context, data: String?) {
        try {
            val toast = Toast(context)
            val view = LayoutInflater.from(context).inflate(R.layout.snack_bar_layout, null)
            val textView = view.findViewById<TextView>(R.id.snackbar_text)
            val linearSnackBar = view.findViewById<LinearLayout>(R.id.linearSnackBar)
            val snackImg = view.findViewById<ImageView>(R.id.snackImg)
            val snackbar_btn = view.findViewById<TextView>(R.id.snackbar_btn)
            textView.text = data
            toast.view = view
            snackbar_btn.visibility = View.GONE
            textView.setTextColor(context.resources.getColor(R.color.white))
            linearSnackBar.setBackgroundColor(context.resources.getColor(R.color.snackGreen))
            snackImg.background = context.resources.getDrawable(R.drawable.success)
            toast.setGravity(Gravity.BOTTOM or Gravity.FILL_HORIZONTAL, 0, 0)
            toast.duration = Toast.LENGTH_SHORT
            toast.show()
        } catch (e: Exception) {
            e.printStackTrace()
            Log.e("Exception123", "showSnackBar: $e")
        }
    }
    
    fun showProgress(context: Context?) {
        try {
            if (custDailog != null && custDailog!!.isShowing) custDailog!!.dismiss()
            if (custDailog == null) custDailog = CustomProgress(context!!)
            custDailog!!.setCancelable(false)
            custDailog!!.show()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun dismissProgress() {
        if (custDailog != null && custDailog!!.isShowing()) {
            try {
                custDailog!!.dismiss()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        custDailog = null
    }

    fun getStyledFont(html: String): String {
        val addBodyStart = !html.toLowerCase().contains("<body>")
        val addBodyEnd = !html.toLowerCase().contains("</body")
        return "<style type=\"text/css\">@font-face {font-family: CustomFont;" +
                "src: url(\"file:///android_asset/poppins_regular.ttf\")}" +
                "body {font-family: CustomFont;font-size: medium;text-align: justify;}</style>" +
                (if (addBodyStart) "<body>" else "") + html + if (addBodyEnd) "</body>" else ""
    }

    fun isValidEmail(email: String?): Boolean {
        return email != null && Pattern.compile(emailPattern).matcher(email).matches()
    }

    fun logOut(activity: Activity, msg: String?) {
        showCustomToast(msg)
        val preferenceManager = Pref(context)
        preferenceManager.clearPreferences()
        val intent = Intent(activity, LoginActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)
        activity.startActivity(intent)
        activity.finish() // call this to finish the current activity
    }

    fun showCustomToast(msg: String?) {
        val view =
            LayoutInflater.from(context).inflate(R.layout.custom_toast, null)
        val tvProgress = view.findViewById<TextView>(R.id.custom_toast_text)
        tvProgress.text = msg

        val myToast = Toast(context)
        myToast.duration = Toast.LENGTH_SHORT
        myToast.setGravity(Gravity.BOTTOM or Gravity.FILL_HORIZONTAL, 0, 0)
        myToast.view = view//setting the view of custom toast layout
        myToast.show()
    }

    companion object {
        private const val emailPattern = ("^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-]+)*@"
                + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$")
    }

    fun isNetworkAvailable(): Boolean {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE)
        return if (connectivityManager is ConnectivityManager) {
            val networkInfo: NetworkInfo? = connectivityManager.activeNetworkInfo
            networkInfo?.isConnected ?: false
        } else false
    }
}