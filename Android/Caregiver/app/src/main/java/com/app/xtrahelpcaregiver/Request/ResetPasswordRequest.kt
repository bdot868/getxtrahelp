package com.app.xtrahelpcaregiver.Request

data class ResetPasswordRequest(
    val `data`: ResetPasswordData
)

data class ResetPasswordData(
    val langType: String,
    val email: String,
    val newPassword: String,
    val role: String
)