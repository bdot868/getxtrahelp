package com.app.xtrahelpcaregiver.Response

data class AvailabilityResponse(
    val status: String,
    val message: String,
    val data: AvailabilityData
)

data class AvailabilityData(
    val availabilitySetting: ArrayList<AvailabilitySetting>,
    val timeOff: ArrayList<TimeOff>,
)

data class AvailabilitySetting(
    var userAvailabilitySettingId: String,
    var userId: String,
    var type: String,
    var day: String,
    var timing: String,
    var startTime: String,
    var endTime: String,
    var weekName: String,
)

data class TimeOff(
    val userAvailabilityOfftimeId:String,
    val userId:String,
    val day:String,
    val month:String,
    val startTime:String,
    val endTime:String
)

