package com.app.xtrahelpuser.Request

data class SaveUserJobRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var categoryId: String,
        var subCategoryId: ArrayList<String>,
        var name: String,
        var price: String,
        var location: String,
        var longitude: String,
        var latitude: String,
        var description: String,
        var isJob: String,
        var ownTransportation: String,
        var nonSmoker: String,
        var currentEmployment: String,
        var minExperience: String,
        var yearExperience: String,
        var additionalQuestions: ArrayList<AdditionalQuestion>,
        var media: ArrayList<Media>,
        var jobTiming: JobTiming
    )

    data class AdditionalQuestion(
        var name: String,
        var userJobQuestionId: String
    )

    data class JobTiming(
        var date: ArrayList<String>,
        var endTime: String ,
        var startTime: String
    )

    data class Media(
        var mediaName: String,
        var videoImage: String
    )

}