package com.app.xtrahelpuser.Response

data class SocialLoginRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var auth_id: String,
        var auth_provider: String,
        var deviceToken: String,
        var voipToken: String,
        var deviceType: String,
        var deviceId: String,
        var timeZone: String,
        var role: String,
        var email: String,
        var isManualEmail: String,
        var name: String
    )
}