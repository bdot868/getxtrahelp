package com.app.xtrahelpcaregiver.Request

data class NotificationSettingRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var inboxMsgText: String,
        var inboxMsgMail: String,
        var jobMsgText: String,
        var jobMsgMail: String,
        var caregiverUpdateText: String,
        var caregiverUpdateMail: String
    )
}