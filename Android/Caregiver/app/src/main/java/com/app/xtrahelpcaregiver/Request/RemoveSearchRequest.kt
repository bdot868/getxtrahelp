package com.app.xtrahelpcaregiver.Request

data class RemoveSearchRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var userSearchHistoryId: String
    )
}