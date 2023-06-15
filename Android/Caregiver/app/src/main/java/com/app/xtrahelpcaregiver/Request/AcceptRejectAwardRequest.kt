package com.app.xtrahelpcaregiver.Request

data class AcceptRejectAwardRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var userJobAwardId: String
    )
}