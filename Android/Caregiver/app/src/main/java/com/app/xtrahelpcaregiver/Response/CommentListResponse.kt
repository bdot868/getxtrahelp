package com.app.xtrahelpcaregiver.Response

data class CommentListResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var totalPages: String
) {
    data class Data(
        var comment: String,
        var createdDate: String,
        var id: String,
        var profileImageThumbUrl: String,
        var profileImageUrl: String,
        var status: String,
        var time_ago: String,
        var updatedDate: String,
        var userFeedId: String,
        var userFullName: String,
        var userId: String
    )
}