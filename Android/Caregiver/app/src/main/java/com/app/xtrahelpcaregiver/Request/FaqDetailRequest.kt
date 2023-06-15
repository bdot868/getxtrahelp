package com.app.xtrahelpcaregiver.Request

data class FaqDetailRequest(val data: FaqDetailData)

data class FaqDetailData(
    val langType: String,
    val token: String,
    val faqId: String,
)