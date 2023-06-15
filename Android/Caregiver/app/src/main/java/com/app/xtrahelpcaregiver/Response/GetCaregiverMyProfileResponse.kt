package com.app.xtrahelpcaregiver.Response

data class GetCaregiverMyProfileResponse(
    var `data`: Data,
    var message: String,
    var status: String
) {
    data class Data(
        var address: String,
        var age: String,
        var caregiverBio: String,
        var categoryData: ArrayList<CategoryData>,
        var email: String,
        var familyVaccinated: String,
        var firstName: String,
        var fullName: String,
        var gender: String,
        var hearAboutUsId: String,
        var hearAboutUsName: String,
        var id: String,
        var lastName: String,
        var latitude: String,
        var longitude: String,
        var phone: String,
        var profileImageThumbUrl: String,
        var profileImageUrl: String,
        var ratingAverage: String,
        var status: String,
        var successPercentage: String,
        var totalJobCompleted: String,
        var totalJobs: String,
        var totalJobsHours: String,
        var totalYearWorkExperience: String,
        var workDisabilitiesWillingTypeName: String,
        var workDistancewillingTravel: String,
        var workExperienceData: ArrayList<WorkExperienceData>,
        var workMethodOfTransportationName: String,
        var workSpecialityName: String,
    ) {
        data class CategoryData(
            val userWorkJobCategoryId: String,
            val userId: String,
            val jobCategoryId: String,
            val name: String
        )
    }
}