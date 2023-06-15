package com.app.xtrahelpuser.Request

data class SendJobExtraHrRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var userJobDetailId: String,
        var startTime: String,
        var endTime: String
    )
}