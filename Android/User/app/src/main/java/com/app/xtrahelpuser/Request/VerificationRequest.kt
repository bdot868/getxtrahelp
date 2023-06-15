package com.app.xtrahelpcaregiver.Request

data class VerificationRequest(
    val `data`: VerifyData
)

data class VerifyData(
    val langType: String,
    val email: String,
    val role: String,
    val verificationCode: String,
    val authProvider: String,
    val timezone: String,
    val deviceId: String,
    val deviceType: String,
    val deviceToken: String
)