package com.app.xtrahelpuser.Request

data class RequestMediaRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var mediaType: String,
        var userJobDetailId: String
    )
}