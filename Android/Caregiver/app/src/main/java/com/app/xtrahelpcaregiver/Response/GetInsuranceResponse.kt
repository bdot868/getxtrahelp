package com.app.xtrahelpcaregiver.Response

data class GetInsuranceResponse(
    val status: String,
    val message: String,
    val data: ArrayList<InsuranceData>
)

data class InsuranceData(
    val userInsuranceId:String,
    val userId:String,
    val insuranceTypeId:String,
    val insuranceName:String,
    val insuranceNumber:String,
    val expireDate:String,
    val insuranceImageName:String,
    val insuranceImageUrl:String,
    val insuranceImageThumbUrl:String,
    val insuranceTypeName:String,
    )