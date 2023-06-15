package com.app.xtrahelpuser.Request

data class FeedListRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var search: String,
        var page: Int,
        var limit: String
    )
}