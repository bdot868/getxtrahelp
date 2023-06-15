package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.appcompat.widget.AppCompatCheckBox
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.Interface.CardDeleteClickListner
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.GetCardListResponse
import java.util.regex.Pattern

class CardAdapter(
    val context: Context,
    var cardList: ArrayList<GetCardListResponse.Data>,
    val fromJob: String = "",
) : RecyclerView.Adapter<CardAdapter.ViewHolder>() {

    lateinit var cardDeleteClickListner: CardDeleteClickListner

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        var relative: RelativeLayout = view.findViewById(R.id.relative)
        var txtCardNumber: TextView = view.findViewById(R.id.txtCardNumber)
        var txtUserName: TextView = view.findViewById(R.id.txtUserName)
        var txtExpireDate: TextView = view.findViewById(R.id.txtExpireDate)
        var cardImg: ImageView = view.findViewById(R.id.cardImg)
        var cardDelete: CardView = view.findViewById(R.id.cardDelete)
        var checkbox: AppCompatCheckBox = view.findViewById(R.id.checkbox)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.adapter_card, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.relative.setBackgroundResource(if (position % 2 == 0) R.drawable.card_bg_purple else R.drawable.card_bg_green)

        if (fromJob == "job") {
            holder.checkbox.visibility = View.VISIBLE
        } else {
            holder.checkbox.visibility = View.GONE
        }

        holder.txtCardNumber.text = "**** **** **** " + cardList[position].last4
        holder.txtUserName.text = cardList[position].holderName
        holder.txtExpireDate.text = cardList[position].month + "/" + cardList[position].year

        if (cardList[position].cardBrand.lowercase() == "visa") {
            holder.cardImg.setImageResource(R.drawable.visa)
        } else if (cardList[position].cardBrand.lowercase() == "maestro") {
            holder.cardImg.setImageResource(R.drawable.master)
        } else if (cardList[position].cardBrand.lowercase() == "jcb") {
            holder.cardImg.setImageResource(R.drawable.jcb)
        } else if (cardList[position].cardBrand.lowercase() == "mastercard") {
            holder.cardImg.setImageResource(R.drawable.maestro)
        } else if (cardList[position].cardBrand.lowercase() == "discover") {
            holder.cardImg.setImageResource(R.drawable.discover)
        } else if (cardList[position].cardBrand.lowercase() == "american express") {
            holder.cardImg.setImageResource(R.drawable.american_express)
        } else {
            holder.cardImg.setImageResource(R.drawable.card)
        }


        holder.cardDelete.setOnClickListener {
            cardDeleteClickListner.onCardDeleteClick(cardList[position].userCardId)
        }

        holder.checkbox.setOnClickListener {
            cardDeleteClickListner.onCheckClick(cardList[position].userCardId)
        }
    }

    override fun getItemCount(): Int {
        return cardList.size
    }

    fun cardDeleteClickListner(cardDeleteClickListner: CardDeleteClickListner) {
        this.cardDeleteClickListner = cardDeleteClickListner
    }
}