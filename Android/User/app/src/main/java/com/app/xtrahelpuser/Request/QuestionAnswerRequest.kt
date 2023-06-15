package com.app.xtrahelpuser.Request

data class QuestionAnswerRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var jobId: String,
        var userId: String
    )
}