package com.app.xtrahelpcaregiver.Request

data class CaregiverRelatedJobDetailRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var userJobDetailId: String
    )
}