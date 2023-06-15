package com.app.xtrahelpuser.Request

data class UserRelatedJobRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var page: Int,
        var limit: String,
        var search: String,
        var type: String
    )
}