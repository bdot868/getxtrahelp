package com.app.xtrahelpcaregiver.Response

data class CommonDataResponse(val status: String, val message: String, val data: CommonData)

data class CommonData(
    val hearAboutUs: ArrayList<HearAboutUs> = ArrayList(),
    val licenceType: ArrayList<LicenceType> = ArrayList(),
    val insuranceType: ArrayList<InsuranceType> = ArrayList(),
    val workSpeciality: ArrayList<WorkSpeciality> = ArrayList(),
    val workMethodOfTransportation: ArrayList<WorkMethodOfTransportation> = ArrayList(),
    val workDisabilitiesWillingType: ArrayList<WorkDisabilitiesWillingType> = ArrayList(),
    val lovedDisabilitiesType: ArrayList<LovedDisabilitiesType> = ArrayList(),
    val lovedCategory: ArrayList<LovedCategory> = ArrayList(),
    val lovedSpecialities: ArrayList<LovedSpecialities> = ArrayList(),
)

data class HearAboutUs(val hearAboutUsId: String, val name: String)

data class LicenceType(val licenceTypeId: String, val name: String)

data class InsuranceType(val insuranceTypeId: String, val name: String)

data class WorkSpeciality(val workSpecialityId: String, val name: String)

data class WorkMethodOfTransportation(val workMethodOfTransportationId: String, val name: String)

data class WorkDisabilitiesWillingType(val workDisabilitiesWillingTypeId: String, val name: String)

data class LovedDisabilitiesType(val lovedDisabilitiesTypeId: String, val name: String)

data class LovedCategory(val lovedCategoryId: String, val name: String, val description: String)

data class LovedSpecialities(val lovedSpecialitiesId: String, val name: String)