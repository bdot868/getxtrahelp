package com.app.xtrahelpuser.Response

data class FeedLikeListResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var totalPages: String
) {
    data class Data(
        var profileImageThumbUrl: String,
        var profileImageUrl: String,
        var userFeedId: String,
        var userFeedLikeId: String,
        var userFullName: String,
        var userId: String
    )
}