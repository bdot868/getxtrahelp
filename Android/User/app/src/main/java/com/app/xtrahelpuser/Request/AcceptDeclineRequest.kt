package com.app.xtrahelpuser.Request

data class AcceptDeclineRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var jobId: String,
        var caregiverId: String,
        var userCardId: String
    )
}