package com.app.xtrahelpuser.Request

data class UserRelatedJobDetailRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var userJobDetailId: String
    )
}