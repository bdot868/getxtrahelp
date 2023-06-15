package com.app.xtrahelpcaregiver.Request

data class DeleteFeedRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var feedId: String
    )
}