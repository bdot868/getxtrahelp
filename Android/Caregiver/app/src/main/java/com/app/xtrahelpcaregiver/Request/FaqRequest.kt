package com.app.xtrahelpcaregiver.Request

data class FaqRequest(val data: FaqData)

data class FaqData(
    val langType: String,
    val token: String,
    val search: String,
    val type: String,
    val page: Int,
    val limit: String
)