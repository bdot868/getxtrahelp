package com.app.xtrahelpcaregiver.Response

data class GetCertificationsLicensesResponse(
    val status: String,
    val message: String,
    val data: ArrayList<CertificationsOrLicenses>
)

data class CertificationsOrLicenses(
    val userCertificationsLicensesId: String,
    val userId: String,
    val licenceTypeId: String,
    val licenceName: String,
    val licenceNumber: String,
    val issueDate: String,
    val expireDate: String,
    val description: String,
    val licenceImageName: String,
    val licenceImageUrl: String,
    val licenceImageThumbUrl: String,
    val licenceTypeName: String
)