package com.app.xtrahelpuser.Response

data class PostedJobAplicantResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var totalPages: String
) {
    data class Data(
        var caregiverRatingAverage: String,
        var categoryNames: String,
        var isHire: String,
        var jobId: String,
        var profileImageThumbUrl: String,
        var profileImageUrl: String,
        var userFullName: String,
        var userId: String,
        var userJobApplyId: String,
        var selectedHire: Boolean = false
    )
}