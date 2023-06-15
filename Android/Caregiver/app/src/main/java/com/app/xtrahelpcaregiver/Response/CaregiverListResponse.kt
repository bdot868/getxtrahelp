package com.app.xtrahelpcaregiver.Response

data class CaregiverListResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var totalPages: String
) {
    data class Data(
        var email: String,
        var firstName: String,
        var id: String,
        var lastName: String,
        var profileImageThumbUrl: String,
        var profileImageUrl: String,
        var status: String
    )
}