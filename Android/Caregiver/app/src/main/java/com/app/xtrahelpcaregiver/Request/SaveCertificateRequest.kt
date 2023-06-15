package com.app.xtrahelpcaregiver.Request

data class SaveCertificateRequest(val data: CertificateData)

data class CertificateData(
    val langType: String,
    val token: String,
    val haveCertificationsOrLicenses: String,
    val profileStatus: String,
    var certificationsOrLicenses: ArrayList<CertificationsOrLicenses>
)

data class CertificationsOrLicenses(
    var licenceTypeId: String,
    var licenceName: String,
    var licenceNumber: String,
    var issueDate: String,
    var expireDate: String,
    var licenceImage: String,
    var description: String
)