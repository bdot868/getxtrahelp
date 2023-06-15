package com.app.xtrahelpcaregiver.Request

data class WithdrawMoneyRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var amount: String
    )
}