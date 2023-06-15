package com.app.xtrahelpcaregiver.Request

data class ResendCodeVerifyRequest(
    val `data`: ResendData
)

data class ResendData(
    val email: String,
    val langType: String,
    val role: String

)