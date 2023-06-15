package com.app.xtrahelpcaregiver.Request

data class AcceptRejectSubJobRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var substituteRequestId: String
    )
}