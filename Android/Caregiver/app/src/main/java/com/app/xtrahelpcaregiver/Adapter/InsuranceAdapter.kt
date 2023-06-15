package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.content.Intent
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Interface.SelectClick
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.Insurance
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpcaregiver.Ui.BlogDetailsActivity
import com.app.xtrahelpcaregiver.Utils.Utils
import com.app.xtrahelpcaregiver.apiCalling.RetrofitClient
import com.bumptech.glide.Glide
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

class InsuranceAdapter(
    private val context: Context,
    val insuranceList: ArrayList<Insurance>,
    val typeList: ArrayList<InsuranceType>
) :

    RecyclerView.Adapter<InsuranceAdapter.ViewHolder>() {

    lateinit var selectClick: SelectClick

    val inputFormat: DateFormat = SimpleDateFormat("yyyy-MM-dd")
    val outputFormat: DateFormat = SimpleDateFormat("MM-dd-yyyy")

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var txtType: TextView = view.findViewById(R.id.txtType)
        var txtDateExpire: TextView = view.findViewById(R.id.txtDateExpire)
        var etName: EditText = view.findViewById(R.id.etName)
        var etNumber: EditText = view.findViewById(R.id.etNumber)
        var image: ImageView = view.findViewById(R.id.image)
        var removeImg: ImageView = view.findViewById(R.id.removeImg)
        var card: CardView = view.findViewById(R.id.card)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): InsuranceAdapter.ViewHolder {
        var view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_insurace, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: InsuranceAdapter.ViewHolder, position: Int) {
        for (i in typeList.indices) {
            if (typeList[i].insuranceTypeId == insuranceList[position].insuranceTypeId) {
                holder.txtType.text = typeList[i].name
            }
        }

        if (insuranceList[position].expireDate != "") {
            val date: Date = inputFormat.parse(insuranceList[position].expireDate)
            val outputDateStr: String = outputFormat.format(date)
            holder.txtDateExpire.text = outputDateStr
        } else {
            holder.txtDateExpire.text = ""
        }

        holder.etName.setText(insuranceList[position].insuranceName)
        holder.etNumber.setText(insuranceList[position].insuranceNumber)

        holder.etName.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                insuranceList[position].insuranceName = holder.etName.text.toString()
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {
            }
        })

        holder.etNumber.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                insuranceList[position].insuranceNumber = holder.etNumber.text.toString()
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {
            }
        })


        Glide.with(context)
            .load(RetrofitClient.IMAGE_URL + insuranceList[position].insuranceImage)
            .placeholder(R.drawable.insurance_upload)
            .centerCrop()
            .into(holder.image)

        if (insuranceList.size == 1) {
            holder.removeImg.visibility = View.GONE
        } else {
            holder.removeImg.visibility = View.VISIBLE
        }

        holder.txtType.setOnClickListener {
            selectClick.selectClick(position, "showDialog")
        }

        holder.card.setOnClickListener {
            selectClick.selectClick(position, "imageUpload")
        }

        holder.removeImg.setOnClickListener {
            selectClick.selectClick(position, "remove")
        }

        holder.txtDateExpire.setOnClickListener {
            selectClick.selectClick(position, "selectDate")
        }

    }

    interface CallbackListen {
        fun clickItem(id: String)
    }


    override fun getItemCount(): Int {
        return insuranceList.size
    }

    override fun getItemViewType(position: Int): Int {
        return position
    }

    fun selectDateClick(selectClick: SelectClick) {
        this.selectClick = selectClick
    }
}