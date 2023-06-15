package com.app.xtrahelpcaregiver.Request

data class RequestMediaUploadRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var userJobDetailId: String,
        var mediaName: String,
        var videoImage: String
    )
}