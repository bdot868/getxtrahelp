package com.app.xtrahelpcaregiver.Response

data class CMSResponse(val status: String, val message: String, val data: CMS)

data class CMS(
    val id: String,
    val key: String,
    val name: String,
    val description: String,
    val status: String,
    val createdDate: String
)