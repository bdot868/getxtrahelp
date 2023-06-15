package com.app.xtrahelpuser.Request

data class PostedJobDetailRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var jobId: String
    )
}