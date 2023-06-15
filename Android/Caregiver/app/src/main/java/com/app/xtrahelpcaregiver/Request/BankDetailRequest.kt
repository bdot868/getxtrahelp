package com.app.xtrahelpcaregiver.Request

data class BankDetailRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var account_holder_name: String,
        var routing_number: String,
        var account_number: String,
        var account_holder_type: String
    )
}