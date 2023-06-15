package com.app.xtrahelpcaregiver.Request

data class RemoveSingleAvailabilityRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var availabilityId: String
    )
}