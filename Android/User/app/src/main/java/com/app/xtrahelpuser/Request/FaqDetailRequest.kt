package com.app.xtrahelpuser.Request

data class FaqDetailRequest(val data: FaqDetailData)

data class FaqDetailData(
    val langType: String,
    val token: String,
    val faqId: String,
)