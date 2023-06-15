package com.app.xtrahelpuser.Request

data class OnGoingJobReviewRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var userJobDetailId: String,
        var rating: String,
        var feedback: String
    )
}