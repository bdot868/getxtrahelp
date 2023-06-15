package com.app.xtrahelpcaregiver.Request

data class SaveAddressRequest(
    val `data`: SaveAddress
)

data class SaveAddress(
    val langType: String,
    val token: String,
    val address: String ,
    val latitude: String,
    val longitude: String
)