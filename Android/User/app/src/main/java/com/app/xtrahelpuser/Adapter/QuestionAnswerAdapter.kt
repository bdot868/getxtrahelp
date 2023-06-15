package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Response.QuestionAnswerResponse
import com.app.xtrahelpuser.Ui.SupportChatActivity
import org.w3c.dom.Text

class QuestionAnswerAdapter(
    val context: Context,
    val questionAnsList: ArrayList<QuestionAnswerResponse.Data>
) : RecyclerView.Adapter<QuestionAnswerAdapter.ViewHolder>() {


    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtQuestionCount: TextView = view.findViewById(R.id.txtQuestionCount)
        val txtQuestion: TextView = view.findViewById(R.id.txtQuestion)
        val txtAns: TextView = view.findViewById(R.id.txtAns)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_question_answer, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val count = position + 1
        holder.txtQuestionCount.text = "Question $count"
        holder.txtQuestion.text = questionAnsList[position].question
        holder.txtAns.text = questionAnsList[position].answer

    }

    override fun getItemCount(): Int {
        return questionAnsList.size
    }
}