package com.app.xtrahelpcaregiver.Response

data class CaregiverAvailabilitySettingNewResponse(
    var status: String,
    var message: String,
    var endTime: String,
    var startTime: String,
    var type: String,
    var repeatType: String,
    var `data`: ArrayList<Data>
) {
    data class Data(
        var date: String,
        var endTime: String,
        var repeatType: String,
        var startTime: String,
        var timing: String,
        var type: String,
        var userAvailabilitySettingNewId: String,
        var userId: String
    )
}