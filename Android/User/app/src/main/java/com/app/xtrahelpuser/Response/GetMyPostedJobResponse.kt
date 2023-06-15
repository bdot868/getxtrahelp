package com.app.xtrahelpuser.Response

data class GetMyPostedJobResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var totalPages: String
) {
    data class Data(
        var categoryId: String,
        var createdDate: String,
        var currentEmployment: String,
        var description: String,
        var formatedPrice: String,
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
        var totalApplication: String,
        var userId: String,
        var userJobId: String,
        var yearExperience: String
    )
}