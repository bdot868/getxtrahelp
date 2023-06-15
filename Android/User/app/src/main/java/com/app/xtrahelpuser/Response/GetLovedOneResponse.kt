package com.app.xtrahelpuser.Response

data class GetLovedOneResponse(
    var data: ArrayList<LovedResponse>,
    var message: String,
    var status: String
) {
    data class LovedResponse(
        var allergies: String,
        var loveSpecialitiesData: ArrayList<LoveSpecialitiesData>,
        var lovedAboutDesc: String,
        var lovedBehavioral: String,
        var lovedCategoryData: ArrayList<LovedCategoryData>,
        var lovedDisabilitiesTypeId: String,
        var lovedDisabilitiesTypeName: String,
        var lovedOtherCategoryText: String,
        var lovedVerbal: String,
        var userAboutLovedId: String,
        var userId: String
    ) {
        data class LoveSpecialitiesData(
            var lovedSpecialitiesId: String,
            var lovedSpecialitiesName: String,
            var userId: String,
            var userLovedSpecialitiesId: String
        )

        data class LovedCategoryData(
            var lovedCategoryId: String,
            var lovedCategoryName: String,
            var userId: String,
            var userLovedCategoryId: String
        )
    }
}