package com.app.xtrahelpcaregiver.Response

data class BankDetailResponse(
    var status: String,
    var message: String,
    var data: Data,
) {
    data class Data(
        var id: String,
        var account_holder_name: String,
        var account_holder_type: String,
        var routing_number: String,
        var country: String,
        var currency: String,
        var account_number: String,
    )
}