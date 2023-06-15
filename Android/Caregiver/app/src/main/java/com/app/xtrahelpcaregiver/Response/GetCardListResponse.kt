package com.app.xtrahelpcaregiver.Response

data class GetCardListResponse(
    var `data`: List<Data>,
    var message: String,
    var status: String
) {
    data class Data(
        var cardBrand: String,
        var cardId: String,
        var customerId: String,
        var holderName: String,
        var last4: String,
        var month: String,
        var userCardId: String,
        var userId: String,
        var year: String
    )
}