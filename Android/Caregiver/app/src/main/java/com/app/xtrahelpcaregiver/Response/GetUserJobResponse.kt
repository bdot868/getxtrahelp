package com.app.xtrahelpcaregiver.Response

data class GetUserJobResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var totalPages: String
) {
    data class Data(
        var CategoryName: String,
        var categoryId: String,
        var createdDate: String,
        var currentEmployment: String,
        var description: String,
        var distance: String,
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
        var profileImageThumbUrl: String,
        var profileImageUrl: String,
        var startDateTime: String,
        var userFullName: String,
        var userId: String,
        var userJobId: String,
        var yearExperience: String
    )
}