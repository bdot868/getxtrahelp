package com.app.xtrahelpcaregiver.Response

data class CaregiverCalendarAvailabilityNewResponse(
    var `data`: List<Data>,
    var message: String,
    var status: String
) {
    data class Data(
        var availabilityId: String,
        var caregiverEndDateTime: String,
        var caregiverEndTimeStamp: String,
        var caregiverStartDateTime: String,
        var caregiverStartTimeStamp: String,
        var date: String,
        var dayAndDate: String,
        var endTime: String,
        var endTimeStamp: String,
        var startTime: String,
        var startTimeStamp: String
    )
}