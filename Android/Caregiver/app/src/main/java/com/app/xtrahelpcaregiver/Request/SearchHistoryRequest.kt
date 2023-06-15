package com.app.xtrahelpcaregiver.Request

data class SearchHistoryRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var page: String,
        var limit: String,
        var search: String
    )
}