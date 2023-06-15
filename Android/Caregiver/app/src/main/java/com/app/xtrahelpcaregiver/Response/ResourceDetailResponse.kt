package com.app.xtrahelpcaregiver.Response

data class ResourceDetailResponse(
    var `data`: Data,
    var message: String,
    var status: String
) {
    data class Data(
        var categoryId: String,
        var categoryName: String,
        var createdDate: String,
        var createdDateFormat: String,
        var description: String,
        var imageUrl: String,
        var resourceId: String,
        var thumbImageUrl: String,
        var timing: String,
        var title: String
    )
}