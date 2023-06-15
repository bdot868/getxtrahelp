package com.app.xtrahelpcaregiver.Adapter

import android.content.Context
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Request.QuestionAnswer
import com.app.xtrahelpcaregiver.Response.JobDetailResponse
import com.app.xtrahelpcaregiver.Response.Question
import org.w3c.dom.Text

class ApplyJobAdapter(
    val context: Context,
    var questionAnswerList: ArrayList<QuestionAnswer> = ArrayList(),
    var questionList: ArrayList<Question>
) :
    RecyclerView.Adapter<ApplyJobAdapter.ViewHolder>() {


    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtQuestionCount: TextView = view.findViewById(R.id.txtQuestionCount)
        val txtQuestion: TextView = view.findViewById(R.id.txtQuestion)
        val etAnswer: TextView = view.findViewById(R.id.etAnswer)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.adapter_apply_job, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val count = position + 1
        for (i in questionList.indices) {
            if (questionAnswerList[position].questionId == questionList[i].userJobQuestionId) {
                holder.txtQuestion.text = questionList[i].question
                if (questionList[i].answer != null) {
                    holder.etAnswer.setText(questionList[i].answer)
                    questionAnswerList[position].answer = questionList[i].answer
                }
            }
        }
        holder.txtQuestionCount.text = "Question $count"

        holder.etAnswer.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                questionAnswerList[position].answer = holder.etAnswer.text.toString()
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {
            }
        })

    }

    override fun getItemCount(): Int {
        return questionAnswerList.size
    }
}