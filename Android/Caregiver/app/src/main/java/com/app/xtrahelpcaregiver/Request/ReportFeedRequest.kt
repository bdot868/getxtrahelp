package com.app.xtrahelpcaregiver.Request

data class ReportFeedRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var userFeedId: String,
        var message: String
    )
}