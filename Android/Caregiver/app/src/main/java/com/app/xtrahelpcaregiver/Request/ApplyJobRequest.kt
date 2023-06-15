package com.app.xtrahelpcaregiver.Request

data class ApplyJobRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var jobId: String,
        var questionsAnswer: ArrayList<QuestionAnswer>
    )
}