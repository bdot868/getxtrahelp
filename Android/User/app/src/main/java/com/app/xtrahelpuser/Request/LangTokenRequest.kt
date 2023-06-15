package com.app.xtrahelpcaregiver.Request

data class LangTokenRequest(
    val data: LangToken
)

data class LangToken(
    val langType: String,
    val token: String
)