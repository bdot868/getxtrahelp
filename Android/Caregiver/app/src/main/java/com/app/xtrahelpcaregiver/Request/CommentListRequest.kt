package com.app.xtrahelpcaregiver.Request

data class CommentListRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var userFeedId: String,
        var search: String,
        var page: Int,
        var limit: String
    )
}