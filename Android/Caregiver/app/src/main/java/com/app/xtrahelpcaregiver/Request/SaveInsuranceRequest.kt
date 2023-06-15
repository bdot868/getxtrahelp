package com.app.xtrahelpcaregiver.Request

data class SaveInsuranceRequest(val data: SaveInsurance)

data class SaveInsurance(
    val langType: String,
    val token: String,
    val haveInsurance: String,
    val profileStatus: String,
    val insurance: ArrayList<Insurance>
)

data class Insurance(
    var insuranceTypeId: String,
    var insuranceName: String,
    var insuranceNumber: String,
    var expireDate: String,
    var insuranceImage: String,
)