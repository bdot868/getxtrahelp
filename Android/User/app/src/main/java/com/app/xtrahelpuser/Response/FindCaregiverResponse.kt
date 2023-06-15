package com.app.xtrahelpuser.Response

data class FindCaregiverResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var totalPages: String
) {
    data class Data(
        var categoryNames: String,
        var distance: String,
        var email: String,
        var firstName: String,
        var fullName: String,
        var id: String,
        var lastName: String,
        var profileImageThumbUrl: String,
        var profileImageUrl: String,
        var ratingAverage: String,
        var status: String,
        var totalJobWithMe: String,
        var totalJobCompleted: String,
        var totalJobOngoingWithMe: String
    )
}