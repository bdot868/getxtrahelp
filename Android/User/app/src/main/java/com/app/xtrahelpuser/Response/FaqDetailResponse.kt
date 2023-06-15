package com.app.xtrahelpuser.Response

data class FaqDetailResponse(val status: String, val message: String, val data: FaqDetail)

data class FaqDetail(
    val id: String,
    val type: String,
    val name: String,
    val description: String,
    val createdDate: String,
    val status: String
)