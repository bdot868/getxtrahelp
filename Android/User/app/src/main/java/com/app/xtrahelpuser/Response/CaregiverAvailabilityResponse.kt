package com.app.xtrahelpuser.Response

data class CaregiverAvailabilityResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String
) {
    data class Data(
        var caregiverEndDateTime: String,
        var caregiverEndTimeStamp: String,
        var caregiverStartDateTime: String,
        var caregiverStartTimeStamp: String,
        var date: String,
        var dayAndDate: String,
        var endTimeStamp: String,
        var slot: ArrayList<Slot>,
        var startTimeStamp: String
    ) {
        data class Slot(
            var caregiverEndTimeStamp: String,
            var caregiverStartTimeStamp: String,
            var date: String,
            var duration: String,
            var endDateTime: String,
            var endTimestamp: String,
            var isBooked: String,
            var startDateTime: String,
            var startTimestamp: String,
            var time: String
        )
    }
}