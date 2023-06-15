package com.app.xtrahelpcaregiver.Request

data class SaveAvailabilityRequest(
    val data: AvailabilityRequestData
)

data class AvailabilityRequestData(
    val langType: String,
    val token: String,
    val availability: ArrayList<Availability>,
    val offDateTime: ArrayList<OffDateTime>
)

data class Availability(
    var day: String,
    var type: String,
    var startTime: String,
    var endTime: String
)

data class OffDateTime(
    var day: String,
    var month: String,
    var startTime: String,
    var endTime: String
)