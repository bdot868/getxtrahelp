package com.app.xtrahelpcaregiver.Request

data class ChangePasswordRequest(
    val data: ChangePasswordData
)

data class ChangePasswordData(
    val langType: String,
    val token: String,
    val oldPassword: String,
    val newPassword: String
)