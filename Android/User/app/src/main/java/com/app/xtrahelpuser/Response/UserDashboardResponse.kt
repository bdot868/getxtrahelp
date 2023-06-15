package com.app.xtrahelpuser.Response

import com.app.xtrahelpcaregiver.Response.CategoryData

data class UserDashboardResponse(
    var `data`: Data,
    var message: String,
    var status: String
) {
    data class Data(
        var categories: ArrayList<CategoryData>,
        var nearestCaregiver: ArrayList<NearestCaregiver>,
        var ongoingJobs: ArrayList<OnGoing>,
        var resourcesAndBlogs: ArrayList<Resource>,
        var upcomingJobs: ArrayList<JobData>
    ) {
        data class NearestCaregiver(
            var categoryNames: String,
            var distance: String,
            var email: String,
            var firstName: String,
            var fullName: String,
            var id: String,
            var lastName: String,
            var profileImageThumbUrl: String,
            var profileImageUrl: String,
            var status: String
        )

        data class OnGoing(
            var userJobId: String,
            var userId: String,
            var categoryId: String,
            var name: String,
            var price: String,
            var formatedPrice: String,
            var ownTransportation: String,
            var nonSmoker: String,
            var currentEmployment: String,
            var minExperience: String,
            var yearExperience: String,
            var location: String,
            var latitude: String,
            var longitude: String,
            var description: String,
            var isJob: String,
            var isHire: String,
            var verificationCode: String,
            var createdDate: String,
            var status: String,
            var userFullName: String,
            var profileImageUrl: String,
            var profileImageThumbUrl: String,
            var caregiverId: String,
            var userJobApplyId: String,
            var userJobIsHire: String,
            var userJobDetailId: String,
            var starTimestamp: String,
            var endTimestamp: String,
            var jobStatus: String,
            var startDateTime: String,
            var leftTime: String
        )

        data class UpcomingJob(
            var caregiverId: String,
            var categoryId: String,
            var createdDate: String,
            var currentEmployment: String,
            var description: String,
            var endTimestamp: String,
            var formatedPrice: String,
            var isHire: String,
            var isJob: String,
            var jobStatus: String,
            var latitude: String,
            var location: String,
            var longitude: String,
            var minExperience: String,
            var name: String,
            var nonSmoker: String,
            var ownTransportation: String,
            var price: String,
            var profileImageThumbUrl: String,
            var profileImageUrl: String,
            var starTimestamp: String,
            var startDateTime: String,
            var status: String,
            var userFullName: String,
            var userId: String,
            var userJobApplyId: String,
            var userJobDetailId: String,
            var userJobId: String,
            var userJobIsHire: String,
            var verificationCode: String,
            var yearExperience: String
        )
    }
}