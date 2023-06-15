package com.app.xtrahelpcaregiver.Request

data class CheckForgotCodeRequest(
    val `data`: CheckForgotCodeData
)

data class CheckForgotCodeData(
    val langType: String,
    val email: String,
    val verificationCode: String ,
    val role: String
)