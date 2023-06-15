package com.app.xtrahelpuser.Request

data class CaregiverJobRelatedRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var page: Int,
        var limit: String,
        var search: String,
        var gender: String,
        var customDate: String,
        var endAgeRange: String,
        var isAvailable: String,
        var isVaccinated: String,
        var startAgeRange: String
    )
}