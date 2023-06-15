package com.app.xtrahelpcaregiver.Request

data class DeleteCommentRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var commentId: String
    )
}