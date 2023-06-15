package com.app.xtrahelpcaregiver.Request

data class UpdateProfileStatusRequest(
    val data: UpdateProfileStatus
)

data class UpdateProfileStatus(
    val langType: String,
    val token: String,
    val profileStatus: String
)