package com.app.xtrahelpcaregiver.Response

data class AccountChartDataResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String
) {
    data class Data(
        var amount: String,
        var month: String
    )
}