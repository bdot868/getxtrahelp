package com.app.xtrahelpcaregiver.Response

data class VerifyJobCodeResponse(
    var status: String,
    var message: String,
    var `data`: Data
) {
    data class Data(
        var TotalSeconds: String,
        var categoryId: String,
        var createdDate: String,
        var currentEmployment: String,
        var description: String,
        var formatedPrice: String,
        var isHire: String,
        var isJob: String,
        var latitude: String,
        var location: String,
        var longitude: String,
        var minExperience: String,
        var name: String,
        var nonSmoker: String,
        var ownTransportation: String,
        var price: String,
        var startDateTime: String,
        var status: String,
        var totalMinutes: String,
        var totalTiming: String,
        var userCardId: String,
        var userId: String,
        var userJobDetailId: String,
        var userJobId: String,
        var verificationCode: String,
        var yearExperience: String
    )
}