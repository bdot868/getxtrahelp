package com.app.xtrahelpcaregiver.Response

data class CaregiverTransactionResponse(
    var `data`: List<Data>,
    var message: String,
    var status: String,
    var totalPages: String
) {
    data class Data(
        var amount: String,
        var amountFormatted: String,
        var caregiverName: String,
        var jobName: String,
        var payType: String,
        var tranType: String,
        var type: String,
        var userJobId: String,
        var userTransactionId: String,
        var userTransactionTime: String
    )
}