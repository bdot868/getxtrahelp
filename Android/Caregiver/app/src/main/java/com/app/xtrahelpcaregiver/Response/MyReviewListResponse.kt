package com.app.xtrahelpcaregiver.Response

data class MyReviewListResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var totalPages: String,
    var totalReview: String
) {
    data class Data(
        var feedback: String,
        var jobId: String,
        var profileImageThumbUrl: String,
        var profileImageUrl: String,
        var rating: String,
        var reviewDate: String,
        var userFullName: String,
        var userIdFrom: String,
        var userIdTo: String,
        var userReviewId: String
    )
}