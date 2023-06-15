package com.app.xtrahelpcaregiver.Response

data class GetWorkDetailsResponse(val status: String, val message: String, val data: WorkDetailData)

data class WorkDetailData(
    val userWorkDetailId: String,
    val userId: String,
    val workSpecialityId: String,
    val maxDistanceTravel: String,
    val workMethodOfTransportationId: String,
    val workDisabilitiesWillingTypeData: ArrayList<WorkDisabilitiesWillingTypeData>,
    val experienceOfYear: String,
    val inspiredYouBecome: String,
    val bio: String,
    val workSpecialityName: String,
    val workMethodOfTransportationName: String,
    val workDisabilitiesWillingTypeName: String,
    val categoryData: ArrayList<CategoryDatas>,
    val workExperienceData: ArrayList<WorkExperienceData>

)

data class WorkDisabilitiesWillingTypeData(
    val userWorkJobDisabilitiesWillingTypeId: String,
    val userId: String,
    val workDisabilitiesWillingTypeId: String,
    val WorkJobDisabilitiesWillingTypeName: String
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

data class CategoryDatas(
    val userCertificationsLicensesId: String,
    val userId: String,
    val jobCategoryId: String,
    val jobCategoryName: String,
    val name: String
)