package com.app.xtrahelpcaregiver.Response

data class RequestAddJobResponse(
    var `data`: Data,
    var message: String,
    var status: String
) {
    data class Data(
        var caregiverId: String,
        var endTime: String,
        var jobId: String,
        var jobName: String,
        var perviousHours: String,
        var requestEndTime: String,
        var requestStartTime: String,
        var startTime: String,
        var updatedHours: String,
        var userId: String,
        var userJobDetailId: String
    )
}