package com.app.xtrahelpcaregiver.Request

data class ModifyAnswerRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var jobId: String,
        var userJobApplyId: String,
        var questionsAnswer: ArrayList<QuestionAnswer>
    )
}