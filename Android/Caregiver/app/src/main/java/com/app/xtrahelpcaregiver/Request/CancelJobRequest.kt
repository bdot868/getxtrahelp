package com.app.xtrahelpcaregiver.Request

data class CancelJobRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var userJobApplyId: String
    )
}