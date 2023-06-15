package com.app.xtrahelpuser.Response

data class PostedJobDetailResponse(
    var `data`: Data,
    var message: String,
    var status: String
) {
    data class Data(
        var CategoryName: String,
        var applicants: ArrayList<Applicants>,
        var categoryId: String,
        var createdDate: String,
        var createdDateFormat: String,
        var currentEmployment: String,
        var description: String,
        var formatedPrice: String,
        var isJob: String,
        var latitude: String,
        var location: String,
        var longitude: String,
        var media: ArrayList<Media>,
        var minExperience: String,
        var name: String,
        var nonSmoker: String,
        var ownTransportation: String,
        var price: String,
        var questions: ArrayList<Question>,
        var startDateTime: String,
        var totalApplication: String,
        var userId: String,
        var userJobId: String,
        var yearExperience: String
    ) {
        data class Media(
            var isVideo: String,
            var jobId: String,
            var mediaName: String,
            var mediaNameThumbUrl: String,
            var mediaNameUrl: String,
            var userJobMediaId: String,
            var videoImage: String,
            var videoImageThumbUrl: String,
            var videoImageUrl: String
        )

        data class Question(
            var jobId: String,
            var question: String,
            var userJobQuestionId: String,
            var answer: String
        )

        data class Applicants(
            val userJobApplyId: String,
            val jobId: String,
            val userId: String,
            val isHire: String,
            val userFullName: String,
            val profileImageUrl: String,
            val profileImageThumbUrl: String,
            val categoryNames: String,
            val caregiverRatingAverage: String
        )
    }
}