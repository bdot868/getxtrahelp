package com.app.xtrahelpcaregiver.Response

data class AwardListResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var totalPages: String,
    var totalWorkTime: String
) {
    data class Data(
        var endTimestamp: String,
        var isHire: String,
        var jobId: String,
        var jobName: String,
        var jobUserId: String,
        var profileImageThumbUrl: String,
        var profileImageUrl: String,
        var starTimestamp: String,
        var startDateTime: String,
        var userFullName: String,
        var userId: String,
        var userJobAwardId: String,
        var userJobDetailId: String
    )
}