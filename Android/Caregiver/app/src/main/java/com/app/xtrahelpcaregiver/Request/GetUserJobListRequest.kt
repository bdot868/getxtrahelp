package com.app.xtrahelpcaregiver.Request

data class GetUserJobListRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var page: Int,
        var limit: String,
        var latitude: String,
        var longitude: String,
        var search: String,
        var category: ArrayList<String>,
        var isFirst: String,
        var isBehavioral: String,
        var isVerbal: String,
        var allergiesName: String,
        var specialitieId: ArrayList<String>,
        var isFamilyVaccinated: String,
        var isJobType: String,
        var startMiles: String,
        var endMiles: String,
    )
}