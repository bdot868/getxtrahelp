package com.app.xtrahelpuser.Request

data class GetPostedJobRequest(
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