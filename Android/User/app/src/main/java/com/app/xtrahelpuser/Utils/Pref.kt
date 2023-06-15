package com.app.xtrahelpcaregiver.Utils

import android.content.Context
import android.content.SharedPreferences
import com.app.xtrahelpuser.R


class Pref(context: Context) {
    val editor: SharedPreferences.Editor

    private val sharedPreferences: SharedPreferences = context.getSharedPreferences(
        context.getString(R.string.app_name),
        Context.MODE_PRIVATE
    )

    fun setString(key: String?, value: String?) {
        editor.putString(key, value)
        editor.apply()
    }

    fun getString(key: String?): String? {
        return sharedPreferences.getString(key, "")
    }

    fun setBoolean(key: String?, value: Boolean) {
        editor.putBoolean(key, value)
        editor.apply()
    }

    fun getBoolean(key: String?): Boolean {
        return sharedPreferences.getBoolean(key, false)
    }

    fun clearPreferences() {
        editor.clear()
        editor.apply()
    }

    fun setInt(keyTrainerId: String?, trainerId: Int?) {
        editor.putInt(keyTrainerId, trainerId!!)
        editor.apply()
    }

    init {
        editor = sharedPreferences.edit()
        editor.apply()
    }
}