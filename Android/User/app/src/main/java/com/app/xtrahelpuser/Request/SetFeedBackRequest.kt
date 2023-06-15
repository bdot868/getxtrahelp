package com.app.xtrahelpuser.Request

data class SetFeedBackRequest(val data: FeedBackData)

data class FeedBackData(
    val langType: String,
    val token: String,
    val rating: String,
    val feedback: String
)