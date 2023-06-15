package com.app.xtrahelpuser.Response

data class QuestionAnswerResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String
) {
    data class Data(
        var answer: String,
        var createdDate: String,
        var id: String,
        var jobId: String,
        var question: String,
        var status: String,
        var userId: String,
        var userJobApplyId: String,
        var userJobQuestionId: String
    )
}