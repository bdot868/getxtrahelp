package com.app.xtrahelpcaregiver.Request

data class VerifyJobVerificationCode(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var jobId: String,
        var userJobDetailId: String,
        var verificationCode: String
    )
}