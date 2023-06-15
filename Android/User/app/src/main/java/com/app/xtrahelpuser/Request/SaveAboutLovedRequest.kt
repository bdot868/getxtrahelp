package com.app.xtrahelpuser.Request

data class SaveAboutLovedRequest(val data: AboutLoveData)

data class AboutLoveData(
    val langType: String,
    val token: String,
    val profileStatus: String,
    val lovedOne: ArrayList<LovedOne>
)

data class LovedOne(
    var lovedDisabilitiesTypeId: String,
    var lovedAboutDesc: String,
    var lovedOtherCategoryText: String,
    var lovedBehavioral: String,
    var lovedVerbal: String,
    var allergies: String,
    var lovedCategory: ArrayList<String>  = ArrayList(),
    var lovedSpecialities: ArrayList<String>,
    var isLovedOne:Boolean
)
