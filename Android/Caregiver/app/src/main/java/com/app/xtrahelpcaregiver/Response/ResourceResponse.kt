package com.app.xtrahelpcaregiver.Response

data class ResourceResponse(
    var data: ArrayList<Resource>,
    var message: String,
    var status: String,
    var totalPages: String
)
data class Resource(
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