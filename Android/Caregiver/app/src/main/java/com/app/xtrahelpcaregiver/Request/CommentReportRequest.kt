package com.app.xtrahelpcaregiver.Request

data class CommentReportRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var feedCommentId: String,
        var message: String
    )
}