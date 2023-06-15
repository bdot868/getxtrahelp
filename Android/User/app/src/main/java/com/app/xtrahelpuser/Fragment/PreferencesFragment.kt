package com.app.xtrahelpuser.Fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpuser.Adapter.QuestionAdapter
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.SaveUserJobRequest
import com.app.xtrahelpuser.Ui.AddJobActivity
import kotlinx.android.synthetic.main.fragment_preferences.*
import kotlinx.android.synthetic.main.fragment_preferences.relative
import kotlinx.android.synthetic.main.fragment_preferences.relativeBack
import kotlinx.android.synthetic.main.fragment_preferences.relativeNext

class PreferencesFragment : BaseFragment() {

    lateinit var questionAdapter: QuestionAdapter
    val additionalQuestions: ArrayList<SaveUserJobRequest.AdditionalQuestion> = ArrayList()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_preferences, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        init()
    }

    private fun init() {
        relativeNext.setOnClickListener(this)
        checkHasOwn.setOnClickListener(this)
        checkNonSmoker.setOnClickListener(this)
        checkMinEx.setOnClickListener(this)
        checkHasCurrentEmp.setOnClickListener(this)
        txtAddQuestion.setOnClickListener(this)
        relativeBack.setOnClickListener(this)

        questionAdapter = QuestionAdapter(activity)
        recyclerQuestion.layoutManager = LinearLayoutManager(activity)
        recyclerQuestion.isNestedScrollingEnabled = false
        recyclerQuestion.adapter = questionAdapter


        checkHasOwn.isChecked = AddJobActivity.ownTransportation == "1"
        checkNonSmoker.isChecked = AddJobActivity.nonSmoker == "1"
        checkHasCurrentEmp.isChecked = AddJobActivity.currentEmployment == "1"
        checkMinEx.isChecked = AddJobActivity.minExperience == "1"
        if (checkMinEx.isChecked) {
            etYear.visibility = View.VISIBLE
            etYear.setText(AddJobActivity.yearExperience)
        } else {
            etYear.visibility = View.GONE
        }
        
        addQuestion()

    }

    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.relativeNext -> {
                if (isValid()) {
                    (getActivity() as AddJobActivity?)?.nextFragment()
                }
            }
            R.id.relativeBack -> {
                (getActivity() as AddJobActivity?)?.backFragment()
            }

            R.id.txtAddQuestion -> {
                addQuestion()
            }

            R.id.checkHasOwn -> {
                if (checkHasOwn.isChecked) {
                    AddJobActivity.ownTransportation = "1"
                } else {
                    AddJobActivity.ownTransportation = "0"
                }
            }

            R.id.checkNonSmoker -> {
                if (checkNonSmoker.isChecked) {
                    AddJobActivity.nonSmoker = "1"
                } else {
                    AddJobActivity.nonSmoker = "0"
                }
            }

            R.id.checkMinEx -> {
                if (checkMinEx.isChecked) {
                    AddJobActivity.minExperience = "1"
                    etYear.visibility = View.VISIBLE
                } else {
                    AddJobActivity.minExperience = "0"
                    etYear.visibility = View.GONE
                }
            }

            R.id.checkHasCurrentEmp -> {
                if (checkHasCurrentEmp.isChecked) {
                    AddJobActivity.currentEmployment = "1"
                } else {
                    AddJobActivity.currentEmployment = "0"
                }
            }

        }
    }

    private fun addQuestion() {
        val additionalQuestion = SaveUserJobRequest.AdditionalQuestion("", "")
        AddJobActivity.additionalQuestions.add(additionalQuestion)
        questionAdapter.notifyDataSetChanged()
    }

    private fun isValid(): Boolean {
        var message: String
        message = ""
        AddJobActivity.yearExperience = etYear.text.toString()

        if (checkMinEx.isChecked && etYear.text.isEmpty()) {
            message = "Please enter experience year"
        } 
//        else if (AddJobActivity.additionalQuestions.isEmpty()) {
//            message = "Please add question"
//        }
        else if (AddJobActivity.additionalQuestions.isNotEmpty()) {
            for (i in AddJobActivity.additionalQuestions.indices) {
                val count = i + 1
                if (AddJobActivity.additionalQuestions[i].name == "") {
                    message = "Please enter question $count"
                    break
                }
            }
        }

        if (message.isNotEmpty()) {
            utils.hideKeyBoardFromView()
            utils.showSnackBar(relative, activity, message, Const.alert, Const.successDuration)
        }
        return message.trim().isEmpty()
    }
}