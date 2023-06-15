package com.app.xtrahelpcaregiver.Request

data class AccountChartDataRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var year: String
    )
}