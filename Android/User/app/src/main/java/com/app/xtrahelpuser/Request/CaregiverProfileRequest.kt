package com.app.xtrahelpuser.Request

data class CaregiverProfileRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var caregiverId: String
    )
}