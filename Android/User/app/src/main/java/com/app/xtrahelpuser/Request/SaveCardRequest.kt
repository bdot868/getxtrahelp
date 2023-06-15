package com.app.xtrahelpuser.Request

data class SaveCardRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var holderName: String,
        var number: String,
        var expMonth: String,
        var expYear: String,
        var cvv: String
    )
}