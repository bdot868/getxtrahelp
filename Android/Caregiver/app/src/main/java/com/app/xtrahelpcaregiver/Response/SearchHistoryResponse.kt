package com.app.xtrahelpcaregiver.Response

data class SearchHistoryResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var totalPages: String
) {
    data class Data(
        var keyword: String,
        var userId: String,
        var userSearchHistoryId: String
    )
}