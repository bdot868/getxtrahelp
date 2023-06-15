package com.app.xtrahelpcaregiver.Request

data class LoginRequest(val data: LoginData)

data class LoginData(
    val langType:String,
    val email:String,
    val password:String,
    val role:String,
    val timeZone:String,
    val deviceId:String,
    val deviceType:String,
    val deviceToken:String
)