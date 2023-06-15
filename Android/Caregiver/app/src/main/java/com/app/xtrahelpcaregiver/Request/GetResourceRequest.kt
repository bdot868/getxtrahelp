package com.app.xtrahelpcaregiver.Request

data class GetResourceRequest(
    var data: ResourceRequest
)

data class ResourceRequest(
    var langType: String,
    var token: String,
    var categoryId: String,
    var search: String,
    var page: Int,
    var limit: String
)