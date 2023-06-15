package com.app.xtrahelpcaregiver.Ui

import android.app.Activity
import android.app.ActivityManager
import android.app.ActivityManager.RunningTaskInfo
import android.app.Application
import android.app.Application.ActivityLifecycleCallbacks
import android.content.ComponentName
import android.content.Context
import android.os.AsyncTask
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import com.app.xtrahelpcaregiver.R
import com.google.firebase.FirebaseApp
import com.twitter.sdk.android.core.DefaultLogger
import com.twitter.sdk.android.core.Twitter
import com.twitter.sdk.android.core.TwitterAuthConfig
import com.twitter.sdk.android.core.TwitterConfig
import java.lang.Exception
import java.util.concurrent.ExecutionException

class XtraHelp : Application(), ActivityLifecycleCallbacks{

    override fun onCreate() {
        super.onCreate()

        instantiateManagers()
        try {
            BackgroundCheckTask().execute(this).get()
        } catch (e: ExecutionException) {
            e.printStackTrace()
        } catch (e: InterruptedException) {
            e.printStackTrace()
        }


//        // Initialize the Branch object
//        Branch.getAutoInstance(this);
        val config = TwitterConfig.Builder(this)
            .logger(DefaultLogger(Log.DEBUG)) //enable logging when app is in debug mode
            .twitterAuthConfig(
                TwitterAuthConfig(
                    resources.getString(R.string.TWITTER_API_KEY),
                    resources.getString(R.string.TWITTER_SECRET_KEY)
                )
            ) //pass the created app Consumer KEY and Secret also called API Key and Secret
            .debug(true) //enable debug mode
            .build()

        //finally initialize twitter with created configs

        //finally initialize twitter with created configs
        Twitter.initialize(config)
        FirebaseApp.initializeApp(this)
    }

    private fun instantiateManagers() {
        FirebaseApp.initializeApp(this)
    }
    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {

    }

    override fun onActivityStarted(activity: Activity) {

    }

    override fun onActivityResumed(activity: Activity) {

    }

    override fun onActivityPaused(activity: Activity) {

    }

    override fun onActivityStopped(activity: Activity) {
        try {
            BackgroundCheckTask().execute(this).get()
        } catch (e: ExecutionException) {
            e.printStackTrace()
        } catch (e: InterruptedException) {
            e.printStackTrace()
        }
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {

    }

    override fun onActivityDestroyed(activity: Activity) {
       
    }

    internal class BackgroundCheckTask :
        AsyncTask<Context?, Void?, Boolean>() {
        protected fun doInBackground(vararg params: Context): Boolean {
            val context = params[0].applicationContext
            return isApplicationBroughtToBackground(context)
        }

        private fun isApplicationBroughtToBackground(context: Context): Boolean {
            val am = context.getSystemService(ACTIVITY_SERVICE) as ActivityManager
            val tasks = am.getRunningTasks(1)
            if (!tasks.isEmpty()) {
                val topActivity = tasks[0].topActivity
                if (topActivity!!.packageName != context.packageName) {
                    Log.e("demooo", "isApplicationBroughtToBackground: ")
                    //                    Toast.makeText(context, "app background", Toast.LENGTH_SHORT).show();
                    return true
                }
            }
            return false
        }

        override fun doInBackground(vararg params: Context?): Boolean {
            return false
        }


    }

}