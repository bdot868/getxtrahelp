package com.app.xtrahelpcaregiver.Request

data class SaveCaregiverAvailibility(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var type: String,
        var dates: ArrayList<String>,
        var repeatType: String,
        var startTime: String,
        var endTime: String
    )
}