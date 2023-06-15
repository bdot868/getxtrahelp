package com.app.xtrahelpuser.Request

data class UserDashboardRequest(
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