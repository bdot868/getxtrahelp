package com.app.xtrahelpcaregiver.Request

data class DashboardRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var timezone: String,
        var latitude: String,
        var longitude: String
    )
}