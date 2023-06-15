package com.app.xtrahelpuser.Request

data class SetJobReviewRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var jobId: String,
        var rating: String,
        var feedback: String
    )
}