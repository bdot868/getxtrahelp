package com.app.xtrahelpuser.Response

data class CaregiverProfileResponse(
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
        var reviewData: ArrayList<ReviewData>,
        var status: String,
        var successPercentage: String,
        var totalJobCompleted: String,
        var totalJobs: String,
        var totalJobsHours: String,
        var totalReview: String,
        var totalYearWorkExperience: String,
        var workDisabilitiesWillingTypeName: String,
        var workDistancewillingTravel: String,
        var workExperienceData: ArrayList<WorkExperienceData>,
        var workMethodOfTransportationName: String,
        var workSpecialityName: String
    ) {
        data class CategoryData(
            var jobCategoryId: String,
            var name: String,
            var userId: String,
            var userWorkJobCategoryId: String
        )

        data class WorkExperienceData(
            val userWorkExperienceId: String,
            val userId: String,
            val workPlace: String,
            val startDate: String,
            val endDate: String,
            val leavingReason: String,
            val description: String,
        )

        data class ReviewData(
            val userReviewId: String,
            val userIdFrom: String,
            val userIdTo: String,
            val feedback: String,
            val jobId: String,
            val rating: String,
            val reviewDate: String,
            val userFullName: String,
            val profileImageUrl: String,
            val profileImageThumbUrl: String
        )
    }
}