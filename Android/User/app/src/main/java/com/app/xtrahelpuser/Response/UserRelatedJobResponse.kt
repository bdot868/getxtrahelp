package com.app.xtrahelpuser.Response

data class UserRelatedJobResponse(
    var `data`: ArrayList<JobData>,
    var message: String,
    var status: String,
    var totalPages: String
)
data class JobData(
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
    var caregiverPhone: String,
    var userJobApplyId: String,
    var userJobDetailId: String,
    var userJobId: String,
    var userJobIsHire: String,
    var verificationCode: String,
    var yearExperience: String
)