package com.app.xtrahelpcaregiver.Request

data class LangTokenSearchRequest(
    val data: LangTokenSearch
)

data class LangTokenSearch(
    val langType: String,
    val token: String,
    val search: String
)