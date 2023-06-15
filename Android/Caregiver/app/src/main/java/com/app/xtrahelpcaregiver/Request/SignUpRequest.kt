package com.app.xtrahelpcaregiver.Request

data class SignUpRequest(val data: SignUpData)

data class SignUpData(
    val langType: String,
    val email: String,
    val password: String,
    val role: String,
    val name: String
)