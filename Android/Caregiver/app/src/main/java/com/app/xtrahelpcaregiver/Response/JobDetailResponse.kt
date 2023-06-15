package com.app.xtrahelpcaregiver.Response

data class JobDetailResponse(
    var `data`: Data,
    var message: String,
    var status: String
) {
    data class Data(
        var CategoryName: String,
        var categoryId: String,
        var createdDate: String,
        var createdDateFormat: String,
        var currentEmployment: String,
        var description: String,
        var distance: String,
        var formatedPrice: String,
        var isHire: String,
        var isJob: String,
        var isJobApply: String,
        var latitude: String,
        var location: String,
        var longitude: String,
        var media: ArrayList<Media>,
        var minExperience: String,
        var name: String,
        var nonSmoker: String,
        var ownTransportation: String,
        var price: String,
        var profileImageThumbUrl: String,
        var profileImageUrl: String,
        var questions: ArrayList<Question>,
        var startDateTime: String,
        var userFullName: String,
        var jobFeedback: String,
        var jobRating: String,
        var userId: String,
        var userJobId: String,
        var yearExperience: String
    )
}