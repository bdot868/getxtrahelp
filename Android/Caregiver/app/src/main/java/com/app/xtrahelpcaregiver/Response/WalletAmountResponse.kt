package com.app.xtrahelpcaregiver.Response

data class WalletAmountResponse(
    var `data`: Data,
    var message: String,
    var status: String,
    var stripe_connect_status: String
) {
    data class Data(
        var walletAmount: String,
        var walletAmountFormat: String,
        var walletAmountInFormat: String,
        var walletAmountOutFormat: String
    )
}