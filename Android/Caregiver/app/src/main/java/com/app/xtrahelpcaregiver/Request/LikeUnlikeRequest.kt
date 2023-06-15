package com.app.xtrahelpcaregiver.Request

data class LikeUnlikeRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var userFeedId: String
    )
}