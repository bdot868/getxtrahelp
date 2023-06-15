package com.app.xtrahelpuser.Response

data class SubstituteListResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var totalPages: String
) {
    data class Data(
        var caregiverStatus: String,
        var jobId: String,
        var jobName: String,
        var jobOwnerId: String,
        var newCaregiverId: String,
        var oldCaregiverId: String,
        var profileImageThumbUrl: String,
        var profileImageUrl: String,
        var send_from: String,
        var send_to: String,
        var send_user: String,
        var startDateTime: String,
        var userFullName: String,
        var userJobApplyId: String,
        var userJobId: String,
        var userJobSubstituteRequestId: String,
        var userStatus: String
    )
}