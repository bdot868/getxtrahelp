package com.app.xtrahelpcaregiver.Request

data class CaregiverTransactionRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var page: Int,
        var limit: String
    )
}