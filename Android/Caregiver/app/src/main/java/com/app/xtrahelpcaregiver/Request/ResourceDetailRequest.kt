package com.app.xtrahelpcaregiver.Request

data class ResourceDetailRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var blogId: String
    )
}