package com.app.xtrahelpcaregiver.Utils

import android.content.Context
import android.graphics.drawable.AnimationDrawable
import android.view.LayoutInflater
import android.widget.ImageView
import androidx.appcompat.app.AlertDialog
import com.app.xtrahelpcaregiver.R
import com.kaopiz.kprogresshud.KProgressHUD


class CustomDialog(private val context: Context) {
    private var aDProgress: AlertDialog? = null

private lateinit var hud: KProgressHUD
    fun showProgressDialog() {
//        val builder =
//            AlertDialog.Builder(context)
//        val view =
//            LayoutInflater.from(context).inflate(R.layout.custom_progress_bar, null)
//        builder.setCancelable(false)
//        builder.setView(view)
//        aDProgress = builder.create()
//        aDProgress!!.window!!.setBackgroundDrawable(ColorDrawable(Color.parseColor("#00000000")))
//        aDProgress!!.setCanceledOnTouchOutside(false)
//        aDProgress!!.setCancelable(false)
//        aDProgress!!.show()

        hud = KProgressHUD.create(context)
            .setStyle(KProgressHUD.Style.SPIN_INDETERMINATE)
            .setCornerRadius(10f)
//            .setSize(100,100)
            .setWindowColor(context.resources.getColor(R.color.txtOrange))
            .setCancellable(false)
            .setAnimationSpeed(2)
            .setDimAmount(0.2f)
            .show();
    }

    fun dismissDialog() {
        if (hud.isShowing) {
            hud.dismiss()
        }
    }

}