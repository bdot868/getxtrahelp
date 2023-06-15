package com.app.xtrahelpcaregiver.Request

data class MyReviewListRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var caregiverId: String,
        var page: Int,
        var limit: String
    )
}