package com.app.xtrahelpcaregiver.Request

data class SavePersonalDetailRequest(
    val data: SavePersonalDetail
)

data class SavePersonalDetail(
    val langType: String,
    val token: String,
    val firstName: String,
    val lastName: String,
    val image: String,
    val phone: String,
    val age: String,
    val gender: String,
    val familyVaccinated: String,
    val hearAboutUsId: String,
    val profileStatus: String
)