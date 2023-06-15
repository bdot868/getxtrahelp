package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Ui.AddJobActivity

class QuestionAdapter(private val context: Context) :
    RecyclerView.Adapter<QuestionAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val etQuestion: EditText = view.findViewById(R.id.etQuestion)
        val remove: ImageView = view.findViewById(R.id.remove)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): QuestionAdapter.ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_questions, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: QuestionAdapter.ViewHolder, position: Int) {
        val no = position + 1
        holder.etQuestion.hint = "Question $no"

        holder.etQuestion.setText(AddJobActivity.additionalQuestions[position].name)

        holder.etQuestion.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                AddJobActivity.additionalQuestions[position].name =
                    holder.etQuestion.text.toString()
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {
            }
        })

        holder.remove.setOnClickListener {
            AddJobActivity.additionalQuestions.remove(AddJobActivity.additionalQuestions[position])
            notifyDataSetChanged()
        }

    }

    override fun getItemCount(): Int {
        return AddJobActivity.additionalQuestions.size
    }
}