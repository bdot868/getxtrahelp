package com.app.xtrahelpcaregiver.Adapter

import android.app.DatePickerDialog
import android.content.Context
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.CertificationsOrLicenses
import com.app.xtrahelpcaregiver.Response.LicenceType
import com.app.xtrahelpcaregiver.Utils.Utils
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList
import androidx.cardview.widget.CardView
import com.app.xtrahelpcaregiver.Interface.SelectClick
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.bumptech.glide.Glide


open class CertificationAdapter(
    val context: Context,
    val certificationsOrLicensesList: ArrayList<CertificationsOrLicenses>,
    val licenceTypeList: ArrayList<LicenceType>
) : RecyclerView.Adapter<CertificationAdapter.ViewHolder>() {

    lateinit var dialog: BottomSheetDialog
    var utils = Utils(context)

    lateinit var selectClick: SelectClick

    val inputFormat: DateFormat = SimpleDateFormat("yyyy-MM-dd")
    val outputFormat: DateFormat = SimpleDateFormat("MM-dd-yyyy")

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var removeImg: ImageView = view.findViewById(R.id.removeImg)
        var image: ImageView = view.findViewById(R.id.image)
        var txtType: TextView = view.findViewById(R.id.txtType)
        var txtIssueDate: TextView = view.findViewById(R.id.txtIssueDate)
        var txtExpireDate: TextView = view.findViewById(R.id.txtExpireDate)
        var etName: EditText = view.findViewById(R.id.etName)
        var etNumber: EditText = view.findViewById(R.id.etNumber)
        var etDesc: EditText = view.findViewById(R.id.etDesc)
        var card: CardView = view.findViewById(R.id.card)
    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): CertificationAdapter.ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_certification, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: CertificationAdapter.ViewHolder, position: Int) {
        holder.txtType.text =""

            for (i in licenceTypeList.indices) {
            if (licenceTypeList[i].licenceTypeId == certificationsOrLicensesList[position].licenceTypeId) {
                holder.txtType.text = licenceTypeList[i].name
            }
        }

        if (certificationsOrLicensesList[position].issueDate != "") {
            val date: Date = inputFormat.parse(certificationsOrLicensesList[position].issueDate)
            val outputDateStr: String = outputFormat.format(date)
            holder.txtIssueDate.text = outputDateStr
        } else {
            holder.txtIssueDate.text = ""
        }

        if (certificationsOrLicensesList[position].expireDate != "") {
            val date: Date = inputFormat.parse(certificationsOrLicensesList[position].expireDate)
            val outputDateStr: String = outputFormat.format(date)
            holder.txtExpireDate.text = outputDateStr
        } else {
            holder.txtExpireDate.text = ""
        }

        if (certificationsOrLicensesList.size == 1) {
            holder.removeImg.visibility = View.GONE
        } else {
            holder.removeImg.visibility = View.VISIBLE
        }


        holder.etName.setText(certificationsOrLicensesList[position].licenceName)
        holder.etNumber.setText(certificationsOrLicensesList[position].licenceNumber)
        holder.etDesc.setText(certificationsOrLicensesList[position].description)

        holder.etName.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                certificationsOrLicensesList[position].licenceName = holder.etName.text.toString()
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {
            }
        })

        holder.etNumber.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                certificationsOrLicensesList[position].licenceNumber = holder.etNumber.text.toString()
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {
            }
        })

        holder.etDesc.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                certificationsOrLicensesList[position].description = holder.etDesc.text.toString()
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {
            }
        })


        holder.txtType.setOnClickListener {
            selectClick.selectClick(position, "showDialog")
        }

        holder.txtIssueDate.setOnClickListener {
            selectClick.selectClick(position, "issueDate")
        }

        holder.txtExpireDate.setOnClickListener {
            selectClick.selectClick(position, "expireDate")
        }

        holder.card.setOnClickListener {
            selectClick.selectClick(position, "imageUpload")
        }

        holder.removeImg.setOnClickListener {
            selectClick.selectClick(position, "remove")
        }

        Glide.with(context)
            .load(RetrofitClient.IMAGE_URL + certificationsOrLicensesList[position].licenceImage)
            .placeholder(R.drawable.upload_licence)
            .centerCrop()
            .into(holder.image)

    }

    open fun removeAt(position: Int) {
        certificationsOrLicensesList.removeAt(position)
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return certificationsOrLicensesList.size
    }

    fun selectDateClick(selectClick: SelectClick) {
        this.selectClick = selectClick
    }

    override fun getItemViewType(position: Int): Int {
        return position
    }
}