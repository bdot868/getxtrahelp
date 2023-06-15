package com.app.xtrahelpuser.Request

data class RemoveCardRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var userCardId: String
    )
}