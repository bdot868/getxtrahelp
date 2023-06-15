package com.app.xtrahelpcaregiver.Request

data class JobDetailRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var jobId: String,
        var latitude: String,
        var longitude: String,
    )
}