package com.app.xtrahelpcaregiver.Request

data class SaveWorkDetailsRequest(val data: SaveWorkDetail)

data class SaveWorkDetail(
    val langType: String,
    val token: String,
    val jobCategory: ArrayList<String>,
    val workSpecialityId: String,
    val maxDistanceTravel: String,
    val workMethodOfTransportationId: String,
    val workDisabilitiesWillingType: ArrayList<String>,
    val experienceOfYear: String,
    val inspiredYouBecome: String,
    val bio: String,
    val profileStatus: String,
    val workExperience: ArrayList<WorkExperience>
)

data class WorkExperience(
    val workPlace: String,
    val startDate: String,
    val endDate: String,
    val leavingReason: String,
    val description: String
)