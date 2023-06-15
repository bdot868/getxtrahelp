package com.app.xtrahelpuser.Request

data class SubstituteJobRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var page: Int,
        var limit: String
    )
}