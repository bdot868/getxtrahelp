package com.app.xtrahelpuser.Request

data class FindCaregiverRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var category: ArrayList<String>,
        var page: Int,
        var limit: String,
        var search: String,
        var latitude: String,
        var longitude: String,
        var isFirst: String,
        var isOnline: String,
        var isTopRated: String,
        var gender: String,
        var startAgeRange: String,
        var endAgeRange: String,
        var startMiles: String,
        var endMiles: String,
        var isVaccinated: String,
        var isAvailable: String,
        var customDate: String,
    )
}