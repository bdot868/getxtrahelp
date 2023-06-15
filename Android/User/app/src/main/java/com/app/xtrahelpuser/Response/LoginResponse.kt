package com.app.xtrahelpcaregiver.Response

data class LoginResponse(
    val status:String,
    val message:String,
    val data: LoginData)

data class LoginData(
    val id: String,
    val firstName: String,
    val lastName: String,
    val username: String,
    val email: String,
    val phone: String,
    val password: String,
    val role: String,
    val image: String,
    val verificationCode: String,
    val forgotCode: String,
    val timezone: String,
    val latitude: String,
    val longitude: String,
    val address: String,
    val age: String,
    val gender: String,
    val familyVaccinated: String,
    val hearAboutUsId: String,
    val soonPlanningHireDate: String,
    val profileStatus: String,
    val createdDate: String,
    val updatedDate: String,
    val inboxMsgText: String,
    val inboxMsgMail: String,
    val jobMsgText: String,
    val jobMsgMail: String,
    val caregiverUpdateText: String,
    val caregiverUpdateMail: String,
    val status: String,
    val profileImageName: String,
    val profileImageUrl: String,
    val profileImageThumbUrl: String,
    val fillpassword: String,
    val token: String
)