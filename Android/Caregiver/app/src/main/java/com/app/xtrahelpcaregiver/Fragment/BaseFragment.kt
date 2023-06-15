package com.app.xtrahelpcaregiver.Fragment

import android.app.Activity
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.CustomDialog
import com.app.xtrahelpcaregiver.Utils.Pref
import com.app.xtrahelpcaregiver.Utils.Utils

open class BaseFragment : Fragment(), View.OnClickListener {
    lateinit var activity: Activity
    lateinit var utils: Utils
    lateinit var pref: Pref
    lateinit var customDialog: CustomDialog

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_base, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        activity = requireActivity()
        utils = Utils(activity)
        pref = Pref(activity)
        customDialog = CustomDialog(activity)
    }

    override fun onClick(v: View?) {

    }

    fun checkStatus(view: View, status: String, message: String) {
        if (status == "0") {
            utils.showSnackBar(view, activity, message, Const.alert, Const.successDuration)
        } else if (status == "2" || status == "5") {
            utils.logOut(activity, message)
        }
    }
}