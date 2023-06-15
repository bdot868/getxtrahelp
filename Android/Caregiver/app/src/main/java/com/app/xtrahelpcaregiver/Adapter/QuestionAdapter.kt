package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.JobDetailResponse
import com.app.xtrahelpcaregiver.Response.Question

class QuestionAdapter(
    private val context: Context, var questionList: ArrayList<Question>
) : RecyclerView.Adapter<QuestionAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtQuestionCount: TextView = view.findViewById(R.id.txtQuestionCount)
        val txtQuestion: TextView = view.findViewById(R.id.txtQuestion)
        val txtAns: TextView = view.findViewById(R.id.txtAns)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): QuestionAdapter.ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_questions, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: QuestionAdapter.ViewHolder, position: Int) {
            val count = position + 1
            holder.txtQuestion.text = questionList[position].question
        holder.txtQuestionCount.text = "Question $count"

        if (questionList[position].answer == null) {
            holder.txtAns.visibility = View.GONE
        } else {
            holder.txtAns.visibility = View.VISIBLE
            holder.txtAns.text = questionList[position].answer
        }
    }

    override fun getItemCount(): Int {
        return questionList.size
    }

}